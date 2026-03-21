# Production Docker Stack: Blog App (Swarm + Compose)

This note walks through a **real production-style** setup: a blog app with MySQL, a Node API, Caddy as reverse proxy/TLS, and scheduled DB backups. Use it later as a checklist when you read similar YAML or Dockerfiles.

---

## 1. Big picture: what runs where?

| Piece | Role |
|--------|------|
| **blog-db** | MySQL — stores data; pinned to a specific node so the disk stays on one machine. |
| **blog-server** | Node app — API; **2 replicas** for availability; talks to DB by service name `blog-db`. |
| **caddy** | Reverse proxy — HTTP/HTTPS on 80/443; serves TLS and routes traffic to your app. |
| **db-backup** | Cron-style backup — dumps DB to a volume on a schedule. |

All services share the **overlay network** `blog-app-net` so they resolve each other by **service name** (e.g. `blog-db`, not an IP).

**Industry:** Splitting DB, app, proxy, and backup into separate services is standard — each can scale, update, or fail independently.

---

## 2. Why Docker Swarm / `deploy:` blocks?

Plain `docker-compose` on one machine ignores `deploy:` unless you use **Docker Stack** (`docker stack deploy`). In **Swarm mode**, `deploy:` is what Swarm reads to schedule replicas, placement, and rolling updates.

- **replicas** — how many copies of a service run (load + redundancy).
- **placement.constraints** — “only run this task on nodes that match this label” (e.g. DB on a dedicated server).

**Industry:** Same ideas appear in Kubernetes (node selectors, affinity). Swarm is simpler but the goals match: **stateful DB on stable hardware**, **stateless app scaled out**.

---

## 3. Service by service

### 3.1 `blog-db` (MySQL)

**What it does:** Runs MySQL with data in a **named volume** `blog-db-vol` so data survives container restarts.

**Placement:**

```yaml
placement:
  constraints:
    - node.labels.dbwala == true
```

**Meaning:** Only nodes labeled `dbwala=true` can run this task. You label a node once (e.g. `docker node update --label-add dbwala=true <node>`).

**Why:** MySQL data is on **local disk** for that volume. If the DB container jumped between nodes, you’d need shared storage (NFS, cloud disk) or you’d lose the “one place for data” mental model. Pinning the DB is a common pattern until you use a managed DB or clustered MySQL.

**Secrets:**

```yaml
MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db_password
secrets:
  - db_password
```

**Why:** Passwords are not in the compose file or env as plain text. Swarm mounts secrets under `/run/secrets/`. **Industry:** Same as K8s Secrets — never commit real passwords to Git.

**External secrets:**

```yaml
secrets:
  db_password:
    external: true
```

You create them on the cluster first (`docker secret create ...`). Stack references **existing** secrets.

**Ports `3306:3306`:** Publishes MySQL on the host. In production you often **don’t** expose DB to the public internet — only app subnet or VPN. Here it’s useful for debugging; tighten firewall/security groups in real prod.

**Healthcheck `mysqladmin ping`:** Swarm knows the DB is “up” before routing dependent logic; failed health → task restart.

---

### 3.2 `blog-server` (Node app)

**Image:** Pre-built image from a registry (example tag from CI).

**Replicas: 2:** If one task dies, the other still serves traffic → **high availability** basics.

**Environment:**

```yaml
DB_HOST=blog-db
```

On the overlay network, **`blog-db` is the stable DNS name** for the DB service. No hard-coded IPs.

**Secrets for app user:**

```yaml
DB_USER_FILE=/run/secrets/db_username
DB_PASSWORD_FILE=/run/secrets/db_password
```

App reads username/password from files — again avoiding env plaintext for credentials.

**`NODE_HOST="{{.Node.Hostname}}"`:** Swarm template — each task gets its **node’s hostname**. Useful for logs or debugging which machine handled a request.

**Healthcheck `wget` → `http://localhost:3000/health`:** Inside the container, the app listens on **3000**; the check hits **localhost** from inside the same container. **Industry:** Every service should expose `/health` (or similar) for orchestrators and load balancers.

**Ports `3001:3000`:** Host 3001 → container 3000. External users often hit **Caddy on 80/443**, not this port directly.

---

### 3.3 `caddy` (reverse proxy)

**Role:** Terminates TLS, routes `http(s)://yourdomain` to `blog-server` (you’d configure upstream in `Caddyfile`).

**Configs:**

```yaml
configs:
  - source: Caddyfile
    target: /etc/caddy/Caddyfile
```

**Swarm configs** inject the Caddyfile into the container — config as part of the stack, versioned with your repo.

**Volumes `caddy_data`, `caddy_config`:** Persist TLS certs and Caddy’s internal state across restarts.

**Industry:** Nginx, Traefik, Caddy — same slot: **one entry point**, SSL, optional rate limits, headers.

---

### 3.4 `db-backup`

**Image `fradelg/mysql-cron-backup`:** Runs mysqldump on a **cron** schedule.

**`CRON_TIME=* * * * *`:** Every minute (good for demos; in prod use something like `0 2 * * *` for nightly).

**`MYSQL_HOST=blog-db`:** Uses the same service name — backup container reaches DB over the overlay network.

**Volume `mysql_backup`:** Dump files land here — **backup survives container replacement**. Copy this volume off-box or sync to object storage for real DR.

**Placement `dbwala`:** Same as DB — keeps backup job near the DB node (latency, same network assumptions).

**Industry:** Automated backups + retention (`MAX_BACKUPS`) + gzip are baseline; off-site copies are the next step.

---

## 4. `deploy.update_config` and `rollback_config` (rolling updates)

```yaml
update_config:
  order: start-first
  failure_action: rollback
  delay: 10s
rollback_config:
  parallelism: 1
  order: start-first
```

- **`order: start-first`:** Start the **new** task before stopping the old one → helps **zero-downtime** for stateless services (more overlap while both are healthy).
- **`failure_action: rollback`:** If the new version fails health checks, Swarm **rolls back** to the previous working spec.
- **`delay: 10s`:** Pause between update batches — reduces thundering herd and gives health checks time.
- **`rollback_config`:** How rollback behaves (e.g. one task at a time with `parallelism: 1`).

**Industry:** Same ideas as Kubernetes `RollingUpdate` strategy — **surge**, **max unavailable**, **rollback on failure**.

---

## 5. Networks, volumes, secrets (summary)

| Concept | Purpose |
|---------|--------|
| **networks: blog-app-net** | Private DNS between services (`blog-db`, `blog-server`, …). |
| **volumes** | Persist MySQL data, Caddy certs, backup files. |
| **secrets (external)** | Created once on Swarm; referenced by name; not in Git. |

---

## 6. The Dockerfile (multi-stage) — line by line idea

### Stage 1: `builder`

- **`FROM node:22-slim`:** Smaller base than full `node` image → **smaller attack surface and faster pulls**.
- **`npm ci`:** Reproducible installs from lockfile (CI/CD standard).
- **`npm run build`:** Produces `dist/` (or similar) production assets.
- **`npm prune --omit-dev`:** Removes devDependencies after build so the next stage doesn’t need them.

### Stage 2: `runner`

- **Only copies `dist/`, `node_modules`, `wait-for-it.sh`** — final image has **no source**, **no dev deps** → **smaller image** (aligns with Lecture 14 goals: optimize size, security).

- **`wget` installed:** Needed for **healthchecks** in Swarm (`wget` in the compose healthcheck).

- **`EXPOSE 3001`:** Documents intent; the compose maps `3001:3000` — the app inside listens on **3000** in your stack snippet; adjust if your `index.js` listens on 3001 instead (keep **compose port mapping** and **healthcheck URL port** consistent).

- **`useradd` + `USER appuser`:** Process does **not** run as root → **industry best practice** (if container is compromised, harder to escalate).

- **`ENTRYPOINT wait-for-it.sh blog-db:3306 --`:** Waits until MySQL accepts connections **before** starting Node — avoids crash loops when the app starts faster than the DB.

- **`CMD ["node", "index.js"]`:** Default process.

**Why multistage + prune in industry:** Smaller images = faster deploys, less storage, fewer packages to patch. Secrets at runtime stay in Swarm/K8s, not in the image.

---

## 7. End-to-end flow (mental model)

1. **Build** app image in CI (Dockerfile) → push to registry with a tag (commit SHA or semver).
2. **Secrets** created on Swarm (`db_password`, `db_username`).
3. **Label** the DB node `dbwala=true`.
4. **`docker stack deploy -c compose.yml blog`** (or your stack name).
5. Swarm schedules **blog-db** on the labeled node, **blog-server** ×2, **caddy**, **db-backup**.
6. **Rolling updates:** New image → `start-first` → health OK → old tasks drain; failure → **rollback**.
7. **Backups** run on schedule to `mysql_backup` volume.

---

## 8. Quick recap (Lecture 14 themes)

| Topic | What you practiced |
|--------|-------------------|
| **Smaller images** | Multistage build, `npm prune --omit-dev`, slim base |
| **Security** | Non-root user, Swarm secrets, no passwords in YAML |
| **Production deploy** | Replicas, healthchecks, placement, rolling updates + rollback |
| **Operations** | Caddy for TLS, DB pinned + backups |

When you come back to this file, read **§3** for “what each service does”, **§4** for updates, **§6** for the Dockerfile, and **§7** for the full story.
