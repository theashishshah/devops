# Lecture 17: Production Monitoring & Observability

In the tech industry, monitoring isn't just about knowing if a server is "up" or "down"—it's about **Observability**. This guide explains how modern production systems are monitored using industry-standard tools and practices.

---

## 1. Monitoring vs. Observability

*   **Monitoring**: Tells you *when* something is wrong (e.g., "The CPU is at 99%"). It is often reactive.
*   **Observability**: Tells you *why* something is wrong by looking at the internal state of the system through its outputs (Metrics, Logs, Traces). It is proactive and deep.

---

## 2. The Three Pillars of Observability

To understand a production system, we collect three types of data:

1.  **Metrics (The "What")**:
    *   Numerical data over time (Time-series).
    *   Examples: CPU usage, Memory, Request Count, Error Rate.
    *   *Standard Tools*: **Prometheus**, InfluxDB, VictoriaMetrics.
2.  **Logs (The "Why")**:
    *   Timestamped text records of events.
    *   Examples: "User X failed to login", "Database connection timeout".
    *   *Standard Tools*: **ELK Stack** (Elasticsearch, Logstash, Kibana), **Grafana Loki**, Splunk.
3.  **Traces (The "Where")**:
    *   Tracks a single request as it travels through multiple microservices.
    *   Helps find bottlenecks in complex systems.
    *   *Standard Tools*: **Jaeger**, Zipkin, Honeycomb.

---

## 3. The Standard Monitoring Stack: Prometheus + Grafana + cAdvisor

This is the "Golden Trio" for containerized environments (Docker/Kubernetes).

### A. cAdvisor (Container Advisor)
*   **Role**: The "Spy".
*   Created by Google, it runs as a container and looks into all other containers on the same host.
*   It collects resource usage (CPU, Memory, Network, Disk) and exposes them as metrics.

### B. Prometheus
*   **Role**: The "Collector" & "Database".
*   It **pulls** (scrapes) metrics from cAdvisor and other "Exporters" every few seconds.
*   It stores this data in a **Time Series Database (TSDB)**.
*   It has its own query language called **PromQL**.

### C. Grafana
*   **Role**: The "UI" / "Dashboard".
*   It connects to Prometheus as a data source.
*   It creates beautiful, real-time graphs and alerts.
*   Industry standard because it can pull data from almost anywhere (SQL, Prometheus, Loki, etc.).

---

## 4. The "Golden Signals" of Monitoring

In production, SREs (Site Reliability Engineers) focus on these four signals to judge system health:

1.  **Latency**: Time it takes to service a request.
2.  **Traffic**: Demand placed on the system (e.g., HTTP requests per second).
3.  **Errors**: The rate of requests that fail (explicitly, implicitly, or by policy).
4.  **Saturation**: How "full" your service is (e.g., memory usage or thread pool limits).

---

## 5. How Alerting Works

Monitoring is useless if no one knows there is a problem.
*   **Alertmanager**: A component of Prometheus that handles alerts.
*   **Flow**: Prometheus identifies a threshold breach (e.g., Error Rate > 5% for 2 mins) → Sends alert to Alertmanager → Alertmanager de-duplicates and routes it to **Slack**, **PagerDuty**, or **Email**.

---

## 6. Industry Workflow Summary

1.  **Instrument**: Add libraries to your code or use "Exporters" (like Node Exporter or cAdvisor) to generate metrics.
2.  **Scrape**: Prometheus pulls these metrics at intervals.
3.  **Visualize**: Grafana displays the metrics on big screens in the "War Room" or on developer laptops.
4.  **Alert**: If something breaks, the team gets a ping on Slack or a phone call (PagerDuty).
5.  **Debug**: Use logs (Loki/ELK) and traces (Jaeger) to find the exact code line that caused the issue.

---

### Comparison Table

| Tool | Purpose | Analogy |
| :--- | :--- | :--- |
| **Prometheus** | Metric Collection & Alerting | The Brain / Database |
| **Grafana** | Visualization | The Eyes / TV Screen |
| **cAdvisor** | Container Resource Stats | The Health Monitor (Pulse) |
| **Loki / ELK** | Log Management | The Diary of Events |
| **Jaeger** | Distributed Tracing | The GPS tracker for a request |
