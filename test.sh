#!/bin/bash

# this script start a patched container with the wanted version
# upload the license to the container and check if the license
# is installed successfully
# run this script outside the container

wanted_version=$1

if [ ! -f license.json ]; then
  echo "license.json not found"
  exit 1
fi

license_type=$(jq -r '.license.type' license.json)
# check if license type is other than basic
if [ "$license_type" == "basic" ]; then
  echo "license type is cant be basic for this operation"
  exit 1
else
  echo "license type is valide : $license_type"
fi

# check if docker image elasticsearch-patched: do not exist
image_name=elasticsearch-patched:$wanted_version
image=$(docker image inspect $image_name)

if [ $? -ne 0 ]; then
  echo "elasticsearch-patched:$wanted_version not found"
  echo "Please build the image first with docker.sh script"
  exit 1
else
  echo "elasticsearch-patched:$wanted_version found"
fi

random_password=$(openssl rand -base64 12)
# start container
echo "Starting container with random password: $random_password"
container_name=elasticsearch-patched-$wanted_version
docker run \
  --rm -ti -d \
  -m 1GB \
  -e "ELASTIC_PASSWORD=$random_password" \
  -p 9200:9200 \
  --name $container_name \
  $image_name

# wait for container to start
while true; do
  status=$(curl -s -o /dev/null -w '%{http_code}' -u elastic:$random_password https://127.0.0.1:9200 --insecure)
  if [ $status -eq 200 ]; then
    echo "Container started successfully"
    break
  else
    echo "Waiting for container to start"
    sleep 5
  fi
done # KujzVtXcLclpUVFi

echo "Uploading license"
curl -XPUT -u elastic:$random_password 'https://127.0.0.1:9200/_license' -H "Content-Type: application/json" -d @license.json --insecure

# check if license installed
license_installed=$(curl -s -u elastic:$random_password 'https://127.0.0.1:9200/_license' --insecure | jq -r '.license.type')

if [ "$license_installed" == "$license_type" ]; then
  echo "License installed successfully"
  echo "License type: $license_installed"
else
  echo "License installation failed"
fi

# stop the container
echo "Stopping container"
docker kill $container_name
