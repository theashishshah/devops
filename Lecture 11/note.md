# Zero-Downtime Deployment (Practicals) with Docker Swarm

## Goal

Deploy new versions of your app **without downtime** by running multiple replicas and updating them gradually (rolling update) while traffic keeps flowing.

---

## Why zero downtime is needed

- **Availability**: users should not see connection drops / 5xx errors during deploys.
- **No single point of failure**: if only one container/server exists, any restart = downtime.
- **Safe releases**: rollout can pause/rollback if something breaks.

---

## Swarm cluster basics (terms)

- **Manager nodes**: keep the cluster state and schedule tasks.
- **Worker nodes**: run tasks/containers assigned by managers.
- **Raft consensus**: managers replicate state; leader election + log replication keeps the cluster consistent.
- **Quorum**: minimum number of managers required to make decisions (prevents split-brain). Losing quorum means the cluster can’t safely update state.

---

## Create a Swarm cluster (high level)

1. Install Docker on all machines.
2. Initialize Swarm on the first manager:

```bash
docker swarm init
docker info
```

3. On other machines, join as worker/manager (use tokens from the manager):

```bash
docker swarm join-token worker
docker swarm join-token manager
```

4. Inspect cluster and networks:

```bash
docker node ls
docker network ls
```

---

## Stack deploy (compose in Swarm)

Bring your `compose.yml` onto the manager and deploy it as a stack:

```bash
docker stack deploy -c compose.yml my-stack
docker stack ls
docker service ls
```

To see where tasks are running:

```bash
docker service ps my-stack_my-service
docker logs <task-or-container-id>
```

---

## How Swarm routes traffic (why any node IP works)

- Swarm uses an **overlay network** so tasks can communicate across nodes.
- Swarm also provides an **ingress routing mesh** so you can hit **any node’s IP** on the published port and Swarm forwards traffic to healthy tasks.
- Internally, Swarm uses tunneling (VXLAN) for the overlay/ingress traffic (commonly port `4789`).

---

## Scaling (horizontal scaling)

Scale a service up/down (quick/manual):

```bash
docker service scale my-stack_my-service=30
```

Better long term: define replicas in the compose/stack file so scaling is declarative.

---

## Zero-downtime deployment workflow (practical)

1. **Change code**
2. **Build a new image** and tag it with a new version.
3. **Push** the image to a registry (e.g. Docker Hub).
4. On the **manager**, update the service to roll out the new version (rolling update).

Typical commands used in your flow:

```bash
docker build --platform <platform> -t <username>/<image>:<version> <path>
docker login -u <username>
docker push <username>/<image>:<version>
```

Then update the running service. One simple approach is forcing a redeploy:

```bash
docker service update --force <service-name>
```

For true versioned rollouts, update the image tag (recommended) so Swarm rolls tasks to the new image:

```bash
docker service update --image <username>/<image>:<new-version> <service-name>
```

### Why this can be “zero downtime”

- With **multiple replicas**, Swarm updates tasks gradually, so some old tasks keep serving while new tasks start.
- If health checks are configured, Swarm can avoid routing traffic to unhealthy tasks and can pause/rollback on failure (depending on update config).

---

## Testing zero downtime (load test)

Use `autocannon` to generate traffic while you deploy:

```bash
npx autocannon -c 10 -d 10 <url>
```

If the deploy is truly zero-downtime, you should see responses continue throughout the rollout (no connection resets / minimal 5xx).

---

## Notes / real-world consideration

- Databases are harder: you often want DB tasks pinned to specific nodes (if using local disk) or use managed/external DB so app replicas can scale freely.
- Always aim to avoid a single replica in production if you care about uptime.
