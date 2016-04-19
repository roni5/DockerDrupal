### Behat container configuration:
  @todo - add config information

### Useful commands
  1. restart Behat container
 ```docker restart dev_behat```
  2. Launch the Behat debug VNC
 ```open vnc://:secret@192.168.99.100:$(docker inspect --format '{{ (index (index .NetworkSettings.Ports "5900/tcp") 0).HostPort }}' dev_firefox)```
  3. Run demo tests:
    1. ```docker exec -it dev_behat behat --config /docker/drupal_docker/repository/tests/behat.yml --suite global_features --profile local --tags about```
    2. ```docker exec -it dev_behat behat --config /docker/drupal_docker/repository/tests/behat.yml --suite global_features --profile local --tags login```


