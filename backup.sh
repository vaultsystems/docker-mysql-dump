#!/bin/bash -x
set -e
cd /mnt
f=`date '+%Y-%m-%d_%H-%M-%S'`.sql.gz
mysqldump -h mysql_backup --max_allowed_packet=256M -R --opt --skip-lock-tables --all-databases | gzip > $f
swift upload mysql-dump $f
rm $f