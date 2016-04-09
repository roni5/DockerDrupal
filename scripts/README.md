##Useful scripts
This folder contains a set of useful scripts to manage your docker environment.

###onboardme.sh
an all-in-one script to download and set up the docker enviornment and all the TES projects.

###docker-cleanup.sh
A work-in-progress script to clean up and delete old and unused containers.

###reboot-docker.sh
When nothing else is working, this script deletes all the containers (not the data container) and recreates them.

###update-the.sh
Updates the THE site from live. It grabs the latest database and rsyncs the new images to your local environment.
