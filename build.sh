#!/bin/bash

source scripts/es_downloader.sh
source scripts/jd_cli_downloader.sh
source scripts/decompile.sh

is_version_available $1
download_version $1
decompile_xpack $1


## Patching
if [ -z "$wanted_version" ]; then
    echo "Please provide a version number"
    exit 1
fi

if [ -d "patched/${wanted_version}" ]; then
  echo "Version ${wanted_version} is already patched in patched/${wanted_version}"
  echo "If you want to reapply patch again, please remove the directory"
  echo "Run: rm -rf patched/${wanted_version}"
else
  mkdir -vp patched/${wanted_version}
  for package_path in "${package_paths[@]}"; do
    class_name=$(basename "$package_path" .class)
    patch $temp_dir_decompiled/$class_name.original.java patches/${wanted_version}/$class_name.patch -o patched/${wanted_version}/$class_name.java
  done;
fi

## Build

### Required for build
elasticsearch_dir="$(pwd)/versions/$wanted_version"
build_libs="$elasticsearch_dir/lib/elasticsearch-$wanted_version.jar"
build_libs="$build_libs:$elasticsearch_dir/modules/x-pack-core/x-pack-core-$wanted_version.jar"
build_libs="$build_libs:$elasticsearch_dir/lib/elasticsearch-core-$wanted_version.jar"
echo "build_libs: $build_libs"

### Compile patched files
cd patched/$wanted_version
for package_path in "${package_paths[@]}"; do
  class_name=$(basename "$package_path" .class)
  echo "compiling $class_name"
  javac -cp $build_libs $class_name.java
done;
cd ../..

### Replace files in extracted jar
echo "replacing class files with patched ones"
for package_path in "${package_paths[@]}"; do
  class_name=$(basename "$package_path" .class)
  mv -vf patched/$wanted_version/$class_name.class $temp_dir/$package_path
done;

### recompress jar
cd $temp_dir
echo "recompressing jar"
jar cf x-pack-patched-$wanted_version.jar .
mv x-pack-patched-$wanted_version.jar ../../patched/$wanted_version/
cd ../..

echo "Patched version is available in patched/${wanted_version}/x-pack-patched-${wanted_version}.jar"
echo "Install it in your elasticsearch installation by replacing the original x-pack-core-${wanted_version}.jar in modules/x-pack-core/ with this patched version"
echo "This tool is not responsible for any damage caused by using the patched version"
echo "Do not use it in production environment"
