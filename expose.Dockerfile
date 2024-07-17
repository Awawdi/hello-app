FROM ubuntu:latest

RUN apt-get update && apt-get upgrade

RUN apt-get install apache2 curl -y

HEALTHCHECK CMD curl -f http://localhost/ || exit 1

EXPOSE 80

ENTRYPOINT ["apache2ctl", "-D", "FOREGROUND"]

#orsan@ubuntu-pc:~/hello-app$ docker image build -t expose-healthcheck-example -f expose-Dockerfile .
#docker container run -p 8080:80 --name expose-healthcheck-container -d expose-healthcheck-example


