#!/bin/bash

export PGMODELER_VERSION=v0.9.2-alpha1
echo "Building for version ${PGMODELER_VERSION}"
docker build -t pgmodeler-docker-x11/build:$PGMODELER_VERSION --build-arg PGMODELER_VERSION="${PGMODELER_VERSION}"  --file=`pwd`/docker/Dockerfile-build .
sed s/\$\{PGMODELER_VERSION\}/${PGMODELER_VERSION}/g ./docker/Dockerfile-run > docker/Dockerfile-with-version
docker build -t pgmodeler-docker-x11/run:$PGMODELER_VERSION  --file=`pwd`/docker/Dockerfile-with-version .
rm docker/Dockerfile-with-version
