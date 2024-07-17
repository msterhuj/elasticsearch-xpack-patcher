#!/bin/bash

# for patch development purposes only
# this script is used to generate a patch for a specific version

source scripts/decompile.sh

wanted_version=$1

if [ -z "$wanted_version" ]; then
    echo "Please provide a version number"
    exit 1
fi

if [ -d "patches/${wanted_version}" ]; then
  echo "Version ${wanted_version} is already patched in patches/${wanted_version}"
  echo "If you want to generate the patch again, please remove the directory"
  echo "Run: rm -rf patches/${wanted_version}"
  exit 1
fi

generate_patch $wanted_version
