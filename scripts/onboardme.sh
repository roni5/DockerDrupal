#!/bin/sh

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

NODE_VERSION=v5.5.0

echo "#################################"
echo "${GREEN}INSTALL DEPENDENCIES${NC}"
echo "#################################"

## SSH-COPY-ID for OSX will need later to ssh between container
curl -L https://raw.githubusercontent.com/beautifulcode/ssh-copy-id-for-OSX/master/install.sh | sh

# # # install drupal platform & dependencies Q: can we run this stuff without SUDO
# # #
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
composer global require drush/drush:7.1.0
echo '\n# ADDED VIA ONBOARDING \nexport PATH="$HOME/.composer/vendor/bin:$PATH"' | sudo tee -a  ~/.bash_profile

# #
# # Check if Homebrew is installed
# #
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    # https://github.com/mxcl/homebrew/wiki/installation
   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    #http://stackoverflow.com/a/12031907 - for info
    cd /usr/local
    git fetch origin
    sudo git reset --hard origin/master
    sudo chown -R $USER /usr/local
    brew update
fi

# #
# # Check if Git is installed
# #
which -s git || brew install git

# # #
# # # Check if Node is installed and at the right version
# # #
echo "Checking for Node version ${NODE_VERSION}"
node --version | grep ${NODE_VERSION}
if [[ $? != 0 ]] ; then
    # Install Node
    cd `brew --prefix`
    $(brew versions node | grep ${NODE_VERSION} | cut -c 16- -)
    brew uninstall node
    brew install node

    # Reset Homebrew formulae versions
    git reset HEAD `brew --repository` && git checkout -- `brew --repository`
# else
#     brew link --overwrite node
fi

## more useful dev dependencies
which -s bower || npm install -g bower
which -s gulp || npm install -g gulp

echo "############################################"
echo "${GREEN}INSTALL DOCKER AND DEPENDENCIES${NC}"
echo "############################################"

## Note : issue with multiple hostonly networks on same IP : VBoxManage list hostonlyifs || VBoxManage hostonlyif remove vboxnetXX
brew cask install dockertoolbox
cd ~/infra/dockerdev/
docker-machine rm default
docker-machine create -d virtualbox --virtualbox-memory "8192" --virtualbox-cpu-count "2" --virtualbox-disk-size "80000" default
echo '\n# ADDED VIA ONBOARDING \nexport DOCKER_VHOSTS=drupal.docker' | sudo tee -a  ~/.bash_profile
echo '\n# ADDED VIA ONBOARDING \neval "$(docker-machine env default)"' | sudo tee -a  ~/.bash_profile
source ~/.bash_profile
docker-compose up -d

echo "#####################################"
echo "${GREEN}SETUP GIT INFRASTRUCTURE${NC}"
echo "#####################################"

mkdir -p ~/Sites

## Vanilla Drupal for testing locally
mkdir -p ~/Sites/drupal_docker/
mkdir -p ~/Sites/drupal_docker/repository
cd ~/Sites/drupal_docker/repository/

# create folders
echo -e "${GREEN}BUILDING DIRECTORY STRUCTURE${NC}"

  # builds folder
  mkdir -p ../builds
  # shared folder
  mkdir -p ../shared
  # files folder
  mkdir -p ../shared/files

# add files
file=../shared/settings.local.php

if ! [ ! -e "$file" ]
then
  echo "local.settings file already exists."
else
  if ! echo "<?php
    // Database configuration.
    \$databases['default']['default'] = array(
      'driver' => 'mysql',
      'host' => 'db',
      'username' => 'root',
      'password' => 'password',
      'database' => 'drupal_docker',
      'prefix' => '',
    );" > ../shared/settings.local.php
  then
            echo "ERROR: the local.settings.php file could not be added."
  else
            echo "local.settings.php added to the local shared folder"
  fi
  echo "local.settings file added"
fi

cd ../
drush make repository/project.make.yml builds/build-$now/public

echo -e "${GREEN}SYMLINK NEW DIRECTORIES${NC}"
ln -s ../../../../../repository/themes builds/build-$now/public/sites/default/themes
ln -s ../../../../../repository/modules builds/build-$now/public/sites/default/modules
ln -s ../../../../../repository/libraries builds/build-$now/public/sites/default/libraries
ln -s ../../../../../shared/settings.local.php builds/build-$now/public/sites/default/settings.local.php
ln -s ../../../../../shared/files builds/build-$now/public/sites/default/files

# drush dl drupal
# mv drupal-* www
# cd www
docker exec -i dockerdev_db_1 bash -c "mysql -u root -ppassword -e 'drop database drupal_docker;'"
docker exec -i dockerdev_db_1 bash -c "mysql -u root -ppassword -e 'create database drupal_docker;'"
docker exec -i dockerdev_php_1 bash -c "cd /docker/drupal_docker/www/ && drush site-install standard --account-name=admin --account-pass=admin --db-url=mysql://root:password@\$DB_PORT_3306_TCP_ADDR/drupal_docker -y"

# add files
drupalfile=./conf/nginx/sites-enabled/drupal.docker

if ! [ ! -e "$drupalfile" ]
then
  echo "drupal.docker already exists.."
else
  if ! echo "server {
    listen   80;
    listen   [::]:80;

    sendfile off;

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
        fastcgi_read_timeout 1200;
        fastcgi_cache  off;
    }
}" > ./conf/nginx/sites-enabled/drupal.docker
  then
            echo "ERROR: the virtual host could not be added."
  else
            echo "New virtual host added to the nginx sites-enabled directory"
  fi
  echo "drupal.docker file added"
fi

echo -e '\n# ADDED VIA ONBOARDING \n192.168.99.100 drupal.docker' | sudo tee -a /etc/hosts

# launch in preferred browser
python -mwebbrowser http://drupal.docker

