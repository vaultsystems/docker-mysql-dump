#!/bin/bash -x
set -e
last_backup=`swift list mysql-dump  | tail -1`
last_size=`swift stat mysql-dump $last_backup | grep "Content Length" | awk  '{print $3}'`
read -p "Are you sure you want to restore database dump '$last_backup' with size '$last_size' ? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	cd /mnt
	swift download mysql-dump $last_backup
	zcat $last_backup | mysql -h mysql
	rm $last_backup
fi
