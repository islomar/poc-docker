# Docker: from 0 to deployment
* https://pro.codely.tv/library/docker-de-0-a-deployment/
* Code examples: https://github.com/fiunchinho/codely-docker
* Trainer: 
    - https://pro.codely.tv/library/by/author/jose-armesto/
    - @fiunchinho

## First steps with Docker
* Based in Linux `cgroups` and `namespaces`, so that processes think that they are being run in an isolated way.
    - **cgroups**: to limit HW (memory, CPU, disk utilisation)
    - **namespaces**: to limit what the processes can see.
* `docker run -it ubuntu`
* `docker logs -f <container_id>`
* `docker stop <container_id>`: sends a SIGTERM. Docker sends the signal to the process: if it is ignored, the process is killed anyway
 after 10 seconds
* Each time we execute `docker run`, a new container is instantiated from an image.
    - to keep the same container, we can stop it and rerun it (`docker ps -a` to show stopped containers)
    - `docker start -i <container_id>`, with `-i` for interactive
* `docker rm <container_id>`: delete the container for ever.


## Docker images
* `docker images`
* Images are downloaded by default from dockerhub: https://hub.docker.com/
* `ADD <filename_in_host_system> <destination_folder_in_container>`: it copies the file to the container
    - difference between `ADD` and `COPY`: ADD allows to use remote addresses as origin and download the content.
* `RUN xx`: to run a command inside the container
* `docker build -t <image_name> <dockerfile_path>`
* `ENTRYPOINT`: it is ALWAYS executed when running `docker run`; if it is not declared, the default one (`ENTRYPOINT ["/bin/sh], "-c"`) is
 executed (any command is passed as an argument to /bin/sh). If it's declared, it overwrites the default one.
* `CMD`: the command to execute when running `docker run <image_name>`. It is passed as an argument to the `ENTRYPOINT`, by default to
 the `sh`. There is no default CMD.
* `docker run -it <image_name> <command>`: the command will overwrite the `CMD` configured in the image.
* `docker run -it --entrypoint <my_entrypoint> <image_name> <command>`: we can overwrite the entrypoint from the CLI.
* Using env variables to configure the images.
    - `ENV <env_var_name>=<value>`: inside the Dockerfile
    - `docker run -rm -e <env_variable_name>=<value> <image_name>`: passing them from CLI


## Dockerfile best practices
* https://github.com/fiunchinho/codely-docker/blob/master/building/understanding-cache
* Official best practices: https://github.com/docker-library/official-images#review-guidelines
* Best practices checklist for new images: https://github.com/docker-library/official-images/blob/master/NEW-IMAGE-CHECKLIST.md
* A line in a Dockerfile becomes a new **layer** created and to be applied in the filesystem.
* When running `docker build` to create a container, if it keeps the old containers run, it will reuse the layers created in the past (it
 uses its **cache**). It takes from the cache the changes already applied in the past.
    - this allows to create containers very quickly (you get the `Using cache` message).
    - the cache gets invalidated if there is any difference in the changes to apply. AND all the next changes/layers would be invalidated
     as well, since they are relative to the previous layers.
     - that is why **the order of the layers matter**. Layers which do not change so much should be go first (if possible).
* Our images should be so small as possible
    - combine different `RUN` sentences in only one, so that it only generates one layer. 
    - **Multi-stage  build**: 
        - https://github.com/fiunchinho/codely-docker/blob/master/building/multi-stage/
        - Declare several `FROM` in the same Dockerfile (e.g. one for downloading all the dependencies and generate the deployable
         component, i.e. we can split the build image from the deployable image). E.g. we do not want the npm or composer or mvn
          installed in our deployable image (that way, our final image will be thiner and safer).
        - Only the last `FROM` is used for the final image.
        - You assign an alias to the first `FROM`, then use the `COPY -from=<from_alias> <resources_from_first_from_container> <destination_in_second_from_container>`
        - Instead of the `<from_alias>`, we can use indexes, e.g. `-from=0`.
    
    
## Running applications with Docker
* `docker run -p <host_port>:<container_port> <image_name>`. The container port must be declared as `EXPOSE` in the Dockerfile
* `docker run -it --restart=always <image_name>`: https://docs.docker.com/config/containers/start-containers-automatically/
* Limit CPU and memory use:
    - https://docs.docker.com/config/containers/resource_constraints/
    - `docker run --memory=<max_available_memory> --cpus=<available_cores_in_container> --cpu-shares=<value>`
    - `--cpu-shares`: when there is very few CPU available (e.g. 2 containers in same instance with high needs), it allows us to give
     weight to each container, so that the one with highest value will get more CPU. The default value is 1024, so if you set a higher
      value, you get more preference.
* Volumes: 
    - `docker run -it --name <container_name> -v /data <image_name>`: it would create a `/data` folder inside the container, being
 mapped to a folder in our host (the folder can  be found running `docker inspect -f "{{json .Mounts}}" <image_name> | jq .`)
    - `docker volume ls`
    - `docker volume create <volumne_name>` to create and then to map it and use it: 
    `docker run -it --name <container_name> -v <volume_name>:/data <image_name>`
    - You can also specify a specific path in the host machine as the origin, e.g. `-v $PWD:/data` 
        - doing so, for non-compile languages (e.g. JavaScript, PHP), you could just map the code folder and run a container, saving
         the need of generating your own image.
    - In Dockerfile, you can declare `VOLUME`. In this case, we can not specify the host path (on purpose, so that it can be used in
     multiple machines independently of having or not any host path created)
    
    
## Publishing our app in DockerHub with Continuous Integration
TBD


## Docker compose
TBD


## Docker in production: pros and cons
TBD


## Doubts and final hints

