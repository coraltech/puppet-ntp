# Class: ntp
#
#   This module manages the ntp service.
#
#   Jeff McCune <jeff@puppetlabs.com>
#   2011-02-23
#
#   Tested platforms:
#    - Debian 6.0 Squeeze
#    - CentOS 5.4
#    - Amazon Linux 2011.09
#    - FreeBSD 9.0
#
# Parameters:
#
#   $servers = [ '0.debian.pool.ntp.org iburst',
#                '1.debian.pool.ntp.org iburst',
#                '2.debian.pool.ntp.org iburst',
#                '3.debian.pool.ntp.org iburst', ]
#
# Actions:
#
#  Installs, configures, and manages the ntp service.
#
# Requires:
#
# Sample Usage:
#
#   class { "ntp":
#     servers => [ 'time.apple.com' ],
#   }
#
# [Remember: No empty lines between comments and class definition]
class ntp (

  $package         = $ntp::params::package,
  $package_ensure  = $ntp::params::package_ensure,
  $config          = $ntp::params::config,
  $config_template = $ntp::params::config_template,
  $servers         = $ntp::params::servers,
  $service         = $ntp::params::service,
  $service_ensure  = $ntp::params::service_ensure,

) inherits ntp::params {

  #-----------------------------------------------------------------------------
  # Installation

  if ! $package or ! $package_ensure {
    fail('NTP package name and ensure parameter must be specified')
  }

  package { 'ntp':
    name   => $package,
    ensure => $package_ensure,
  }

  #-----------------------------------------------------------------------------
  # Configuration

  file { $config:
    ensure  => file,
    content => template($config_template),
    require => Package[$package],
  }

  #-----------------------------------------------------------------------------
  # Services

  if ! ($service_ensure in [ 'running', 'stopped' ]) {
    fail('Service ensure parameter must be running or stopped')
  }

  service { 'ntp':
    name       => $service,
    ensure     => $service_ensure,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => [ Package[$package], File[$config] ],
  }
}
