# puppet-backuppc

Default settings backup only /etc and /var/backups, for backup another location, set 'backuppc_custom' puppetvar.
  Ex.
  backuppc_custom = $Conf{RsyncShareName} = ["/var/backups","/etc","/var/log","/var/lib/puppet","/root"];

## Authors
- Sebastien Badia
