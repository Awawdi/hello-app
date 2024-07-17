ARG TAG=latest
FROM ubuntu:$TAG
# Install Apache and clean up APT cache
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y apache2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /var/www/html/
COPY index.html .
ADD https://upload.wikimedia.org/wikipedia/commons/4/4e/Docker_%28container_engine%29_logo.svg ./logo.png
CMD ["ls"]
