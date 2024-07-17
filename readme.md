# elasticsearch-xpack-patcher

⚠️ **This project is for educational purposes only. do not use it for production.** ⚠️

⚠️ **I am not responsible for any damage caused by this project.** ⚠️

## Description

This project is a patcher for elasticsearch x-pack-core plugin. It is a simple script that patches the x-pack-core plugin to remove the license check. By decompressing the x-pack-core plugin, patching the license check, and then compressing it again, the patched plugin is created.

## Usage to patch xpack file

1. Enter into docker shell `make shell`
2. Run the build.sh with the version of elasticsearch you want to patch.

## Create a new patch file

Whan to pach a new version of elasticsearch you need to create a new patch file.
To do this you need to decompile the x-pack-core plugin folow the steps below.

1. Enter into docker shell `make shell`
2. Run the `decompile.sh` with the version of elasticsearch you want to patch. (this will auto download the version and decompile the x-pack-core plugin)
3. Edit the java file ending with `patched.java` in the tmp/<VERSION>-decompiled folder as you like.
4. Run `make_patch.sh` with the version of elasticsearch to generate the patch file.
5. Run `build.sh` with the version of elasticsearch to patch the x-pack-core plugin.

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
