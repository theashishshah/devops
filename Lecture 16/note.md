# Database Backups: How They Work, Production Options, and Practice Projects

---

## 1. Why back up databases?

- **Disaster:** disk failure, accidental `DROP TABLE`, ransomware, bad deploy.
- **Compliance:** audits often require retention and restore tests.
- **Recovery goals (industry terms):**
  - **RPO (Recovery Point Objective)** — how much data you can afford to *lose* (e.g. “at most 1 hour of transactions”).
  - **RTO (Recovery Time Objective)** — how fast you must be *back online* (e.g. “within 4 hours”).

Backups are not “copy once”; they’re a **policy**: what to copy, how often, where to store it, and how you **prove** you can restore.

---

## 2. Two big families: logical vs physical

| Type | What you copy | Typical tools | Pros | Cons |
|------|----------------|---------------|------|------|
| **Logical** | SQL statements or rows (text/binary dump) | `mysqldump`, `pg_dump` | Portable, easy to grep, works across versions often | Slower on huge DBs; restore = replay SQL |
| **Physical** | Data files / disk blocks as the engine stores them | Percona XtraBackup (MySQL), `pg_basebackup`, storage snapshots | Fast for large DBs; good for “whole server” clone | Tied to engine version; more ops complexity |

**Beginner mental model:**  
- **Logical** = export “meaning” (SQL).  
- **Physical** = copy “files on disk” the DB uses.

---

## 3. Backup “shapes” (full / incremental / differential)

1. **Full backup** — entire database every time.  
   - Simple; largest storage and longest run time.

2. **Differential** — since last **full** backup (common in some Windows/enterprise tools; less universal in open-source DB CLI naming).

3. **Incremental** — only changes since last backup (full or incremental).  
   - Saves space/time; **restore** chains: full + all incrementals in order.

4. **Continuous / point-in-time (PITR)** — for engines that support transaction logs (e.g. PostgreSQL WAL, MySQL binlog):  
   - Take periodic **base** backup + **archive logs** → restore to **any second** between backups.

**Production:** Small/medium apps often use **daily full logical** + **off-site copy**. Large systems add **PITR** or **physical** + **incrementals**.

---

## 4. Ways used in production (with examples)

### 4.1 Logical dump with CLI (most common starting point)

**MySQL / MariaDB — `mysqldump`**

```bash
# Full DB, gzip, one file
mysqldump -h localhost -u backup_user -p mydb | gzip > mydb_$(date +%F).sql.gz
```

**PostgreSQL — `pg_dump`**

```bash
pg_dump -h localhost -U backup_user -Fc mydb > mydb_$(date +%F).dump
# -Fc = custom format (compressed, parallel restore with pg_restore)
```

**When:** nightly jobs, small/medium DBs, easy restores to another host.

**Industry extras:** dedicated **backup user** with minimal privileges; dumps written to disk then **synced to S3/GCS** (not only local disk).

---

### 4.2 Scheduled jobs (cron / systemd / container)

**Host cron (Linux):**

```cron
0 2 * * * /usr/local/bin/backup-mysql.sh >> /var/log/db-backup.log 2>&1
```

**Docker (like your blog stack):** image `mysql-cron-backup` with `CRON_TIME` + env vars — backup runs **inside** a sidecar container; volume mounts store `.sql.gz` files.

**When:** you control the VM or Swarm/K8s and want **repeatable** automated dumps.

---

### 4.3 Physical / hot backup (large MySQL)

**Percona XtraBackup** — copies InnoDB data files **while MySQL runs** (with care for consistency).

**When:** TB-scale MySQL where `mysqldump` is too slow or locks are unacceptable.

**Beginner:** skip until you outgrow logical dumps; ops teams own this.

---

### 4.4 PostgreSQL: `pg_basebackup` + WAL archiving (PITR)

- **`pg_basebackup`** — physical base backup.
- **Archive `WAL` files** to safe storage → restore to a **point in time**.

**When:** production Postgres needing **near-zero** data loss.

---

### 4.5 Storage / volume snapshots (cloud & enterprise)

- **AWS EBS snapshot**, **GCP disk snapshot**, **Azure disk snapshot** — point-in-time copy of the **volume** under the data directory.
- **Pros:** fast, infrastructure-level.  
- **Cons:** must **quiesce** or use engine-aware snapshot (or accept crash-recovery on restore); wrong use can mean **corrupt** DB if files are mid-write without DB cooperation.

**When:** large datasets, DR strategy with **vendor docs** for “consistent snapshot” for that DB engine.

---

### 4.6 Managed databases (RDS, Cloud SQL, Aurora, etc.)

- Provider offers **automated backups**, **retention window**, **PITR** in the console/API.
- You configure backup window and retention; restores create a **new instance** from backup.

**When:** most teams prefer this for production to offload patching and backup plumbing.

---

### 4.7 Backup from a **replica** (read replica)

- Run heavy `mysqldump` / `pg_dump` against a **replica** so the **primary** stays fast for users.

**When:** read load is separated; replication lag is acceptable for backup freshness.

---

### 4.8 Application-level export

- Export critical tables to CSV/JSON via app or ETL (not a full DB substitute).

**When:** compliance exports, analytics, partial recovery; **not** a replacement for full DB backup for disaster recovery.

---

### 4.9 Binlog / WAL shipping to object storage

- **MySQL binlog** or **Postgres WAL** streamed/archived to S3 — enables **PITR** and sometimes **replication** to analytics.

**When:** mature production and compliance needs.

---

## 5. What “good” looks like in industry

1. **3-2-1 rule (classic):** 3 copies, 2 media types, 1 off-site.
2. **Encrypt backups** at rest (and in transit to cloud).
3. **Test restores** quarterly (or automated): a backup nobody has restored is a **hope**, not a guarantee.
4. **Secrets:** backup jobs use **least-privilege** DB users; passwords from secrets managers / env / files — not in Git.
5. **Monitor:** alert if backup job fails or output file size drops to zero.

---

## 6. Quick comparison table

| Approach | Complexity | Typical size fit | PITR |
|----------|------------|------------------|------|
| mysqldump / pg_dump + cron | Low | Small–medium | No (unless + binlog/WAL) |
| Docker cron backup sidecar | Low–medium | Same | No |
| Managed DB backups | Low (ops) | Any (vendor limits) | Often yes |
| Volume snapshot | Medium | Large | Depends |
| XtraBackup / pg_basebackup + WAL | High | Large | Yes (Postgres WAL path) |

---

## 7. Beginner practice projects

Do these in order; use **Docker** so you don’t need a cloud account for the first ones.

### Project A — Manual dump and restore (MySQL or Postgres)

1. Run DB in Docker with a small schema (one table, a few rows).
2. **`mysqldump` or `pg_dump`** to a `.sql` file on your host (volume mount).
3. **Drop the database** (or delete the volume) and **restore** from the file.
4. **Success:** data matches what you had before.

**Learn:** logical backup lifecycle end-to-end.

---

### Project B — Nightly backup script + local log

1. Write `backup.sh` that dumps DB and names file `db_$(date +%F_%H%M).sql.gz`.
2. Append one line to a log file: `OK` or `FAIL` with timestamp.
3. Run it manually until it works; then add a **cron** entry (or run every minute in dev to test).

**Learn:** automation + observability (logs).

---

### Project C — Docker sidecar backup (like production stacks)

1. Use `docker compose` with `mysql` + `fradelg/mysql-cron-backup` (or similar).
2. Mount a **named volume** for `/backup`.
3. Set `CRON_TIME` to every minute for testing; then change to daily.
4. Open the backup file and verify it contains `CREATE TABLE` / data.

**Learn:** same pattern as Swarm/K8s “sidecar” backups.

---

### Project D — Off-site copy (beginner cloud)

1. After Project B, upload the latest `.gz` to **S3** or **Google Cloud Storage** using CLI (`aws s3 cp` or `gsutil cp`) with a **restricted IAM** user.
2. **Success:** file appears in bucket; try download + restore on a **second** machine or fresh container.

**Learn:** backups are not real until they survive **disk loss** on the server.

---

### Project E — Restore drill (most important)

1. Take last week’s backup (or a fresh one).
2. On a **clean** Docker DB container, restore **only** from that file.
3. Time yourself and note any manual steps — that’s your **RTO** estimate.

**Learn:** backup policy is incomplete without a **tested** restore.

---

## 8. One-line recap

- **Production** mixes **logical dumps**, **scheduled automation**, **replica** targets, **managed** backups, **snapshots**, and **log-based PITR** depending on size and risk.
- **You** should master **dump + schedule + verify + off-site copy + restore test** first; everything else builds on that.
