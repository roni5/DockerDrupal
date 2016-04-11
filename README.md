![Drupal Docker Logo](https://raw.githubusercontent.com/4alldigital/drupaldev-docker/master/docs/images/drupal-docker-logo-monochrome.png)

[DrupalDockerDev](http://www.4alldigital.io/drupaldocker) is Docker based development environment for local Drupal development. Useful for debugging and developing with an intention to host sites using [DrupalDockerProd]

# Get Started

  1. Open `Terminal` application
  2. run ```mkdir -p ~/.infra```
  3. run ``` cd ~/.infra```
  4. run ``` git clone git@github.com:4alldigital/drupaldev-docker.git```
  5. run ``` cd ~/.infra/drupaldev-docker/scripts```
  6. run ``` sudo ./onboardme.sh```

# Inside the box

## Docker-Compose
We use docker-compose to setup local networks, volumes and container and manage our development environment.
Visit [Docker Compose V1.7rc-1](https://docs.docker.com/compose/) For more info...

## MariaDB
MariaDB is one of the most popular database servers in the world. It’s made by the original developers of MySQL and guaranteed to stay open source.

Visit [MariaDB](https://mariadb.org) For more info...

## NGINX
NGINX is a free, open-source, high-performance HTTP server and reverse proxy, as well as an IMAP/POP3 proxy server.

Visit [Nginx](https://www.nginx.com/resources/wiki/) For more info...

## PHP-FPM
PHP-FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation with some additional features useful for sites of any size, especially busier sites.

Visit [PHP-FPM](http://php-fpm.org) For more info...

## APACHE SOLR
Solr is the popular, blazing-fast, open source enterprise search platform built on Apache Lucene™.

Visit [APACHE SOLR V4.10.1](http://lucene.apache.org/solr/) For more info...

### Configuration:
 - To view the demo index, goto http://192.168.99.100:8983/solr/#/SITE, once you local dev environment is fully setup.
 - To add a new index:
 1. Copy the [site] folder in /mounts/conf/solr/ adn rename eg. sitetwo
 2. Remove the /data directory
 3. Name you index by editing core.properties in your new folder

## MAILCATCHER
MailCatcher runs a super simple SMTP server which catches any message sent to it to display in a web interface. Run mailcatcher, set your favourite app to deliver to smtp://192.168.99.100:1025 instead of your default SMTP server, then check out http://192.168.99.100:1080 to see the mail that's arrived so far.

Visit [MAILCATCHER](https://mailcatcher.me) For more info...

## REDIS
Redis is an open source (BSD licensed), in-memory data structure store, used as database, cache and message broker.

Visit [REDIS](http://redis.io) For more info...

## SELENIUM
Selenium automates browsers. That's it! What you do with that power is entirely up to you. Primarily, it is for automating web applications for testing purposes, but is certainly not limited to just that. Boring web-based administration tasks can (and should!) also be automated as well.

### Configuration:
 - To view your running Selenium grid visit http://192.168.99.100:4444/wd/hub in a browser once you local dev environment is fully set up and your containers are all running.

Visit [SELENIUM](http://www.seleniumhq.org) For more info...

## BEHAT
Behat is an open source Behavior Driven Development framework for PHP 5.3+.

Visit [BEHAT V3.0](http://docs.behat.org/en/v3.0/) For more info...



### System Requirements

Currently DrupalDocker is aimed at web development using MAC OSX:
  - Intel Core processor
  - 4+ GB RAM

### License

This project is licensed under the MIT open source license.

### Why?!....

We developed this becasue we love Docker and Drupal and think micor-service infrastructure is the way forward....  We hope you enjoy all or parts of the stack and value any feedback or contributions.
