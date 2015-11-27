#Docker compose example

## Tutorial instructions
[http://docs.docker.com/compose/gettingstarted/](http://docs.docker.com/compose/gettingstarted/)

##How to run it
1. `docker build -t web .`
2 `docker-compose up`
3. Access [http://localhost:5000/](http://localhost:5000/)
4. To check how the counter in the Redis DB gets updated: 
* `sudo docker exec -it dockercomposeexample_redis_1 bash`
* `redis-cli`
* `get hits`

##Notes
* Tutorial:
 * [https://www.youtube.com/watch?v=gtoT0By8yh4&feature=youtu.be&list=PLkA60AVN3hh_6cAz8TUGtkYbJSL2bdZ4h](https://www.youtube.com/watch?v=gtoT0By8yh4&feature=youtu.be&list=PLkA60AVN3hh_6cAz8TUGtkYbJSL2bdZ4h)
 * [https://gist.github.com/botchagalupe/53695f50eebbd3eaa9aa](https://gist.github.com/botchagalupe/53695f50eebbd3eaa9aa)
 * Docker volumes: [http://docs.docker.com/engine/userguide/dockervolumes/](http://docs.docker.com/engine/userguide/dockervolumes/)

##Commands
`docker-compose ps`
`docker-compose -f compose-ex1.yml up -d`
`docker-compose -f compose-ex1.yml ps`
`docker-compose -f compose-ex1.yml logs`

`
export COMPOSE_FILE=compose-ex2.yml

docker-compose up -d

docker-compose ps 

docker exec dockercomposeexample_nginx_1 cat /etc/hosts

docker exec dockercomposeexample_tomcatapp1_1 ip a 

docker exec dockercomposeexample_tomcatapp2_1 ip a

docker exec dockercomposeexample_tomcatapp3_1 ip a

curl http://localhost/sample/

docker-compose stop
`