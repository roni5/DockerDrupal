![Drupal Docker Logo](https://raw.githubusercontent.com/4alldigital/drupaldev-docker/master/docs/images/drupal-docker-logo-monochrome.png)

[DrupalDockerDev](https://www.4alldigital.io/docker-drupal) is Docker based development environment for local Drupal development. Useful for debugging and developing with an intention to host sites using [DrupalDockerProd]

# Get Started

  PreRequisites:
  1. Install GIT
    1. Goto : http://ufpr.dl.sourceforge.net/project/git-osx-installer/git-2.6.4-intel-universal-mavericks.dmg
    2. Run the installer
  2. Setup OSX EnergySaver settings in System Preferences to make sure your machine doesnt put hard-disks to sleep while `onboarding` script is running (May take more than 1 hour to complete initial download of all docker images from docker-hub).

  1. Open `Terminal.app` application in your /Applications/Utilities/ folder
  2. From the command-line, copy and paste the following, and press return
    - Notes
      1. When prompted you will need to enter your admin password
      2. You may also need to install OSX command line tools if prompted
      3. I've tried to write the onboardme.sh script in a way in which, should your connection get interrupted or the session end for any reason, you can rerun ```time ./scripts/onboardme.sh```, answer the prompts and it will re-run, ignoring what ahs alreayd been installed.
      4. The full initial download of all the Docker images/layers is in excess of 5GB, so installation time will vary greatly depending on your internet/broadband speed.  Anywhere from 10 minutes to 1 hour is possible.

  ```

     mkdir -p ~/infra && \
     cd ~/infra && \
     git clone https://github.com/4alldigital/drupaldev-docker.git && \
     cd ~/infra/drupaldev-docker && \
     time ./scripts/onboardme.sh

  ```


# Read docs

Our work-in-progress documentation will live on readthedocs.org from now on. Visit http://dockerdrupal.readthedocs.org/en/latest
