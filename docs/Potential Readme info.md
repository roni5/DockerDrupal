# Notes for Composer/Docker dev

# DOCKER

  1.  install docker toolbox - https://www.docker.com/docker-toolbox (brew cask install dockertoolbox)

```
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew cask install dockertoolbox
  mkdir ~/infra/
  git clone git@github.com:tes/cms-infra-docker.git ~/infra/dockerdev/
  cd ~/infra/dockerdev/
  docker-machine ls
  docker-machine rm default
  docker-machine create -d virtualbox --virtualbox-memory "8192" --virtualbox-cpu-count "2" --virtualbox-disk-size "40000" default
  docker-compose up -d
```


# GIT - Setup local -> remote THE GIT infrastructure
```
cd ~/Sites/
git clone git@github.com:tes/cms-the-platform.git the_platform
cd the_platform/
git remote add github git@github.com:tes/cms-the-platform.git
git remote add platform myki2kbe5qk76@git.eu.platform.sh:myki2kbe5qk76.git
git remote add staging git@git.ent.platform.sh:thestaging.git
git remote add live git@git.ent.platform.sh:thecom.git
git fetch --all
git checkout -b feature-onboarding-*yourname*

```

# DRUPAL
```
scp thecom@thecom.ent.platform.sh:/tmp/database.sql.gz ~/infra/dockerdev/conf/mysql/conf.d/
docker exec -i docker_percona_1 bash -c "mysql -u root -ppassword -e 'create database the_platform;'"
docker exec -i docker_percona_1 bash -c "gunzip /etc/mysql/conf.d/database.sql.gz"
docker exec -i docker_percona_1 bash -c "mysql -u root -ppassword the_platform < /etc/mysql/conf.d/database.sql"

```
local_setting.php ???

DEV Dependencies

```
composer global require drush/drush
brew install node
npm install -g bower
```
