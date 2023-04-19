# elasticsearch-xpack-patcher

**This project is for educational purposes only. do not use it for production.**

**I am not responsible for any damage caused by this project.**

## Description

This project is a patcher for elasticsearch x-pack-core plugin. It is a simple script that patches the x-pack-core plugin to remove the license check. By decompressing the x-pack-core plugin, patching the license check, and then compressing it again, the patched plugin is created.

## Usage

1. Download the [elasticsearch](https://www.elastic.co/downloads/elasticsearch) Linux x86_64 and extract it next to the path.sh file.
2. Edit the path.sh file and set the folder name and the version of the elasticsearch.
3. Run the patch.sh file. The patched file will automatically replace the original file. and is also saved next to the path.sh file.
4. Run the elasticsearch. and install a license.

## License install

1. get a license from [license.elastic.co](https://license.elastic.co/registration)
2. customize the license.json as you like.
    * change the license type to platinum.
    * change the expiry_date_in_millis to a date in the future.
    * change the max_nodes to the number of nodes you want to use.
    * change the issued_to to the name you want to use.
3. install the license.

> note between version url for license different please docs for version (example for v8)
```bash
curl -XPUT -u elastic 'https://<server>:9200/_license' -H "Content-Type: application/json" -d @license.json --insecure
```

## Credits

based on [elasticsearch7.0 Cluster Setup and x-pack crack by Hassankarimi118](https://hackmd.io/@Hassankarimi118/elastic)