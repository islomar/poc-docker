#Install Compose
sudo wget --no-check-certificate https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m`
sudo mv docker-compose-`uname -s`-`uname -m` /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version


#Install Docker (client)
sudo wget --no-check-certificate -O /usr/local/bin/docker https://get.docker.com/builds/Darwin/x86_64/docker-latest
sudo chmod +x /usr/local/bin/docker
docker -v