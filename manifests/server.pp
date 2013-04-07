# Module:: backuppc
# Manifest:: server.pp
#
# Author:: Sebastien Badia (<seb@sebian.fr>)
# Date:: Thu Mar 01 00:54:37 +0100 2012
# Maintainer:: Sebastien Badia (<seb@sebian.fr>)
#

# Class:: backuppc::server inherits backuppc
#
#
class backuppc::server inherits backuppc {
  package {
    ['backuppc','libfile-rsyncp-perl','rsync']:
      ensure  => installed,
      require => [User['backuppc'],Group['backuppc']];
  }

  user {
    'backuppc':
      ensure     => present,
      shell      => '/bin/sh',
      home       => '/var/lib/backuppc',
      managehome => true;
  }

  group {
    'backuppc':
      ensure  => present;
  }

  service {
    'backuppc':
      ensure    => running,
      restart   => '/etc/init.d/backuppc reload',
      hasstatus => false,
      require   => Package['backuppc'];
  }

  file {
    '/var/lib/backuppc/.ssh':
      ensure  => directory,
      owner   => backuppc,
      group   => backuppc,
      mode    => '0700',
      require => Package['backuppc'];
    '/var/lib/backuppc/.ssh/known_hosts':
      ensure  => absent,
      require => File['/var/lib/backuppc/.ssh'];
    '/var/lib/backuppc/.ssh/id_rsa':
      ensure  => file,
      source  => $backuppc::backuppc_privkey,
      owner   => backuppc,
      group   => backuppc,
      mode    => '0600',
      require => File['/var/lib/backuppc/.ssh'];
    '/var/lib/backuppc/.ssh/config':
      ensure  => file,
      source  => 'puppet:///modules/backuppc/ssh_config',
      owner   => backuppc,
      group   => backuppc,
      mode    => '0640',
      require => File['/var/lib/backuppc/.ssh'];
    '/etc/backuppc/config.pl':
      ensure  => file,
      content => template('backuppc/config.pl.erb'),
      owner   => backuppc,
      group   => www-data,
      mode    => '0644',
      notify  => Service['backuppc'],
      require => Package['backuppc'];
    '/etc/backuppc/hosts':
      ensure  => file,
      owner   => backuppc,
      group   => www-data,
      mode    => '0644',
      require => Package['backuppc'];
    '/etc/backuppc/apache.conf':
      ensure  => file,
      mode    => '0644',
      owner   => root,
      group   => root,
      source  => 'puppet:///modules/backuppc/apache.conf';
    ['/var/backups/log','/var/backups/cpool','/var/backups/pc',
    '/var/backups/pool','/var/backups/trash']:
      ensure  => directory,
      owner   => backuppc,
      group   => backuppc,
      mode    => '0750',
      require => Package['backuppc'];
    '/usr/local/sbin/backuppc_mysql_dump.sh':
      ensure  => file,
      source  => 'puppet:///modules/backuppc/mysql_backup.sh',
      owner   => root,
      group   => root,
      mode    => '0755';
  }

  line {
    'need-backuppc':
      file => '/etc/backuppc/hosts',
      line => 'host        dhcp    user    moreUsers     # <--- do not edit this line';
  }

  File <<| tag == 'backup_client' |>>
  Line <<| tag == 'backuppc_client' |>>
  Line <<| tag == 'backup_custom' |>>
  Line <<| tag == 'backup_mysql' |>>
} # Class:: backuppc::server inherits backuppc
