# We can attach one container with multiple networks
sudo docker netwrok connect netname containername # to connect with multiple data
docker rm container-name # removes data
docker stop container-name # doesn't remove data
docker run -d --name db-name -e NAME=value, NAME2=value image-name[mysql]
sudo docker run -d --name database -e MYSQL_ROOT_PASSWORD=root mysql
sudo docker exec -it database-name /bin/bash
mysql -u root -p # mysql login user root, and password p

# sql database 
show databases;
create database if not exists dbname;
exit # to exit from sql
cd /var/lib/mysql


sudo docker stop database
sudo docker remove database
sudo docker run -d --name db -e MYSQL_ROOT_PASSWORD=root mysql
sudo docker exec -it db
sudo docker exec -it db /bin/bash
mysql -u root -p
show databases


docker volume ls
docker run -d --rm --name db -v outer-volume-name:/var/lib/name-of-volume -e MYSQL_ROOT_PASSWORD=root image-name

/var/lib/docker # data persist here outside of docker on my local machine
sudo -i # switch to as root from ubuntu or other user
sudo su username # to switch user from root to normal sudo user

# we can connect existing volume to the new container

# bind mounts: to give env files
./folder:/var/lib/mysql 

sudo apt install docker.io # unofficial way to install docker 