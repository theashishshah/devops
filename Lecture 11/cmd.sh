docker build --platform platform-name -t username/image-name:version filepath
docker login -u username
docker push same-name:version

# to make cluster, all machines should have docker installed

docker swarm init  # to join 2377 PORT, TCP and UDP port expose
docker info
docker swarm join-token worker/manager
# configure port 


# after doing all these, a cluster has created and now we can inspect network
docker network ls
docker node ls # to see connections

# bring compose file into manager node: why?
docker stack deploy -c compose.yml name-stack
docker stack
docker service ls

# now how can i see where?
docker service ps name-of-service
docker logs id

# we can configure that database server should run on a fixed machine because it might store data locally on that machine

# we can use IP of any node to access our application and this is done by overlay network
# we can provide all IP pool to load balancer and all servers will be accessible
# docker in background runs a container, named: ingress-box [acts as reverse proxy]

# use Tunnel VXLAN. ingress-box servers communicates between each other. port 4789[tunnel port]




## Scalling:
# on managers servers:
docker service scale server-name=number[30] # this is temp
# use docker compose file for 
# to downscale use number less



## Zero downtime deployment:
# change server code -> rebuild image -> push docker hub -> manager and change image -> update the service
docker service update --force name-of-service


## How to test zero downtime deployment:
# use autocannon library

npx autocannon -c 10 -d 10 url