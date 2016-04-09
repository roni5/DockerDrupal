#!/bin/sh

## design to be run by CRON that may not have access to PATH , ie. docker-compose bin
/usr/local/bin/docker-compose stop
/usr/local/bin/docker-compose ps
/usr/local/bin/docker-compose rm web php redis db solr nginx dockergen selenium behat firefox chrome
/usr/local/bin/docker-machine restart default
/usr/local/bin/docker-compose up -d
