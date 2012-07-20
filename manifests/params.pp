
class ntp::params {

  include ntp::default

  #-----------------------------------------------------------------------------
  # General configurations

  if $::hiera_ready {
    $ntp_package_ensure = hiera('ntp_package_ensure', $ntp::default::ntp_package_ensure)
    $ntp_service_ensure = hiera('ntp_service_ensure', $ntp::default::ntp_service_ensure)
    $servers            = hiera('ntp_servers', false)
  }
  else {
    $ntp_package_ensure = $ntp::default::ntp_package_ensure
    $ntp_service_ensure = $ntp::default::ntp_service_ensure
    $servers            = false
  }

  #-----------------------------------------------------------------------------
  # Operating system specific configurations

  case $::operatingsystem {
    debian, ubuntu: {
      $os_ntp_package     = 'ntp'
      $os_ntp_service     = 'ntp'

      $os_ntp_config      = '/etc/ntp.conf'
      $os_config_template = 'ntp/ntp.conf.debian.erb'

      $os_servers = $servers ? {
        false   => [
          '0.debian.pool.ntp.org iburst',
          '1.debian.pool.ntp.org iburst',
          '2.debian.pool.ntp.org iburst',
          '3.debian.pool.ntp.org iburst',
        ],
        default => $servers,
      }
    }
    centos, redhat, oel, linux: {
      $os_ntp_package     = 'ntp'
      $os_ntp_service     = 'ntpd'

      $os_ntp_config      = '/etc/ntp.conf'
      $os_config_template = 'ntp/ntp.conf.el.erb'

      $os_servers = $servers ? {
        false   => [
          '0.centos.pool.ntp.org',
          '1.centos.pool.ntp.org',
          '2.centos.pool.ntp.org',
        ],
        default => $servers,
      }
    }
    freebsd: {
      $os_ntp_package     = '.*/net/ntp'
      $os_ntp_service     = 'ntpd'

      $os_ntp_config      = '/etc/ntp.conf'
      $os_config_template = 'ntp/ntp.conf.freebsd.erb'

      $os_servers = $servers ? {
        false   => [
          '0.freebsd.pool.ntp.org iburst maxpoll 9',
          '1.freebsd.pool.ntp.org iburst maxpoll 9',
          '2.freebsd.pool.ntp.org iburst maxpoll 9',
          '3.freebsd.pool.ntp.org iburst maxpoll 9',
        ],
        default => $servers,
      }
    }
    default: {
      fail("The ntp module is not currently supported on ${::operatingsystem}")
    }
  }
}
