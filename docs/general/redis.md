### Redis container configuration:
  @todo - add config information

### Useful commands
  1. restart Redis container
 ``` docker restart dev_redis ```
  2. flush Redis cache
 ``` docker exec -i dev_redis redis-cli flushall```
  3. Monitor Redis cache
 ``` docker exec -i dev_redis redis-cli monitor```
