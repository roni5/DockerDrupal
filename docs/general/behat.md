Behat container configuration
------------

  ## behat.yml

  -- @todo

  ## SSH

  -- @todo

  ## Drush alias

  -- the example docker.aliases.drushrc.php [@drupal_docker] drush alias is hooked up with the demo site

Usage
-----------

  1. Restart Behat container

   ```docker restart dev_behat```

  2. Launch the Behat debug VNC

    1. This will inspect the docker container and server the internal docker port mapping for the externally accesible 5900 port:

    ```$(docker inspect --format '{{ (index (index .NetworkSettings.Ports "5900/tcp") 0).HostPort }}' dev_firefox)```

    2. Now we can comnine this with triggering OSX's screensharing VNC with:

    ```open vnc://:secret@192.168.99.100:$(docker inspect --format '{{ (index (index .NetworkSettings.Ports "5900/tcp") 0).HostPort }}' dev_firefox)```

  3. Run demo tests:

    1. ```docker exec -it dev_behat behat --config /docker/drupal_docker/repository/tests/behat.yml --suite global_features --profile local --tags about```
    2. ```docker exec -it dev_behat behat --config /docker/drupal_docker/repository/tests/behat.yml --suite global_features --profile local --tags login```



