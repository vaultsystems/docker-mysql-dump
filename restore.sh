#!/bin/bash -x
set -e
$f=`swift list mysql-dump | tail -1`
read -p "Are you sure you want to restore database dump '$f' ? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	cd /mnt
	swift download mysql-dump $f
	zcat $f | mysql -h mysql
	rm $f
fi
