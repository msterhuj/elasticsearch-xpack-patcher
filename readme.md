# elasticsearch-xpack-patcher

⚠️ **This project is for educational purposes only. do not use it for production.** ⚠️

⚠️ **I am not responsible for any damage caused by this project.** ⚠️

## Description

This project is a patcher for elasticsearch x-pack-core plugin. It is a simple script that patches the x-pack-core plugin to remove the license check. By decompressing the x-pack-core plugin, patching the license check, and then compressing it again, the patched plugin is created.

## Usage to patch xpack file

1. Enter into docker shell `make shell`
2. Run the `build.sh <VERSION>` with the version of elasticsearch you want to patch.
3. If you want docker image with the patch run `docker.sh <VERSION>` to create docker file and build image

## Create a new patch file

Whan to pach a new version of elasticsearch you need to create a new patch file.
To do this you need to decompile the x-pack-core plugin folow the steps below.

1. Enter into docker shell `make shell`
2. Run the `decompile.sh <VERSION>` with the version of elasticsearch you want to patch. (this will auto download the version and decompile the x-pack-core plugin)
3. Edit the java file ending with `patched.java` in the tmp/<VERSION>-decompiled folder as you like.
4. Run `make_patch.sh <VERSION>` with the version of elasticsearch to generate the patch file.
5. Run `build.sh <VERSION>` with the version of elasticsearch to patch the x-pack-core plugin. (requires the patch file)
6. Run `docker.sh <VERSION>` to create a docker image with the patched x-pack-core plugin.
7. Run `test.sh <VERSION>` to test the patched x-pack in docker container. (you will need to create a license file and execute the test.sh outside the docker container)

## License install

1. Get a license from [license.elastic.co](https://license.elastic.co/registration)
2. Customize the license.json as you like.
    * Change the license type to platinum.
    * Change the expiry_date_in_millis to a date in the future.
    * Change the max_nodes to the number of nodes you want to use.
    * Change the issued_to to the name you want to use.
3. Install the license.

> Note: between version url for license different please docs for version (example for v8)
```bash
curl -XPUT -u elastic 'https://<server>:9200/_license' -H "Content-Type: application/json" -d @license.json --insecure
```

## Credits

based on [elasticsearch7.0 Cluster Setup and x-pack crack by Hassankarimi118](https://hackmd.io/@Hassankarimi118/elastic)
totally rewritten by me to help the creation of patches for new versions of elasticsearch.
