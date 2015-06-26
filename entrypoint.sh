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
  if ps aux | grep -v grep | grep backup ; then
    echo "Manual backup in progess, not backing up."
  else
    ./backup.sh
  fi
  sleep 7200
done
