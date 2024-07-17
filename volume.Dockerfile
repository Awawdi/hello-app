FROM ubuntu:latest
RUN apt-get update && apt-get upgrade
RUN apt-get install apache2 -y
VOLUME ["/var/log/apache2"]

#docker build -t orsanaw/volume:1.0 -f volume.Dockerfile .
#docker container run --interactive --tty --name volume-container orsanaw/volume:1.0 /bin/bash
#docker inspect volume-container
# under Mounts:
#docker volume inspect 5c8c4491ad13d2e913885def693749882868c2ac6dbc4db9d0de74fe3383d313
#sudo ls -l /var/lib/docker/volumes/5c8c4491ad13d2e913885def693749882868c2ac6dbc4db9d0de74fe3383d313/_data
#docker volume ls
