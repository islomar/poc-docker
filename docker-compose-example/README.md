#Docker compose example

## Tutorial instructions
[http://docs.docker.com/compose/gettingstarted/](http://docs.docker.com/compose/gettingstarted/)

## How to run it
1. `docker build -t web .`
2 `docker-compose up`
3. Access [http://localhost:5000/](http://localhost:5000/)
4. To check how the counter in the Redis DB gets updated: 
* `sudo docker exec -it dockercomposeexample_redis_1 bash`
* `redis-cli`
* `get hits`
