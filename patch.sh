#!/bin/bash -e

#elasticsearch_dir="elasticsearch-8.7.0"
#elasticsearch_version=$(echo $elasticsearch_dir | cut -d'-' -f2)
jd_cli_url="https://github.com/intoolswetrust/jd-cli/releases/download/jd-cli-1.2.0/jd-cli-1.2.0-dist.tar.gz"

x_pack_modules_file="modules/x-pack-core/x-pack-core-8.7.0.jar"

package_path_XPackBuild="org/elasticsearch/xpack/core/XPackBuild.class"
package_path_License="org/elasticsearch/license/LicenseVerifier.class"

export PATH=$PATH:$elasticsearch_dir/jdk/bin

mkdir -p tmp/dl

# download jd-cli for decompiling
if [ ! -f "tmp/jd-cli.jar" ]; then
    echo "jd-cli.jar does not exist"
    wget -O tmp/dl/jd_cli.tar.gz $jd_cli_url
    tar -xvf tmp/dl/jd_cli.tar.gz -C tmp/dl
    mv tmp/dl/*.jar tmp
    rm -rf tmp/dl
else
    echo "jd-cli.jar already downloaded"
fi

cd tmp
# extract x_pack_modules_file
if [ ! -d "tmp/org" ]; then
    echo "uncompressing $x_pack_modules_file"    
    jar xf ../$elasticsearch_dir/$x_pack_modules_file
else
    echo "$x_pack_modules_file already extracted"
fi

# decompile package_path_XPackBuild & package_path_License
# and remove first line of decompiled debug info
echo "decompiling $package_path_XPackBuild"
java -jar jd-cli.jar $package_path_XPackBuild > XPackBuild.java
tail -n +2 XPackBuild.java > XPackBuild.pached.java
mv XPackBuild.pached.java XPackBuild.java
echo "decompiling $package_path_License"
java -jar jd-cli.jar $package_path_License > LicenseVerifier.java
tail -n +2 LicenseVerifier.java > LicenseVerifier.pached.java
mv LicenseVerifier.pached.java LicenseVerifier.java
cd ..

# patch files (logs is generated by patch command)
patch tmp/LicenseVerifier.java patch/LicenseVerifier.java.patch
patch tmp/XPackBuild.java patch/XPackBuild.java.patch

build_libs="$(pwd)/$elasticsearch_dir/lib/elasticsearch-$elasticsearch_version.jar"
build_libs="$build_libs:$(pwd)/$elasticsearch_dir/modules/x-pack-core/x-pack-core-$elasticsearch_version.jar"
build_libs="$build_libs:$(pwd)/$elasticsearch_dir/lib/elasticsearch-core-$elasticsearch_version.jar"

echo "build_libs: $build_libs"

# compile news .class file
cd tmp
echo "compiling license verifier"
javac -cp $build_libs LicenseVerifier.java
echo "compiling xpack build"
javac -cp $build_libs XPackBuild.java

# replace file in extracted jar
echo "replacing class files with patched ones"
rm -f $package_path_XPackBuild
cp -v XPackBuild.class  org/elasticsearch/xpack/core/
rm -f $package_path_License
cp -f -v LicenseVerifier.class org/elasticsearch/license/

# clean before recompressing
echo "cleaning tmp file before recompressing"
rm -fv LicenseVerifier.java XPackBuild.java LicenseVerifier.class XPackBuild.class jd-cli.jar

# recompress jar
echo "recompressing jar"
jar cf x-pack-patched.jar .
mv x-pack-patched.jar ../
cd ..
rm -rf tmp

echo "moving patched jar to $elasticsearch_dir/modules/x-pack-core/"
rm -f $elasticsearch_dir/$x_pack_modules_file
cp -v x-pack-patched.jar $elasticsearch_dir/$x_pack_modules_file
