docker compose up -d
docker compose down 
export VARIABLE=value
docker compose ps # to list all containers in docker compose file
# by default it creates a bridge network but it is not attached with default bridge 
docker volume ls | grep blog-db
# create mysql db on local machine
docker compose logs