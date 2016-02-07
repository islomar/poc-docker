#Docker&Kubernetes Workshop

Lugar del evento: ShuttleCloud
[https://www.eventbrite.com/e/dockerkubernetes-workshop-tickets-19904639312](https://www.eventbrite.com/e/dockerkubernetes-workshop-tickets-19904639312)

[http://kubernetes.io/v1.1/docs/getting-started-guides/gce.html](http://kubernetes.io/v1.1/docs/getting-started-guides/gce.html)

* Ponentes
 * @ipedrazas
 * @agonzalezro:   https://gist.github.com/agonzalezro/

**Notas**
* Containers are not VM.
* Un microservicio es "micro" si puedes reescribirlo en 2 semanas.
* Transaccionalidad con microservicios: tienes que hacerlo a mano.
* [Binary protocol](https://en.wikipedia.org/wiki/Binary_protocol)

**Safe Harbor / Puerto seguro**
* http://www.enriquedans.com/2015/12/no-nadie-ha-prohibido-el-uso-en-espana-de-dropbox-ni-de-google-apps.html
* https://www.agpd.es/portalwebAGPD/canalresponsable/transferencias_internacionales/AplicacionSentenciaSH-ides-idphp.php
* https://www.agpd.es/portalwebAGPD/revista_prensa/revista_prensa/2015/notas_prensa/news/2015_10_06-ides-idphp.php


##Docker 101
* Contenedores para ejecutar los tests.
* Inmutabilidad
* Control de versiones

Pasos a realizar
* `docker-machine create --driver virtualbox jt`
* `eval $(docker-machine env jt)`
* `docker run -it ubuntu` o `docker run -it alpine sh` (sólo 5MB), `docker run -it scratch` (para Go)
* En el Dockerfile de Alpine no está que ejecute ningún comando por defecto, de ahí que se requiera indicar el sh.
* `docker run -d alpine find /` >> devuelve por ejemplo 006cff4bb37786330b8f6b6b583f18c826575c5d0476c8f8de99799f7cfa9443`
* `docker logs 006cff4bb37786330b8f6b6b583f18c826575c5d0476c8f8de99799f7cfa9443 | head -n4`
* `docker run -it alpine sleep 1h`

Tag and push to DockerHub:
* `docker tag <IMAGE_ID> islomar/workshop`
* `docker push islomar/workshop`

* `docker pause <CONTAINER_ID>`
* `docker unpause <CONTAINER_ID>`

* `docker ps -aq|xargs docker rm`

* Importante que en Docker se ejecute el comando en Foreground para que no muera

**Ejercicio**
1. Crear Dockerfile
2. `docker build -ti islomar/workshop .`
3. `docker run -ti -P -v `pwd`/html:/var/www/html islomar/workshop` >> ó con -p 80:80
4. Desde fuera: mkdir html && touch html/a && echo 'hi' > html/a
6. docker-machine ip jt | pbcopy >> get the virtual box ip
7. http://<virtualbox_ip>


##Kubernetes

* Container Engine >> create new
* Kubernetes is an open source orchestration system for Docker containers.

### Conceptos:
 * Pod: en Docker, la unidad más pequeña es un Container. En Kubernetes, es un Pod, que puede ser uno o más containers.
 * Labels: puedes etiquetar como "web", "production", etc.
 * Replication controller: gestiona el ciclo de vida de los pods, mantiene por ejemplo siempre 2 pods vivos.
 * Service: 
  * la forma de exportar fuera de tu cluster. Son load balancers.
  * Services provide a single, stable name and address for a set of pods. They act as basic load balancers.
 * Job: es una tarea; no es necesario que tengas un demonio a mano; puedes definir la política de reinicio.
 * Scheduled jobs
 * Namespaces: virtual clusters
 * Nodes: A node is a physical or virtual machine running Kubernetes, onto which pods can be scheduled.

* Meter base de datos en Kubernetes es de valientes...

[Getting started on Google Compute Engine](http://kubernetes.io/v1.1/docs/getting-started-guides/gce.html)
1. Container Engine >> create cluster
2. Computer Engine --> New instance >> Allow xxx  >>>> creamos una instancia fuera del cluster, para desde ahí lanzar comandos al cluster
3. instance1 --> SSH
 3.1. Ejecutar lo indicado en https://gist.github.com/agonzalezro/b3f172e93ebb8cf28829
  * sudo gcloud components update kubectl
  * sudo gcloud components update
  * gcloud container clusters get-credentials cluster-1 -z europe-west1-b
  * alias k="/usr/local/share/google/google-cloud-sdk/bin/kubectl"
  * k get nodes
  * k get --all-namespaces services
   * kubernetes
   * default-http-backend
   * kube-dns
   * kube-ui
   * heapster: monitoring services
  * k cluster-info
  * k get pods
  * k config view >> ves usuario (admin) y contraseña (en local es vagrant/vagrant)
  * https://104.155.75.75/api/v1/proxy/namespaces/kube-system/services/kube-ui/#/dashboard/

  

Descarga de https://github.com/ipedrazas/kubernetes-workshop/tree/master/examples
  * `./kubectl create -f kubernetes-workshop/examples/ping/k8s/ping-rc.yaml` >> rc=Replication Controller
  * k get pods
  * ./kubectl describe pod pingrc >> ahí ves cuántos pods debe haber siempre arrancados (y cuántos hay de manera efectiva)
  * ./kubectl delete pod pingrcname-6u8st

  Creación de un servicio:
  ./kubectl f ~/workspace/poc-docker/kubernetes/kubernetes-workshop/examples/ping//k8s/ping-service.yaml
  k get services
  k describe svc pingsvcname
  Este servicio reenvía la petición al pod del ping

  * Escalar a 3 máquinas el servicio:
   *  k scale --replicas=3 rc pingrcname >>> despues, con k get nodes deberías ver 3 nodos

* Rolling update:
 * [http://kubernetes.io/v1.1/docs/user-guide/update-demo/README.html](http://kubernetes.io/v1.1/docs/user-guide/update-demo/README.html)
 * `k rolling-update pingrcname --update-period=10s -f ping-rc-workshop.yaml`
 * Para desplegar sin dejar de dar servicio, un pod a la vez.

* Ejemplo ping-redis
[https://github.com/ipedrazas/kubernetes-workshop/tree/master/examples/ping-redis](https://github.com/ipedrazas/kubernetes-workshop/tree/master/examples/ping-redis)
  
* Namespaces
 * Para crear clusters virtuales. 
 * k create -f namespaces/integration-namespace.yaml
 * k create -f hellotest.yaml
 * k get pods --namespace=integration

* Secrets
 * [https://github.com/ipedrazas/kubernetes-workshop/tree/master/examples/secrets](https://github.com/ipedrazas/kubernetes-workshop/tree/master/examples/secrets)
  * Objects of type secret are intended to hold sensitive information, such as passwords, OAuth tokens, and ssh keys. Putting this information in a secret is safer and more flexible than putting it verbatim in a pod definition or in a docker image.

Alternativas:
* DEIS
* Swarm: troleo, sólo conoce una empresa, con solo 4 máquinas.
* Nomad

Buscar HELM (package manager for Kubernetes)
* https://deis.com/blog/2015/why-kubernetes-needs-helm
* http://helm.sh/

KB8OR (Continuous Deployment Tool for deploying with Kubernetes.):
https://github.com/UKHomeOffice/kb8or

Usado en: https://github.com/UKHomeOffice/lev-web
* Mirar .drone.yml

Creación de un MANIFEST con todo lo que tienes:
https://github.com/milosgajdos83/servpeek

**Cookiecutter**
[https://github.com/audreyr/cookiecutter](https://github.com/audreyr/cookiecutter)

