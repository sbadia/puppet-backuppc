# Module:: backuppc
# Manifest:: mysql.pp
#
# Author:: Sebastien Badia (<seb@sebian.fr>)
# Date:: Thu Mar 01 00:54:37 +0100 2012
# Maintainer:: Sebastien Badia (<seb@sebian.fr>)
#

# Class:: backuppc::mysql
#
#
class backuppc::mysql{
  @@line {
    "custom_backuppc_mysql_${::fqdn}":
      ensure  => backuppc,
      file    => "/etc/backuppc/${::fqdn}.pl",
      backup  => '$Conf{DumpPreUserCmd}',
      line    => "\\\$Conf{DumpPreUserCmd} = '/usr/local/sbin/backuppc_mysql_dump.sh \\\$host';",
      tag     => 'backup_mysql',
      require => File["/etc/backuppc/${::fqdn}.pl"];
  }

  line {
    'backup_sudoers_cmd_mysql':
      file    => '/etc/sudoers',
      line    => 'Cmnd_Alias MYSQLDUMP = /usr/bin/mysqldump',
      require => Package['sudo'];
    'backup_sudoers_user_mysql':
      file    => '/etc/sudoers',
      line    => 'backup ALL= NOPASSWD: MYSQLDUMP',
      require => Package['sudo'];
  }
} # Class:: backuppc::client
