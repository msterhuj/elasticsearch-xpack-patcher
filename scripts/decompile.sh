#!/bin/bash

function decompile_xpack() {
    wanted_version=$1
    x_pack_modules_file="versions/${wanted_version}/modules/x-pack-core/x-pack-core-${wanted_version}.jar"
    temp_dir="tmp/${wanted_version}"
    temp_dir_decompiled="${temp_dir}-decompiled"
    package_paths=(
        "org/elasticsearch/xpack/core/XPackBuild.class"
        "org/elasticsearch/license/LicenseVerifier.class"
    )

    # extract x_pack_modules_file
    mkdir -vp $temp_dir $temp_dir_decompiled

    if [ ! -d "$temp_dir/org" ]; then
        cd $temp_dir
        echo "uncompressing $x_pack_modules_file"
        jar xf ../../${x_pack_modules_file}
        cd ..
    else
        echo "$x_pack_modules_file already extracted"
    fi

    # decompile package
    for package_path in "${package_paths[@]}"; do
        class_name=$(basename "$package_path" .class)
        echo "decompiling $package_path"
        # we need to move on the level to decomplie the class and not corupt the package path
        cd $temp_dir
        java -jar ../../jd-cli.jar $package_path > ../../$temp_dir_decompiled/$class_name.java
        cd ../..
        tail -n +2 $temp_dir_decompiled/$class_name.java > $temp_dir_decompiled/$class_name.original.java
        cp $temp_dir_decompiled/$class_name.original.java $temp_dir_decompiled/$class_name.pached.java
    done

    ls $temp_dir_decompiled
}