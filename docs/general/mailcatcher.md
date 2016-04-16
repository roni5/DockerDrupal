### Mailcatcher container configuration:
  @todo - add config information

### Useful commands
  1. restart Mailcatcher container
 ```docker restart dev_mailcatcher```

  2. trigger email
```docker exec -it dev_php bash -c "php -r \"mail('test@drupal.docker', 'test', 'test');\""```
```echo "My test email being sent from sendmail" | /usr/sbin/sendmail joe@4alldigital.com ```
