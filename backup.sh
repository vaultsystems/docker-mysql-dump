#!/bin/bash -x
set -e
cd /mnt
f=`date '+%Y-%m-%d_%H-%M-%S'`.sql.gz
mysqldump -h mysql_backup --max_allowed_packet=256M -R --opt --skip-lock-tables --all-databases | gzip > $f
echo "Last backup:"
swift stat mysql-dump `swift list mysql-dump  | tail -1` | grep "Content Length"
echo "New backup:"
ls -l $f
echo
read -p "Are you sure you want to backup this database dump '$f' ? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  ls -lah $f
  swift upload mysql-dump $f
  rm $f
fi
