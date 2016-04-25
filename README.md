![DockerDrupal Logo](https://raw.githubusercontent.com/4alldigital/drupaldev-docker/master/docs/images/drupal-docker-logo-monochrome.png)

[DockerDrupal](https://www.4alldigital.io/docker-drupal) is Docker based development environment for local Drupal websites, Wordpress websites or PHP apps. Useful for debugging and developing your projects, with a possible intention of hosting sites using [DockerDrupal Prod](https://github.com/4alldigital/drupalprod-docker) (A read-only production environment).

# Get Started

  PreRequisites:
  1. Install GIT
    1. Goto : http://ufpr.dl.sourceforge.net/project/git-osx-installer/git-2.6.4-intel-universal-mavericks.dmg
    2. Run the installer
  1. Open `Terminal.app` application in your /Applications/Utilities/ folder
  2. From the command-line, copy and paste the following, and press return
    - Notes
      1. When prompted you will need to enter your admin password
      2. You may also need to install OSX command line tools if prompted
      3. I've tried to write the onboardme.sh script in a way in which, should your connection get interrupted or the session end for any reason, you can rerun ```time ./scripts/onboardme.sh```, answer the prompts and it will re-run, ignoring what has already been installed.
      4. The full initial download of all the Docker images/layers is in excess of 5GB, so installation time will vary greatly depending on your internet/broadband speed.  Anywhere from 10 minutes to 1 hour is possible.

  ```

     mkdir -p ~/infra && \
     cd ~/infra && \
     git clone https://github.com/4alldigital/drupaldev-docker.git && \
     cd ~/infra/drupaldev-docker && \
     caffeinate -i time ./scripts/onboardme.sh

  ```

# What next?

DockerDrupal currently utilise the following containers:

 1.https://hub.docker.com/r/4alldigital/drupaldev-php
 
 2.https://hub.docker.com/r/4alldigital/drupaldev-redis
 
 3.https://hub.docker.com/r/4alldigital/drupaldev-behat
 
 4.https://hub.docker.com/r/4alldigital/drupaldev-nginx
 
 5.https://hub.docker.com/r/4alldigital/drupaldev-solr
 
 6.https://hub.docker.com/r/selenium/hub
 
 7.https://hub.docker.com/r/selenium/node-chrome-debug
 
 8.https://hub.docker.com/r/selenium/node-firefox-debug
 
 9.https://hub.docker.com/r/schickling/mailcatcher
 
 10.https://hub.docker.com/r/_/mariadb
 
 11.https://hub.docker.com/r/jwilder/docker-gen
 
 12.https://hub.docker.com/r/rckrdstrgrd/nginx-proxy



  At the end of the `onboardme` script, 4 browser tabs should be open, with mailcatcher, SOLR, Selenium Grid and a demo Drupal install running.  First off, we'd check out the way the demo Drupla site is set up, and try to reproduce your own.


# Read docs

Our work-in-progress documentation will live on readthedocs.org from now on. Visit http://dockerdrupal.readthedocs.org/en/latest
