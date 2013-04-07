#!/bin/sh
# MANAGED BY PUPPET
# Module:: backuppc::mysql
#
# A simple script for dumping/tar all databases
#
set -e
/usr/bin/ssh -q -x -l backup $1 "/usr/bin/sudo /usr/bin/mysqldump --defaults-file=/etc/mysql/debian.cnf --all-databases --add-drop-database --result-file=/var/backups/all_db.sql && /bin/tar czf /var/backups/all_db.sql.tgz -P --remove-files /var/backups/all_db.sql"
