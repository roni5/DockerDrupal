### Mailcatcher container configuration:
  @todo - add config information

### Useful info

  1. If your local site has an external SMTP server hooked, eg. using drupal Mailsystem/SMTP contrib modules, this will bypass Mailcatcher, so it's always a good idea to anonymise your database a sa rule of thumb.  You can do this using `drush sql-sanitize` (http://drushcommands.com/drush-7x/sql/sql-sanitize/) or using a direct sql query like the following:

  ```
  UPDATE users SET
  mail = CONCAT(uid,'anon@devlocal.co.uk'),
  name = CONCAT(uid,'name'),
  init = CONCAT(uid,'init') ,
  pass = '$S$DmoJ43EPdqXy5eqUXyc329PjHqYQqJZfmYOUF2L0IzdEqqdCB1YH'
  WHERE `uid` > 1
  ```

### Useful commands
  1. restart Mailcatcher container
 ```docker restart dev_mailcatcher```

  2. trigger email
```docker exec -it dev_php bash -c "php -r \"mail('test@drupal.docker', 'test', 'test');\""```
```echo "My test email being sent from sendmail" | /usr/sbin/sendmail joe@4alldigital.com ```
