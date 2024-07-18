#!/bin/bash

# this script create image of docker container

wanted_version=$1

if [ -z "$wanted_version" ]; then
    echo "Please provide a version number"
    exit 1
fi

mkdir -p docker

cat > docker/Dockerfile.$wanted_version <<EOF
FROM elasticsearch:$wanted_version

COPY patched/$wanted_version/x-pack-patched-$wanted_version.jar /usr/share/elasticsearch/modules/x-pack-core/x-pack-core-$wanted_version.jar
EOF

docker build -t elasticsearch-patched:$wanted_version -f docker/Dockerfile.$wanted_version .
