# Playground for Kubernettes
[https://unpocodejava.wordpress.com/2015/11/05/docker-y-kubernetes-en-3-sesiones/](https://unpocodejava.wordpress.com/2015/11/05/docker-y-kubernetes-en-3-sesiones/)

## Examples of linking
Run a database service which will be used by a Java EE application:
`docker run --name mysqldb -e MYSQL_USER=mysql -e MYSQL_PASSWORD=mysql -e MYSQL_DATABASE=sample -e MYSQL_ROOT_PASSWORD=supersecret -p 3306:3306 -d mysql`

Note, you may need to forward the mysql port 3306 in your VM. Now let’s link up a Java EE application
`docker run -d --name mywildfly --link mysqldb:db -p 8080:8080 arungupta/wildfly-mysql-javaee7`

Our app is new using the DB, but let’s log into the container and verify the environment variables/DNS was set up:
`docker exec -it mywildfly bash`

then type the following to list environment variables:
`env`

You can also take a look at the /etc/hosts file
`cat /etc/hosts`



## Stateful containers
* Docker volumes to the rescue!
* Persist data outside of the container
* Can be mapped directly to Host locations
* Can also be deployed independently of hosts/indirectly
* Example: `docker run -d -P --name web -v /src/webapp:/opt/webapp training/webapp python app.py`
* Containers as data volumes
 * Start a container that will manage the volume
 * `docker create -v /dbdata --name dbdata training/postgres /bin/true`
 * Now other containers can use that container so they’re not tied directly to the volumes (mounting them, etc):
 * `docker run -d --volumes-from dbdata --name db1 training/postgres`
* **Jenkins example:**
 * Let’s take an example using Jenkins. We can fire up Jenkins containers, add build jobs, etc. But if we delete the container, the jobs are lost.
 * `docker run -d --name jenkins -p 8080:8080 jenkins`
 * We can save the changes and jobs that jenkins creates by adding a host volume:
 * `docker run -d --name jenkins -p 8080:8080 -v /your/home:/var/jenkins_home jenkins`
 * Now when you run jenkins, you can stop, destroy, and re-run jenkins and your build jobs should be there.