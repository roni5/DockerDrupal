#!/bin/sh

### Checking for user
if [ "$(whoami)" != 'root' ]; then
    echo "You have no permission to run $0 as non-root user. Use sudo !!!"
    exit 1;
fi

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

now="$(date +'%Y-%m-%d--%H-%M-%S')"

NODE_VERSION=v5.5.0

echo "#################################"
echo "${GREEN}INSTALL DEPENDENCIES${NC}"
echo "#################################"

# #
# # Check if SSH-COPY-ID is installed
# # SSH-COPY-ID for OSX we will need later to ssh between containers
# #

which -s ssh-copy-id || curl -L https://raw.githubusercontent.com/beautifulcode/ssh-copy-id-for-OSX/master/install.sh | sh

# # # install Drupal/PHP app dependencies Q: can we run this stuff without SUDO
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
    echo "#################################"
    echo "${GREEN}INSTALLING HOMEBREW ${NC}"
    echo "#################################"
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
cd ~/infra/drupaldev-docker/
docker-machine rm default
docker-machine create -d virtualbox --virtualbox-memory "8192" --virtualbox-cpu-count "2" --virtualbox-disk-size "80000" default
echo '\n# ADDED VIA ONBOARDING \nexport DOCKER_VHOSTS=drupal.docker' | sudo tee -a  ~/.bash_profile
echo '\n# ADDED VIA ONBOARDING \neval "$(docker-machine env default)"' | sudo tee -a  ~/.bash_profile
source ~/.bash_profile

## MAKE SURE WE GET DOCKER-COMPOSE 1.7+
curl -L https://github.com/docker/compose/releases/download/1.7.0-rc1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

docker-compose up -d

echo "##################################################"
echo "${GREEN}SETUP SITE DIRECTORIES INFRASTRUCTURE${NC}"
echo "##################################################"

mkdir -p ~/Sites

## Vanilla Drupal for testing locally
mkdir -p ~/Sites/drupal_docker/
mkdir -p ~/Sites/drupal_docker/repository
cd ~/Sites/drupal_docker/

mkdir -p ~/Sites/drupal_docker/repository/themes
mkdir -p ~/Sites/drupal_docker/repository/modules
mkdir -p ~/Sites/drupal_docker/repository/modules/custom
mkdir -p ~/Sites/drupal_docker/repository/modules/features
mkdir -p ~/Sites/drupal_docker/repository/libraries

mkdir -p ~/Sites/drupal_docker/repository/scripts

# create folders
echo -e "${GREEN}BUILDING DIRECTORY STRUCTURE${NC}"

  # builds folder
  mkdir -p builds
  # shared folder
  mkdir -p shared
  # files folder
  mkdir -p shared/files

# add files
file=shared/settings.local.php
if ! [ ! -e "$file" ]
then
  echo "local.settings file already exists."
else
  cp ~/infra/drupaldev-docker/settings/drupal.settings.local.php shared/settings.local.php
fi

file=repository/project.make.yaml
if ! [ ! -e "$file" ]
then
  echo "local.settings file already exists."
else
  cp ~/infra/drupaldev-docker/settings/project.make.yaml repository/project.make.yaml
fi

file=repository/.gitignore
if ! [ ! -e "$file" ]
then
  echo "local.settings file already exists."
else
  cp ~/infra/drupaldev-docker/settings/sample-gitignore.txt repository/.gitignore
fi

file=../shared/.gitignore
if ! [ ! -e "$file" ]
then
  echo "local.settings file already exists."
else
  cp ~/infra/drupaldev-docker/scripts/drupaldocker-build.sh repository/scripts/
  chmod +x repository/scripts/*
fi

## eg : drush make repository/project.make.yml builds/build-2016-04-09--12-35-58/public
drush make repository/project.make.yaml builds/build-$now/public


echo -e "${GREEN}SYMLINK NEW DIRECTORIES${NC}"
ln -s ../../../../../repository/themes builds/build-$now/public/sites/default/themes
ln -s ../../../../../repository/modules builds/build-$now/public/sites/default/modules
ln -s ../../../../../repository/libraries builds/build-$now/public/sites/default/libraries
ln -s ../../../../../shared/settings.local.php builds/build-$now/public/sites/default/settings.local.php
ln -s ../../../../../shared/files builds/build-$now/public/sites/default/files

## setup www
ln -s builds/build-$now/public www

# drush dl drupal
# mv drupal-* www
# cd www
docker exec -i drupaldevdocker_db_1 bash -c "mysql -u root -ppassword -e 'drop database drupal_docker;'"
docker exec -i drupaldevdocker_db_1 bash -c "mysql -u root -ppassword -e 'create database drupal_docker;'"
docker exec -i drupaldevdocker_php_1 bash -c "cd /docker/drupal_docker/www/ && drush site-install standard --account-name=admin --account-pass=admin --account-mail=dev@drupal.docker --site-name=DrupalDocker --site-mail=info@drupal.docker --db-url=mysql://root:password@db/drupal_docker -y"
docker exec -i drupaldevdocker_php_1 bash -c "cd /docker/drupal_docker/www/ && drush en ckeditor search_api search_api_override facetapi redis -y"

# add files
cd ~/infra/drupaldev-docker/
drupalfile=./mounts/conf/nginx/sites-enabled/drupal.docker

if ! [ ! -e "$drupalfile" ]
then
  echo "drupal.docker already exists.."
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
            echo "ERROR: the virtual host could not be added."
  else
            echo "New virtual host added to the nginx sites-enabled directory"
  fi
  echo "drupal.docker file added"
fi

echo -e '\n# ADDED VIA ONBOARDING \n192.168.99.100 drupal.docker' | sudo tee -a /etc/hosts

#reload nginx conf
docker exec -i drupaldevdocker_web_1 /etc/init.d/nginx reload

# launch in preferred browser
python -mwebbrowser http://drupal.docker

