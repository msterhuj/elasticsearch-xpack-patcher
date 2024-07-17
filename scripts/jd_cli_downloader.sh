#!/bin/bash

# just source this file in your script to download jd-cli
jd_cli_url="https://github.com/intoolswetrust/jd-cli/releases/download/jd-cli-1.2.0/jd-cli-1.2.0-dist.tar.gz"
# download jd-cli for decompiling
if [ ! -f "jd-cli.jar" ]; then
    tmp_download_dir="tmp_download_jd_cli"
    mkdir -p $tmp_download_dir
    echo "jd-cli.jar does not exist"
    wget -O $tmp_download_dir/jd_cli.tar.gz $jd_cli_url
    tar -xf $tmp_download_dir/jd_cli.tar.gz -C $tmp_download_dir
    mv $tmp_download_dir/jd-cli.jar .
    rm -rf $tmp_download_dir
else
    echo "jd-cli.jar already downloaded"
fi
