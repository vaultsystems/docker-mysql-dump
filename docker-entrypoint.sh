#!/bin/bash -x

set -e

cat > ~/.my.cnf <<EOF
[client]
user=root
password=$MYSQL_ROOT_PW
protocol=tcp
EOF

until mysql -h mysql_backup -e ";" ; do
  echo "waiting for connection to database host 'mysql_backup'..."
  sleep 3
done

while true; do
  f=/mnt/`date '+%Y-%m-%d_%H-%M-%S'`.sql.gz
  mysqldump -h mysql_backup --all-databases | gzip > $f
  swift upload mysql-dump $f
  rm $f
  sleep 10
done