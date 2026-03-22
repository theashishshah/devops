# Production Monitoring (Lecture 17)

In this lecture, we learned how industry-standard monitoring and observability are implemented in production environments using the **Prometheus + Grafana + cAdvisor** stack.

Detailed documentation is available here: [monitoring_guide.md](file:///Users/ashishshah/Downloads/Ashish%20Shah/Web%20Dev/Projects/learnit/devops/Lecture%2017%20Last/monitoring_guide.md)

### Key Tools & Roles:
1.  **Prometheus**: The central engine that collects and stores metrics (numerical data).
2.  **Grafana**: The visualization layer for real-time dashboards and alerts.
3.  **cAdvisor (Google)**: A tool that monitors resource usage of all containers on a host.
4.  **The Three Pillars of Observability**: Metrics (Numerical), Logs (Text-based), and Traces (Request Flow).

### Golden Signals of Monitoring:
*   **Latency**: How long requests take.
*   **Traffic**: How much load the system is under.
*   **Errors**: How many requests are failing.
*   **Saturation**: How much "room" is left in the system (CPU/RAM).
