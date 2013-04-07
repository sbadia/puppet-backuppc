# Module:: backuppc
# Manifest:: client.pp
#
# Author:: Sebastien Badia (<seb@sebian.fr>)
# Date:: Thu Mar 01 00:54:37 +0100 2012
# Maintainer:: Sebastien Badia (<seb@sebian.fr>)
#

# Class:: backuppc::client inherits backuppc
#
#
class backuppc::client inherits backuppc {
  include 'custom' # for line parser
  file {
    '/var/backups':
      ensure  => directory,
      owner   => backup,
      group   => backup,
      mode    => '0700',
      require => [User['backup'],Group['backup']];
    '/var/backups/.ssh':
      ensure  => directory,
      owner   => backup,
      group   => backup,
      mode    => '0700',
      require => File['/var/backups'];
    '/var/backups/.ssh/authorized_keys':
      ensure  => file,
      source  => $backuppc::backuppc_pubkey,
      owner   => backup,
      group   => backup,
      mode    => '0600',
      require => File['/var/backups/.ssh'];
  }

  user {
    'backup':
      ensure    => present,
      shell     => '/bin/bash',
      gid       => 'backup',
      home      => '/var/backups',
      allowdupe => false,
      require   => Group['backup'];
  }

  group {
    'backup':
      ensure   => present;
  }

  package {
    'sudo':
      ensure => installed;
  }

  line {
    'backup_sudoers_cmd':
      file    => '/etc/sudoers',
      line    => 'Cmnd_Alias RSYNC = /usr/bin/rsync',
      require => Package['sudo'];
    'backup_sudoers_user':
      file    => '/etc/sudoers',
      line    => 'backup ALL= NOPASSWD: RSYNC',
      require => Package['sudo'];
  }

  if $backuppc_custom != nil {
    @@line {
      "custom_backuppc_${::fqdn}":
        file    => "/etc/backuppc/${::fqdn}.pl",
        line    => $backuppc_custom,
        tag     => 'backup_custom',
        require => File["/etc/backuppc/${::fqdn}.pl"];
    }
  }

  @@file {
    "/etc/backuppc/${::fqdn}.pl":
      ensure  => file,
      mode    => '0644',
      owner   => backuppc,
      group   => www-data,
      tag     => 'backup_client';
  }

  @@line {
    "backuppc_${::fqdn}":
      file    => '/etc/backuppc/hosts',
      line    => "${::fqdn}     0     root",
      tag     => 'backuppc_client',
      notify  => Service['backuppc'];
  }
} # Class:: backuppc::client inherits backuppc
