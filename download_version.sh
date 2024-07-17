#!/bin/bash

# first argument is the version to download and extract
starting_path=$(pwd)
wanted_version=$1
available_versions=("8.7.0")
# if wanted_version is not in list of versions, exit
if [[ ! " ${available_versions[@]} " =~ " ${wanted_version} " ]]; then
  if [ -z "$wanted_version" ]; then
    echo "Please provide a version number"
  else
    echo "Version ${wanted_version} is not available"
  fi
  echo "Available versions are: ${available_versions[@]}"
  exit 1
else
  echo "Requested version: ${wanted_version}"
fi

# check if the version is already installed if not download it
if [ -d "versions/${wanted_version}" ]; then
  echo "Version ${wanted_version} is already installed in versions/${wanted_version}"
  echo "If you want to download it again, please remove the directory"
else
  echo "Downloading version ${wanted_version}"
  mkdir -p "versions/${wanted_version}"
  # download the version
  wget -O "versions/${wanted_version}/elasticsearch-linux-x86_64.tar.gz" "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${wanted_version}-linux-x86_64.tar.gz"
  # extract the version
  echo "Extracting version ${wanted_version}"
  tar -xzf "versions/${wanted_version}/elasticsearch-linux-x86_64.tar.gz" -C "versions/${wanted_version}"
fi

cd $starting_path