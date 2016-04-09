<?php

/*
 * Example alias' format for docker host/container -> docker container
 */

// $aliases['your_site'] = array (
//   'uri' => 'default',
//   'root' => '/path/to/website/',
//   'remote-host' => 'localhost.dev',
//   'remote-user' => 'root',
//   'ssh-options' => '-p 8022', // optional if required
// );

$aliases['the_platform'] = array (
  'uri' => 'http://default',
  'root' => '/docker/the_platform/www',
  'remote-host' => 'the.platform',
  'remote-user' => 'root',
  'ssh-options' => '-p 8022', // optional if required
);
