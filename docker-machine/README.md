#Docker-machine
Docker Machine allows you to provision Docker on virtual machines that reside either on your local system or on a cloud provider. Docker Machine creates a host on a VM and you use the Docker Engine client as needed to build images and create containers on the host.

* Documentation:
[https://docs.docker.com/machine/get-started/](https://docs.docker.com/machine/get-started/)

`docker-machine ls`
`docker-machine create --driver virtualbox dev`
`eval "$(docker-machine env dev)"`

`docker run busybox echo hello world`
`docker-machine ip dev`
`docker run -d -p 8000:80 nginx`

`curl $(docker-machine ip dev):8000`

`docker-machine stop dev`
`docker-machine start dev`