sudo apt install docker.io
ip a

sudo docker network ls # to see docker network interfaces
sudo docker run -d --rm --name nginx1 imagename  # to run a container, detach mode, --rm removes automatically after stopping container name

free -h # to see RAM details
lscpu # to see CPU details
mpstat # to see CPU uses states
df -h # disk free, to see disk details

sudo docker stats # to see docker Live Resource Usage
sudo docker ps -a # to see Container List (Status View) even stopped containers using -a
sudo docker start # to start stopped containers
sudo docker inspect conatiner-name # To see low level container details


# how two container interact with each other
docker exec -it docker-name shell-name # to go inside any container in interactive mode
apt install iputils-ping -y # to install util for networking because it doesn't has anything

# we normally don't use default bridge network in production because it creats local network and that can lead to access all other containers

sudo docker network create --driver bridge network-name
docker network ls
docker network inspect network-name # to inspect about network

# docker also provide DNS resolution with it, so I can access contianers without specifying their IP