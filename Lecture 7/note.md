# Docker Networking and Volumes

## Overview
Docker provides networking so containers can talk to each other and the host, and volumes for persistent or shared data. Networks let containers communicate; volumes let data outlive container lifecycles.

---

## `docker network ls`
Lists all Docker networks on the host. Use it to inspect existing networks and choose one for your containers.

---

## Default network types
When Docker is installed, it creates three virtual network interfaces by default:

1. **bridge** — Default network for containers. Each container gets its own IP on a private subnet. Containers on the bridge network can reach each other by IP, but not by container name unless they share a custom bridge. Good for typical workloads.

2. **host** — No network isolation: the container shares the host’s network stack. The container’s network is the host’s network, so no port mapping. Useful for performance or low-level access. On Linux, it removes network isolation; on Mac/Windows, behavior differs because of the VM layer.

3. **null** (also called **none**) — No networking at all. The container has only a loopback interface. Use for batch jobs or when a container must not access the network.



- docker bridge acts as router and using this any container in the local can access other containers and in production this is not the best practice, so we define our own network know user defined bridge network and we use that.


explore more:
1. overlay network
2. macvlan network
3. host network