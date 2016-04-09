# Work-in-progress file for cleaning up the Docker environment and unused containers to free up space.

mysqldump --all-databases > all_databases.sql
mysql -u root -ppassword < all_databases.sql
docker rmi $(docker images -f "dangling=true" -q)
docker rm -v $(docker ps -a -q -f status=exited)
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker --rm martin/docker-cleanup-volumes