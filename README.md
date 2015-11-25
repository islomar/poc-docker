# Docker playground

## Resources
* Getting Started with Docker by John Willis: [https://www.youtube.com/watch?v=zOyQx9vM9Ac](https://www.youtube.com/watch?v=zOyQx9vM9Ac)
* The Docker Book
* Training: [https://training.docker.com/self-paced-training](https://training.docker.com/self-paced-training)
* Docs: [https://docs.docker.com/](https://docs.docker.com/)
* Getting Started for Linux: [https://docs.docker.com/linux/started/](https://docs.docker.com/linux/started/)
* Docker compose: 
 * [http://www.docker.com/docker-compose](http://www.docker.com/docker-compose)
 * [http://docs.docker.com/compose/](http://docs.docker.com/compose/)
* Tutorials: [https://blog.docker.com/2015/03/docker-tutorial-1-installing-docker/](https://blog.docker.com/2015/03/docker-tutorial-1-installing-docker/)


## Notes

### Introduction
**Virtual Machines**
* Each virtual machine includes the application, the necessary binaries and libraries and an entire guest operating system - all of which may be tens of GBs in size.

**Containers**
* Containers include the application and all of its dependencies, but share the kernel with other containers. They run as an isolated process in userspace on the host operating system. They’re also not tied to any specific infrastructure – Docker containers run on any computer, on any infrastructure and in any cloud. 

On a typical Linux installation, the Docker client, the Docker daemon, and any containers run directly on your localhost. This means you can address ports on a Docker container using standard localhost addressing such as `localhost:8000` 

In an OS X installation, the docker daemon is running inside a Linux VM called default. The default is a lightweight Linux VM made specifically to run the Docker daemon on Mac OS X. The VM runs completely from RAM, is a small ~24MB download, and boots in approximately 5s.

After a basic `docker run hello-world`:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

Depending on how it was built, an image might run a simple, single command and then exit. This is what Hello-World did.

To try something more ambitious, you can run an Ubuntu container with:
 `$ docker run -it ubuntu bash`

###General information
Its architectural philosophy centers around atomic or throw-away containers. During deployment, the whole running environment of the old application is thrown away with it.
Nothing in the environment of the application will live longer than the application itself and that’s a simple idea with big repercussions.

And it means that applications are highly portable between servers because **all state has to be included directly into the deployment artifact and be IMMUTABLE**, or sent to an external dependency like a database, cache, or file server.

Docker bundles application software and required OS filesystems together in a single standardized image format.

Using packaged artifacts to test and deliver the exact same artifact to all systems in all environments.

##Abstracting software applications from the hardware without sacrificing resources.
Traditional enterprise virtualization solutions like VMware were typically used when people have needed to create an abstraction layer between the physical hardware and the software applications that run on it, at the cost of resources.
The hypervisors that manage the VMs and each VM running kernel use a percentage of the hardware system’s resources, which are then no longer available to the hosted applications. **A container, on the other hand, is just another process** that talks directly to the Linux kernel and therefore can utilize more resources, up until the system or quota-based limits are reached.

Some organizations will find that they can completely remove their configuration management tool when they migrate to Docker, but the real power of Docker is that although it can replace some aspects of more traditional tools, it is usually completely compatible with them as well.

In the following list, we explore some of the tool categories that Docker doesn’t directly replace but that can often be used in conjunction to achieve great results:

- Enterprise Virtualization Platform (VMware, KVM, etc.)
    - With containers, both the host and the containers share the same kernel. This means that containers utilize fewer system resources, but must be based on the same underlying operating system (i.e., Linux).

- Cloud Platform (Openstack, CloudStack, etc.)
    - Docker, however, is not a cloud platform. It only handles deploying, running, and managing containers on pre-existing docker hosts. It doesn’t allow you to create new host systems (instances), object stores, block storage, and the many other resources that are typically associated with a cloud platform

- Configuration Management (Puppet, Chef, etc.)
    - Dockerfiles are used to define how a container should look at build time, but they do not manage the container’s ongoing state, and cannot be used to manage the Docker host system
- Deployment Framework (Capistrano, Fabric, Ansible, etc.)
- Workload Management Tool (Mesos, Fleet, etc.)
- Development Environment (Vagrant, etc.)

Push-to-deploy systems like Heroku have shown developers what the world can look like if you are in control of most of your dependencies as well as your application. Docker doesn’t try to be Heroku, but it provides a clean separation of responsibilities and encapsulation of dependencies, which results in a similar boost in productivity.

As a company, Docker preaches an approach of “batteries included but removable.” Which means that they want their tools to come with everything most people need to get the job done, while still being built from interchangeable parts that can easily be swapped in and out to support custom solutions.

The **Docker client** runs directly on most major operating systems, but because the Docker server uses Linux containers, it does not run on non-Linux systems. Docker has traditionally been developed on the Ubuntu Linux distribution, but today most Linux distributions and other major operating systems are now supported where possible.

Docker is a simple client/server model, with only one executable that acts as both components, depending on how you invoke the docker command. Underneath those simple exteriors, Docker heavily leverages kernel mechanisms such as iptables, virtual bridging, cgroups, namespaces, and various filesystem drivers.
Optionally there is a third component called the registry, which stores Docker images and metadata about those images.
The server does the ongoing work of running and managing your containers and you use the client to tell the server what to do. The docker daemon can run on any number of servers in the infrastructure, and a single client can address any number of servers. Clients drive all of the communication, but Docker servers can talk directly to image registries when told to do so by the client. Clients are responsible for directing servers what to do, and servers focus on hosting containerized applications.
Each Docker host will normally have one Docker daemon running that can manage a number of containers

Instead of having separate client and server executables, it uses the same binary for both components. When you install Docker, you get both components but the server will only launch on a supported Linux host.

The command line tool is the main interface that most people will have with Docker. This is a Go program that compiles and runs on all common architectures and operating systems. But the Docker command-line tool is not the only way to interact with Docker, and it’s not necessarily the most powerful.

The Docker daemon has a remote API. This is in fact what the Docker command-line tool uses to communicate with the daemon. But because the API is documented and public, it’s quite common for external tooling to use the API directly

Docker registered their own TCP port with IANA and it’s now generally configured to use TCP port 2375 when running unencrypted, or 2376 when handling encrypted traffic. In Docker 1.3 and later, the default is to use the encrypted port on 2376.

###Container networking
The Docker server acts as a virtual bridge and the containers are clients behind it. A bridge is just a network device that repeats traffic from one side to another. So you can think of it like a mini virtual network with hosts attached. The implementation is that each container has its own virtual ethernet interface connected to the Docker bridge and its own IP address allocated to the virtual interface.
Docker lets you bind ports on the host to the container so that the outside world can reach your container. That traffic passes over a proxy that is also part of the Docker.

That is bridged to the host’s local network through an interface on the server called docker0. That means that all of the containers are on a network together and can talk to each other directly. But to get to the host or the outside world, they go over the docker0 virtual bridge interface

A good way to start shaping your understanding of how to leverage Docker is to think of containers not as virtual machines but as very lightweight wrappers around a single Unix process. During actual implementation, that process might spawn others, but on the other hand, one statically compiled binary could be all that’s inside your container. Containers are also ephemeral: they may come and go much more readily than a virtual machine.

A quick test on Docker 1.4.1 reveals that a newly created container from an existing image takes a whopping 12 kilobytes of disk space. That’s pretty lightweight. One the other hand, a new virtual machine created from a golden image might require hundreds or thousands of megabytes. The reason that the new container is so small is because it is just a reference to a layered filesystem image and some metadata about the configuration.

###Limited isolation
Containers are isolated from each other, but it’s probably more limited than you might expect. While you can put limits on their resources, the default container configuration just has them all sharing CPU and memory on the host system, much as you would expect from colocated Unix processes. That means that unless you constrain them, containers can compete for resources on your production machines. That is sometimes what you want, but it impacts your design decisions. Limits on CPU and memory use are possible through Docker but, in most cases, they are not the default like they would be from a virtual machine.

###Stateless applications
A good example of the kind of application that containerizes well is a web application that keeps its state in a database. If you think about your web application, though, it probably has local state that you rely on, like configuration files. That might not seem like a lot of state, but it means that you’ve limited the reusability of your container, and maintaining configuration data in your codebase.
In many cases, the process of containerizing your application means that you move configuration state into environment variables that can be passed to your application from the container. This allows you to easily do things like use the same container to run in either production or staging environments.

Docker containers are made up of stacked filesystem layers, where each set of changes made during the build process are laid on top of the previous. That’s great because it means that when you do a new build, you only have to rebuild the layers that include and build upon the change your deploying. That saves time and bandwidth because containers are shipped around as layers and you don’t have to ship layers that a server already has stored.
To simplify this a bit, remember that a Docker image contains everything required to run your application. If you change one line of code, you certainly don’t want to waste time rebuilding every dependency your code requires into a new image. Instead, Docker will use as many base layers as it can so that only the layers affected by the code change are rebuilt.

“What was the previous version?”: Docker has a built-in mechanism for handling this: it provides image tagging at deployment time.

###Building
The Docker command-line tool contains a build flag that will consume a Dockerfile and produce a Docker image. Each command in a Dockerfile generates a new layer in the image, so it’s easy to reason about what the build is going to do by looking at the Dockerfile itself.

The standard Docker client only handles deploying to a single host at a time, but there are other tools avaliable that make it easy to deploy into a cluster of Docker hosts

###The Docker ecosystem
The first important category of tools that adds functionality to the core Docker distribution contains orchestration and mass deployment tools like Docker’s Swarm, New Relic’s Centurion and Spotify’s Helios. All of these take a generally simple approach to orchestration. For more complex environments, Google’s Kubernetes and Apache Mesos are more powerful options. There are new tools shipping constantly as new
adopters discover gaps and publish improvements.
Additional categories include auditing, logging, mapping, and many other tools, the majority of which leverage the Docker API directly. Recent announcements include direct support for Docker logs in Mozilla’s Heka log router, for example.

* Atomic hosts
** An atomic host is a small, finely tuned operating system image that supports container hosting and atomic OS upgrades.
Instead of relying on configuration management to try and keep all of your OS components in sync, what if you could simply pull down a  new, thin OS image and reboot the server? And then if something breaks, easily roll back to the exact image you were previously using?

* Docker client
** The docker command used to control most of the Docker workflow and talk to remote Docker servers.

* Docker server
** The docker command run in daemon mode. This basically turns a Linux system into a Docker server that can have containers deployed, launched, and torn down via a remote client.

* Docker images
** Docker images consist of one or more filesystem layers and some important metadata that represent all the files required to run a Dockerized application. A single Docker image can be copied to numerous hosts. A container will typically have both a name and a tag. The tag is generally used to identify a particular release of an image.

* Docker container
** A Docker container is a Linux container that has been instantiated from a Docker Image. A specific container can only exist once; however, you can easily create multiple containers from the same image.

If you are using Microsoft Windows or Mac OS X in your Docker workflow, the default installation provides Virtualbox and Boot2Docker, so that you can set up a Docker server for testing. These tools allow you to boot an Ubuntu-based Linux virtual machine on your local system.

Docker Machine is a tool that makes it much easier to set up Docker hosts on baremetal, cloud, and virtual machine platforms.
This downloads a Boot2Docker image and then creates a Virtualbox virtual machine that you can use as a Docker host.

If you need more flexibility with the way your Docker development environment is set up you might want to consider using Vagrant instead of Boot2Docker. Vagrant provides many advatages, including support for multiple hypervisors, infinite virtual machine images, and much more.

A container is a stripped-to-basics version of a Linux operating system. An image is software you load into a container.
Docker containers only run as long as the command you specify is active.

* Use Cases
https://www.docker.com/products/use-cases

* User guide
https://docs.docker.com/userguide/

* AWS Docker
http://aws.amazon.com/docker/


* Commands
 * Run "Docker quickstart terminal"
 * docker version
 * docker images  >>> para ver qué imágenes están instaladas
 * docker run hello-world >>> create and run a Docker container, loading the image 'hello-world' into the container
 * docker run imageName commandToRunInsideContainer
 * docker search xxx >>> find images with text xxx
 * docker pull imageName >>> downloads the image (pre-loads it).
 * docker rmi imageNAme >>> remove the image from the host
 * docker ps >>> queries the Docker daemon for information about all the containers it knows about.
 * docker ps -a >>> list  all containers, stopped and running.
 * docker logs containerName
 * docker stop containerName
 * docker inspect containerName >>> It returns a JSON document containing useful configuration and status information for the specified container.
 * docker search <nameToSearch>

 **Build and upload an image**
 * docker build -t docker-whale . >>> create an image called “docker-whale" from the Dockerfile
 * docker tag <imageId> <accountNameInDockerHub/imageName:versionLabelOrTag> >>> Create tag to b e pushed to DockerHub
  * docker login --username=xxx --email=xxx
  * docker push islomar/xxxxx
  * Automate builds on Docker Hub: [https://docs.docker.com/docker-hub/builds/](https://docs.docker.com/docker-hub/builds/)

Dockerfile best practices: https://docs.docker.com/articles/dockerfile_best-practices/

**docker run -t -i ubuntu:14.04 /bin/bash**
* Run an interactive shell.
* The -t flag assigns a pseudo-tty or terminal inside our new container and the -i flag allows us to make an interactive connection by grabbing the standard in (STDIN) of the container.
* To detach the tty without exiting the shell, use the escape sequence Ctrl-p + Ctrl-q. The container will continue to exist in a stopped state once exited. To list all containers, stopped and running, use the docker ps -a command.
* With -t you're actually inside the container.
* You can use `-ti`

**docker run -d ubuntu:14.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"**
The -d flag tells Docker to run the container and put it in the background, to daemonize it.


* TO BE SEEN/READ
https://openwebinars.net/docker-contenedores-de-aplicaciones-el-futuro-de-la-distribucion-de-aplicaciones/
https://www.docker.com/products/use-cases
https://docs.docker.com/userguide/

###Questions
* Can you isolate resource comsumption?