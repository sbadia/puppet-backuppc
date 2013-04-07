# Module:: backuppc
# Manifest:: init.pp
#
# Author:: Sebastien Badia (<seb@sebian.fr>)
# Date:: Thu Mar 01 00:54:37 +0100 2012
# Maintainer:: Sebastien Badia (<seb@sebian.fr>)
#
# Inspired by David Schmitt <david@schmitt.edv-bus.at>
#          git://github.com/DavidS/puppet-backuppc.git)

import 'client.pp'
import 'server.pp'
import 'mysql.pp'

# Class:: backuppc
#
#
class backuppc(
  $backuppc_pubkey  = 'puppet://puppetmaster.foobar.com/keys/backuppc.pub',
  $backuppc_privkey = 'puppet://puppetmaster.foobar.com/keys/backuppc.priv',
  $backuppc_server  = 'backuppc.foobar.com',
  ) {

} # Class:: backuppc
