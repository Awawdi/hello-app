# Docker images are built in layers, where each instruction in the Dockerfile creates a new layer.
# Instructions like FROM, RUN, COPY, and ADD each create a new layer in the resulting image.
# When Docker builds an image, it goes through each instruction in the Dockerfile and performs a cache lookup
# to see if it can reuse a previously built layer.

# If an instruction in the Dockerfile changes, Docker invalidates the cache for that instruction
# and all subsequent instructions.
# Docker builds images layer by layer. If a layer hasn’t changed, Docker can reuse the cached version
# of that layer.
# If a layer changes, all subsequent layers are rebuilt. Therefore, putting instructions that do not change often
# (such as the base image, dependency installations, initialization scripts) much earlier in the Dockerfile can
# help maximize cache hits.
# Copying the rest of the application code after installing dependencies ensures that changes to the application code
# do not invalidate the cache for the dependencies layer. This maximizes the reuse of cached layers, leading to faster builds.

ARG VERSION="3.9-slim"
FROM python:$VERSION
LABEL maintainer=orsan.awawdi@gmail.com
ENV ENVIRONMENT=DEV
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5050

RUN mkdir -p /logs

COPY . .
ENTRYPOINT ["python", "app.py"]
