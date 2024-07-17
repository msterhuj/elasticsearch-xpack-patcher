#!/bin/bash

source scripts/es_downloader.sh

#is_version_available $1
download_version $1

# start decompile
wanted_version=$1
x_pack_modules_file="versions/${wanted_version}/modules/x-pack-core/x-pack-core-${wanted_version}.jar"

ls $x_pack_modules_file