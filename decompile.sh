#!/bin/bash -e

# for patch development purposes only
# this script is used to decompile the x-pack jar fil

source scripts/jd_cli_downloader.sh
source scripts/es_downloader.sh
source scripts/decompile.sh

wanted_version=$1


if [ -z "$wanted_version" ]; then
    echo "Please provide a version number"
    exit 1
fi

if [ -d "tmp/${wanted_version}-decompiled" ]; then
  echo "Version ${wanted_version} is already decompiled in tmp/${wanted_version}-decompiled"
  echo "If you want to decompile it again, please remove the directory"
  echo "Run: rm -rf tmp/${wanted_version}-decompiled"
  exit 1
fi

download_version $wanted_version
decompile_xpack $wanted_version
