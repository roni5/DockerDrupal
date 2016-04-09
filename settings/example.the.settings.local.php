<?php

####################
## DATABASE CONFIG
####################
$databases['default']['default'] = array(
  'driver' => 'mysql',
  'host' => $_SERVER['DB_PORT_3306_TCP_ADDR'],
  'username' => 'root',
  'password' => 'password',
  'database' => 'the_platform',
  'prefix' => '',
);


####################
## DEVELOPMENT CONFIG
####################

## MEMORY BOOST
ini_set('memory_limit','512M');

//$base_url = "https://the.docker";
$conf['env'] = 'dev';

## 404 FIXES FOR NON PAGES
$conf['404_fast_paths_exclude'] = '/\/(?:styles)|(?:system\/files)\//';
$conf['404_fast_paths'] = '/\.(?:txt|png|gif|jpe?g|css|js|ico|swf|flv|cgi|bat|pl|dll|exe|asp)$/i';
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

## Or turn the caching on
// $conf['cache'] = 1;
// $conf['block_cache'] = 1;
// $conf['cache_lifetime'] = 84600;
// $conf['page_cache_maximum_age'] = 1200000;
// $conf['page_compression'] = 1;
// $conf['preprocess_js'] = 1;
// $conf['preprocess_css'] = 1;

## COMPOSER MANAGER VARS -- https://www.drupal.org/project/composer_manager
$conf['composer_manager_vendor_dir'] = '/docker/the_platform/shared/files/composer/vendor';
$conf['composer_manager_file_dir'] = '/docker/the_platform/shared/files/composer';

####################
## SEARCH API HOOKUP
####################
$conf['search_api_override_mode'] = 'load';
$conf['search_api_override_servers'] = array(
  'the_solr_server' => array(
    'name' => 'THE Solr Server (overridden)',
    'options' => array(
      'host' => $_SERVER['SOLR_PORT_8983_TCP_ADDR'],
      'port' => '8983',
      'path' => '/solr/SITE'
    ),
  ),
);

####################
## REDIS CONFIG
####################

$conf['redis_client_interface'] = 'Predis'; // Can be "Predis".
$conf['redis_client_host'] = $_SERVER['REDIS_PORT_6379_TCP_ADDR'];  // Your Redis instance hostname.
$conf['lock_inc'] = 'sites/all/modules/contrib/redis/redis.lock.inc';
$conf['path_inc'] = 'sites/all/modules/contrib/redis/redis.path.inc';
$conf['cache_backends'][] = 'sites/all/modules/contrib/redis/redis.autoload.inc';
$conf['cache_prefix'] = 'the.platform_';
$conf['cache_default_class'] = 'Redis_Cache';
$conf['cache_class_cache_form'] = 'DrupalDatabaseCache';

####################
## MZ SETTINGS
####################
//$conf['mz_domain'] = 'http://local.tescloud.com';

####################
## PUGPIG SETTINGS
####################
$conf['pugpig_package_domain'] = 'the.platform';

####################
## MADGEX SETTINGS
####################
$conf['allow_madgex_job_requests'] = FALSE;

