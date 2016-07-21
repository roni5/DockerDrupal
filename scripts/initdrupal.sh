#!/bin/sh

GREEN='\033[0;32m'
LIGHTBLUE='\033[0;94m'
NC='\033[0m'

now="$(date +'%Y-%m-%d--%H-%M-%S')"

echo "${LIGHTBLUE}####################${NC}"
echo "${LIGHTBLUE}INSTALL DEPENDENCIES${NC}"
echo "${LIGHTBLUE}####################${NC}"
# #
# # Check if Homebrew is installed
# #
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    # https://github.com/mxcl/homebrew/wiki/installation
    echo "${LIGHTBLUE}####################${NC}"
    echo "${LIGHTBLUE}INSTALLING HOMEBREW ${NC}"
    echo "${LIGHTBLUE}####################${NC}"
    yes '' | ruby -e "$(curl --progress-bar -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    #http://stackoverflow.com/a/12031907 - for info
    cd /usr/local
    git fetch origin
    git reset --hard origin/master
    sudo chown -R $USER /usr/local
    brew update
fi

# # #
# # # Check if Node is installed and at the right version
# # #
echo "Checking if NVM && Node and for Node version ${NODE_VERSION}"
nvm --version || curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
nvm list
nvm ls-remote
which -s node
if [[ $? != 0 ]] ; then
    node --version | grep ${NODE_VERSION}
    if [[ $? != 0 ]] ; then
        nvm install 5.10.1
        nvm use 5.10.1
        nvm alias default 5.10.1
        npm install -g npm
        source ~/.bash_profile
    fi
fi

# # #
# # # Check if Drush is installed and at the right version
# # #
echo "Checking for Drush version ${DRUSH_VERSION}"
which -s drush
if [[ $? != 0 ]] ; then
    composer global require drush/drush:${DRUSH_VERSION}
else
    drush --version | grep ${DRUSH_VERSION}
    if [[ $? != 0 ]] ; then
      composer global require drush/drush:${DRUSH_VERSION}
    fi
fi

which -s bower || npm install -g bower
which -s gulp || npm install -g gulp

echo "${LIGHTBLUE}#####################################${NC}"
echo "${LIGHTBLUE}SETUP SITE DIRECTORIES INFRASTRUCTURE${NC}"
echo "${LIGHTBLUE}#####################################${NC}"

mkdir -p ~/Sites
mkdir -p ~/Sites/drupal_docker/
mkdir -p ~/Sites/drupal_docker/repository
mkdir -p ~/Sites/drupal_docker/repository/themes
mkdir -p ~/Sites/drupal_docker/repository/modules
mkdir -p ~/Sites/drupal_docker/repository/modules/custom
mkdir -p ~/Sites/drupal_docker/repository/modules/features
mkdir -p ~/Sites/drupal_docker/repository/libraries
mkdir -p ~/Sites/drupal_docker/repository/scripts

cd ~/Sites/drupal_docker/

echo "${LIGHTBLUE}#####################################${NC}"
echo "${LIGHTBLUE}    BUILDING DIRECTORY STRUCTURE     ${NC}"
echo "${LIGHTBLUE}#####################################${NC}"

  mkdir -p builds
  mkdir -p shared
  mkdir -p shared/files

# add files
file=shared/settings.local.php
if ! [ ! -e "$file" ]
then
    echo "#"
else
  cp ~/infra/drupaldev-docker/settings/drupal.settings.local.php shared/settings.local.php
fi

file=repository/project.make.yaml
if ! [ ! -e "$file" ]
then
    echo "#"
else
  cp ~/infra/drupaldev-docker/settings/project.make.yaml repository/project.make.yaml
fi

file=repository/.gitignore
if ! [ ! -e "$file" ]
then
    echo "#"
else
  cp ~/infra/drupaldev-docker/settings/sample-gitignore.txt repository/.gitignore
fi

file=~/infra/drupaldev-docker/nginx.env
if ! [ ! -e "$file" ]
then
    echo "#"
else
  cp ~/infra/drupaldev-docker/settings/example-nginx.env ~/infra/drupaldev-docker/nginx.env
fi

file=./repository/tests/behat.yml
if ! [ ! -e "$file" ]
then
    echo "#"
else
  cp -R ~/infra/drupaldev-docker/settings/tests repository/
fi

file=~/infra/drupaldev-docker/mounts/conf/behat/docker.aliases.drushrc.php
if ! [ ! -e "$file" ]
then
    echo "#"
else
  cp ~/infra/drupaldev-docker/settings/docker.aliases.drushrc.php ~/infra/drupaldev-docker/mounts/conf/behat/docker.aliases.drushrc.php
fi

drush make -q -y repository/project.make.yaml builds/build-$now/public

echo "${LIGHTBLUE}#####################################${NC}"
echo "${LIGHTBLUE}       SYMLINK NEW DIRECTORIES       ${NC}"
echo "${LIGHTBLUE}#####################################${NC}"

ln -s ../../../../../repository/themes builds/build-$now/public/sites/default/themes
ln -s ../../../../../repository/modules builds/build-$now/public/sites/default/modules
ln -s ../../../../../repository/libraries builds/build-$now/public/sites/default/libraries
ln -s ../../../../../shared/settings.local.php builds/build-$now/public/sites/default/settings.local.php
ln -s ../../../../../shared/files builds/build-$now/public/sites/default/files
settingsfile=builds/build-$now/public/sites/default/settings.php

if ! [ ! -e "$settingsfile" ]
then
    echo "#"
else
  if ! echo "<?php
    \$update_free_access = FALSE;
    \$drupal_hash_salt = '5vNH-JwuKOSlgzbJCL3FbXvNQNfd8Bz26SiadpFx6gE';
    \$local_settings = dirname(__FILE__) . '/settings.local.php';
    if (file_exists(\$local_settings)) {
      require_once(\$local_settings);
    }" > builds/build-$now/public/sites/default/settings.php
  then
            echo "ERROR: the virtual host could not be added."
  else
            echo "New virtual host added to the Apache vhosts file"
  fi
    echo "#"
fi

rm www
ln -s builds/build-$now/public www
echo "${LIGHTBLUE}#####################################${NC}"
echo "${LIGHTBLUE}       LIST RUNNING CONTAINERS       ${NC}"
echo "${LIGHTBLUE}#####################################${NC}"
source  ~/.bash_profile
docker ps
sleep 15s
echo "${LIGHTBLUE}##################################################${NC}"
echo "${LIGHTBLUE}##################################################${NC}"

docker exec -i dev_mysql bash -c "mysql -u root -ppassword -e 'drop database drupal_docker;'"
docker exec -i dev_mysql bash -c "mysql -u root -ppassword -e 'create database drupal_docker;'"
docker exec -i dev_php bash -c "cd /docker/drupal_docker/www/ && drush site-install standard --account-name=admin --account-pass=admin --account-mail=dev@drupal.docker --site-name=DrupalDocker --site-mail=info@drupal.docker --db-url=mysql://root:ROOTPASSWORD@db/drupal_docker -y"
docker exec -i dev_php bash -c "cd /docker/drupal_docker/www/ && drush en ckeditor search_api search_api_override facetapi redis -y"
cd ~/infra/drupaldev-docker/
drupalfile=./mounts/conf/nginx/sites-enabled/drupal.docker

if ! [ ! -e "$drupalfile" ]
then
    echo "#"
else
  if ! echo "server {
    listen   80;
    listen   [::]:80;

    sendfile off;

    ## for large uploads
    client_max_body_size 20M;

    index index.php index.html;
    server_name drupal.docker;
    error_log  /var/log/nginx/drupal.error.log;
    access_log /var/log/nginx/drupal.access.log;
    root /docker/drupal_docker/www/;

    location / {
        try_files $uri /index.php?$args;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_read_timeout 300;
        fastcgi_cache  off;
        fastcgi_intercept_errors on;
    }

    # Don't allow direct access to PHP files in the vendor directory.
    location ~ /vendor/.*\.php$ {
        deny all;
        return 404;
    }

    location @rewrite {
        rewrite ^/(.*)$ /index.php?q=$1;
    }

    # Fighting with Styles? This little gem is amazing.
    location ~ ^/sites/.*/files/styles/ { # For Drupal >= 7
        try_files $uri @rewrite;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off;
    }

}" > ./mounts/conf/nginx/sites-enabled/drupal.docker
  then
    echo "#"
  else
    echo "#"
  fi
    echo "#"
fi

#reload nginx conf
docker exec -i dev_nginx /etc/init.d/nginx reload

# launch in preferred browser
python -mwebbrowser http://drupal.docker
python -mwebbrowser http://localhost:8983/solr/#/SITE
python -mwebbrowser http://localhost:4444/grid/console
python -mwebbrowser http://localhost:1080
