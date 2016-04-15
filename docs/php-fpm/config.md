### SOLR container configuration:
 - To view the demo index, goto http://192.168.99.100:8983/solr/#/SITE, once your local dev environment is fully setup.
 - To add a new index:
 1. Copy the [site] folder in /mounts/conf/solr/ and rename eg. sitetwo
 2. Remove the /data directory
 3. Name you index by editing core.properties in your new folder
 4. restart solr container
