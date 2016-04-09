<?php

####################
## DATABASE CONFIG
####################
$databases['default']['default'] = array(
  'driver' => 'mysql',
  'host' => 'db',
  'username' => 'root',
  'password' => 'password',
  'database' => 'datapoints_platform',
  'prefix' => '',
);

####################
## DEVELOPMENT CONFIG
####################

## MEMORY BOOST
ini_set('memory_limit','512M');

//$base_url = "http://datapoints.platform/datapoints";
$conf['env'] = 'dev';
$conf['drupal_http_request_fails'] = FALSE;

$conf['404_fast_paths_exclude'] = '/\/(?:nuffin)\//';
$conf['404_fast_paths'] = '/\.(?:txt|png|gif|jpg|jpe?g|css|js|ico|swf|flv|cgi|bat|pl|dll|exe|asp)$/i';
$conf['404_fast_html'] = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.0//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><title>404 Not Found</title></head><body><h1>Not Found</h1><p>The requested URL "@path" was not found on this server.</p></body></html>';

## FILES CONFIG
$conf['file_private_path]'] = '/docker/the_platform/private_files';
//$conf['stage_file_proxy_origin'] = 'http://staging.the.com.c.thecom.ent.platform.sh';

## DISABLE ALL CACHES IF YOU WANT
$conf['cache'] = 0;
$conf['block_cache'] = 0;
$conf['cache_lifetime'] = 0;
$conf['page_cache_maximum_age'] = 0;
$conf['page_compression'] = 0;
$conf['preprocess_js'] = 0;
$conf['preprocess_css'] = 0;

// $conf['cache'] = 1;
// $conf['block_cache'] = 1;
// $conf['cache_lifetime'] = 84600;
// $conf['page_cache_maximum_age'] = 160000;
// $conf['page_compression'] = 1;
// $conf['preprocess_js'] = 1;
// $conf['preprocess_css'] = 1;


####################
## SEARCH API HOOKUP
####################
$conf['search_api_override_mode'] = 'load';
$conf['search_api_override_servers'] = array(
  'the_solr_server' => array(
    'name' => 'THE Solr Server (overridden)',
    'options' => array(
      'host' => 'solr',
      'port' => '8983',
      'path' => '/solr/SITE'
    ),
  ),
);

####################
## REDIS CONFIG
####################

$conf['redis_client_interface'] = 'Predis'; // Can be "Predis".
$conf['redis_client_host'] = 'redis';  // Your Redis instance hostname.
$conf['redis_client_port'] = 6379;
$conf['lock_inc'] = 'profiles/dataproducts/modules/contrib/redis/redis.lock.inc';
$conf['path_inc'] = 'profiles/dataproducts/modules/contrib/redis/redis.path.inc';
$conf['cache_backends'][] = 'profiles/dataproducts/modules/contrib/redis/redis.autoload.inc';
$conf['cache_prefix'] = 'datapoints';
$conf['cache_default_class'] = 'Redis_Cache';
$conf['cache_class_cache_form'] = 'DrupalDatabaseCache';

####################
## MZ SETTINGS
####################
//$conf['mz_domain'] = 'http://local.tescloud.com';
$conf['file_private_path'] = '/docker/datapoints_platform/private_files';

$conf['mz_domain'] = 'http://local.tescloud.com:8080';
//$conf['mz_domain'] = 'http://datapoints.platform';

