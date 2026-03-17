https://docs.docker.com/engine/swarm/


Learning about docker swarm
Leanring about zero downtime deployment.
- why we need zero downtime deployment and what are the ways to achieve this? 
- how can I achieve zero downtime deployment and why that way works?
- every tech start by solving a problem

1. Learning in this leacture
- docker sworm [ each honeybee is docker engine, and these containers are orchestrated by k8 engine]
- rolling updates
- single point of failure [in production, we always avoid this]
- vertical and horizontal scalling [ using load balancer ]
- load balancer


### Docker sworm: alternatives of K8
- makes cluster of docker engines
- docker managers and docker workers
- gossip network
- internal distributed state store docker [raft consensus group ]




## Projects Ideas:
- achieve zero downtime using docker-compose file only, use proxy.
- Use GCP service for $300 credits