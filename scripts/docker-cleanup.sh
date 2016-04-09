# Work-in-progress file for cleaning up the Docker environment and unused containers to free up space.

## take backup of all DBs
docker exec -i drupaldevdocker_db_1 bash -c "mysqldump --all-databases > /etc/mysql/conf.d/all_databases.sql"

## re-omport when ready if required
mysql -u root -ppassword < all_databases.sql

## cleanup docker images and containers and volumes
docker rmi $(docker images -f "dangling=true" -q)
docker rm -v $(docker ps -a -q -f status=exited)
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker --rm martin/docker-cleanup-volumes
