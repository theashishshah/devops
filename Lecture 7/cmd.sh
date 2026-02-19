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