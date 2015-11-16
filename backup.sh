#!/bin/bash -x
# set permissions for tableau (unrelated to backup)
mysql -h mysql -p$MYSQL_ROOT_PW -N -s -r -e "SELECT CONCAT(\"GRANT SELECT ON ESC4.\", table_name, \" TO tableau@'%';\") FROM information_schema.TABLES WHERE table_schema = \"ESC4\" AND table_name <> \"jobs\" AND table_name <> \"old_jobs\";" > /tmp/sql
mysql -h mysql -p$MYSQL_ROOT_PW -N -s -r -e "SELECT CONCAT(\"GRANT SELECT ON training_ESC4.\", table_name, \" TO tableau@'%';\") FROM information_schema.TABLES WHERE table_schema = \"training_ESC4\" AND table_name <> \"jobs\" AND table_name <> \"old_jobs\";" >> /tmp/sql
mysql -h mysql -p$MYSQL_ROOT_PW < /tmp/sql
# start backup
set -e
cd /mnt
# delete old leftover backup files
find *.gz -mtime +1 -exec rm {} \; || true
new_backup=`date '+%Y-%m-%d_%H-%M-%S'`.sql.gz
last_backup=`swift list mysql-dump  | tail -1`
last_size=`swift stat mysql-dump $last_backup | grep "Content Length" | awk  '{print $3}'`
mysqldump -h mysql_backup --max_allowed_packet=256M -R --opt --skip-lock-tables --all-databases | gzip > $new_backup
new_size=`ls -l $new_backup | awk '{print $5}'`
echo "Last backup: $last_size bytes , new backup: $new_size bytes"
if [ "$new_size" -lt "1000000" ]; then
	echo "Backup size smaller than 1MB, not backing up"
else
	swift upload mysql-dump $new_backup
fi
rm $new_backup
