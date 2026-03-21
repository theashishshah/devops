# Reverse Proxy and Cron Jobs (Beginner → Production)

This note matches the style of **Lecture 14**: big picture first, then each piece, why it exists in industry, and commands you can reuse.

---

## 1. Big picture

| Topic | One-line role |
|--------|----------------|
| **Reverse proxy** | Sits in front of your app; clients talk to **one** host/port; proxy forwards to real servers (TLS, routing, load balancing). |
| **Cron** | Runs commands **on a schedule** (every minute, daily, etc.) without you logging in each time. |

Together: a proxy is how users reach your services safely; cron is how you automate backups, cleanups, and recurring tasks (like the DB backup job you saw with `CRON_TIME=* * * * *`).

---

## 2. Reverse proxy

### 2.1 What it is

- **Normal proxy (forward):** browser → proxy → internet (e.g. corporate proxy).
- **Reverse proxy:** internet → **proxy** → **your** app servers (user does not talk to the app container’s IP directly).

The proxy listens on **80** (HTTP) and **443** (HTTPS). It can:

- Terminate **TLS** (SSL certificates).
- Route by **hostname** or path (`api.example.com` vs `www.example.com`).
- **Load balance** across multiple app replicas.
- Add **headers**, rate limits, gzip, WebSockets.

### 2.2 Why it’s required in industry

- **Security:** App processes don’t need to hold certificates or be exposed on public ports directly.
- **One entry point:** Firewall opens 80/443 only; internal services stay on private networks.
- **Scaling:** Add more app containers; proxy distributes traffic (same idea as Swarm ingress or K8s Ingress).

### 2.3 Common tools

- **Caddy** — Automatic HTTPS, simple config (you used it in the blog stack).
- **Nginx** — Very common, flexible.
- **Traefik** — Often used with Docker/Kubernetes for dynamic routing.

### 2.4 Mental model

```text
User  --->  [ Reverse proxy :443 ]  --->  App container(s) :3000
```

Your **compose** published `80` and `443` on **Caddy**, not on every app replica — that’s reverse proxy in practice.

---

## 3. Cron jobs

### 3.1 What cron is

**Cron** is Linux’s job scheduler. You define **when** to run a command and **which** command.

Use cases:

- Database backups (`mysqldump` on a schedule).
- Log rotation / cleanup.
- Certificate renewal helpers (sometimes).
- Health pings or report generation.

### 3.2 Crontab: user vs system

| Location | Who runs jobs | Typical use |
|----------|----------------|-------------|
| **`crontab -e`** (current user) | That user | Your scripts, no need for root if permissions allow. |
| **`sudo crontab -e`** (root) | root | Tasks that need root (e.g. system paths, certain backups). |
| **`/etc/crontab`** | System-wide file | Format includes **which user** runs the job (see below). |

**Industry:** Prefer **least privilege** — don’t use root cron if a normal user + file permissions is enough.

### 3.3 The five fields (schedule)

Each line in a user crontab looks like:

```text
* * * * * command-to-run
│ │ │ │ │
│ │ │ │ └─── day of week (0–7, Sunday=0 or 7)
│ │ │ └───── month (1–12)
│ │ └─────── day of month (1–31)
│ └───────── hour (0–23)
└─────────── minute (0–59)
```

**Examples:**

| Expression | Meaning |
|------------|--------|
| `* * * * *` | Every minute |
| `0 * * * *` | Every hour at minute 0 |
| `0 2 * * *` | Daily at 02:00 |
| `*/15 * * * *` | Every 15 minutes |
| `0 0 * * 0` | Weekly, Sunday at midnight |

Your lecture image (`crontab.png`) usually illustrates these five columns — keep it open while editing until the pattern is muscle memory.

### 3.4 `/etc/crontab` format (six fields)

System crontab often has a **user** column after the time fields:

```text
* * * * * username command
```

So the **sixth** field is **which system user** runs `command`. That’s why `cmd.sh` shows:

```text
* * * * * username
```

(Replace `username` with a real user like `root` or `backup`.)

### 3.5 Commands you’ll use

```bash
# Edit your user’s crontab (opens editor)
crontab -e

# List current user’s cron jobs
crontab -l

# Edit system-wide schedule (needs root; format includes user column)
sudo vim /etc/crontab
```

**Note:** Your notes had `crontab l` — the correct flag is **`crontab -l`** (dash + letter **l** for “list”).

### 3.6 Docker / Swarm and cron

- On a **bare Linux server**, you install cron and use `crontab`.
- In **containers**, people often either:
  - run a **dedicated image** that bundles cron + your job (e.g. `mysql-cron-backup` with `CRON_TIME`), or
  - use **Kubernetes CronJob** / **systemd timers** on the host.

Same **idea** (schedule + command); different **place** it runs.

---

## 4. How this ties to your earlier stack

- **Caddy** = reverse proxy in front of the blog app.
- **db-backup** container = **cron inside the container** (`CRON_TIME=* * * * *` in env) — production pattern without editing host `crontab` manually.

---

## 5. Industry checklist

**Reverse proxy**

- [ ] TLS on 443; redirect HTTP → HTTPS where possible.
- [ ] Only proxy exposes public ports; apps on internal network.
- [ ] Health checks upstream (remove bad backends).

**Cron / scheduling**

- [ ] Use least-privilege user.
- [ ] Log output (`>> /var/log/backup.log 2>&1` or systemd journal).
- [ ] Test schedule in staging (don’t run heavy jobs every minute in prod).
- [ ] Monitor failures (alert if backup job doesn’t produce a file).

---

## 6. Quick recap

- **Reverse proxy** = single front door (TLS, routing, scale); **Caddy/Nginx/Traefik** are typical choices.
- **Cron** = time-based automation; **`crontab -e` / `crontab -l`** for users; **`/etc/crontab`** for system jobs with a **user** column.
- **Five stars** `* * * * *` = minute, hour, day-of-month, month, day-of-week — learn this once, use everywhere (Linux cron, many SaaS schedulers, Docker backup images).

When you reopen this file, jump to **§2** for proxy, **§3** for cron syntax and commands.
