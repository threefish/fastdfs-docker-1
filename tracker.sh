#!/bin/sh
sed -i "s#\(base_path\).*#\1=$TRACKER_BASE_PATH#" /etc/fdfs/tracker.conf

/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf restart
tail -f /export/fastdfs/tracker/logs/trackerd.log
