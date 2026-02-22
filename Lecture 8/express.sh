sudo docker run -d --name express-db -v express-db-vol:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root --network express-net mysql

docker run -d --rm --name db -e MYSQL_ROOT_PASSWORD=root -v express-db-vol:/var/lib/mysql --network express-net mysql

docker build -t image-name:version(optional) .(Dockerfile is in current dir) 

# we can connet/remove docker container from a network to another
# we can see the logs of a docker container
docker logs container-name