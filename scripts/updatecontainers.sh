#!/bin/sh

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "#######################################"
echo "${GREEN}UPDATE LOCAL THE FROM LIVE${NC}"
echo "#######################################"

read -rep "Is this the path to your PE SSH-Key (/Users/$USER/.ssh/id_rsa)? (y/n)" -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    $sshkeypath="/Users/$USER/.ssh/id_rsa"
  else
    read -rep "Please enter absolute path to your PE ssh-key:" sshkeypath
  fi

read -p "Are you sure you want to dump local site and update? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # do dangerous stuff
    scp thecom@thecom.ent.platform.sh:/tmp/database.sql.gz ~/infra/dockerdev/conf/mysql/conf.d/
    rm ~/infra/dockerdev/conf/mysql/conf.d/database.sql
    docker exec -i dockerdev_db_1 bash -c "mysql -u root -ppassword -e 'drop database the_platform;'"
    docker exec -i dockerdev_db_1 bash -c "mysql -u root -ppassword -e 'create database the_platform;'"
    docker exec -i dockerdev_db_1 bash -c "gunzip /etc/mysql/conf.d/database.sql.gz"
    docker exec -i dockerdev_db_1 bash -c "mysql -u root -ppassword the_platform < /etc/mysql/conf.d/database.sql"
    docker exec -i dockerdev_db_1 bash -c "mysql -u root -ppassword -e 'UPDATE users SET mail = CONCAT(uid,\"anon@thelocal.co.uk\"), name = CONCAT(uid,\"name\"), init = CONCAT(uid,\"init\") , pass = \"$S$DmoJ43EPdqXy5eqUXyc329PjHqYQqJZfmYOUF2L0IzdEqqdCB1YH\" WHERE uid > 1' the_platform"
    docker exec -i dockerdev_php_1 bash -c "cd /docker/the_platform/www && drush rr && drush cc all && drush fr-all -y && drush dis new_relic_rpm -y"

    echo "rsyncing files updates from live"
    rsync -avrzpt -e "ssh -i $sshkeypath" thecom@thecom.ent.platform.sh:/app/thecom/public/sites/default/files/ ~/Sites/the_platform/shared/files/
fi
