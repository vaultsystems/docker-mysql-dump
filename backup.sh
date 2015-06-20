#!/bin/bash -x
set -e
cd /mnt
new_backup=`date '+%Y-%m-%d_%H-%M-%S'`.sql.gz
mysqldump -h mysql_backup --max_allowed_packet=256M -R --opt --skip-lock-tables --all-databases | gzip > $new_backup
last_backup=`swift list mysql-dump  | tail -1`
last_size=`swift stat mysql-dump $last_backup | grep "Content Length" | awk  '{print $3}'`
new_size=`ls -l $new_backup | awk '{print $5}'`
echo "Last backup: $last_size bytes , new backup: $new_size bytes"
if [ "$new_size" -lt "1000000" ]; then
	echo "Backup size smaller than 1MB, not backing up"
else
	swift upload mysql-dump $new_backup
	rm $new_backup
fi