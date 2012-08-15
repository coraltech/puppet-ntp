
class ntp::default {

  $package_ensure = 'present'
  $service_ensure = 'running'

  #---

  case $::operatingsystem {
    debian, ubuntu: {
      $package         = 'ntp'
      $service         = 'ntp'

      $config          = '/etc/ntp.conf'
      $config_template = 'ntp/ntp.conf.debian.erb'

      $servers         = [
        '0.debian.pool.ntp.org iburst',
        '1.debian.pool.ntp.org iburst',
        '2.debian.pool.ntp.org iburst',
        '3.debian.pool.ntp.org iburst',
      ]
    }
    centos, redhat, oel, linux: {
      $package         = 'ntp'
      $service         = 'ntpd'

      $config          = '/etc/ntp.conf'
      $config_template = 'ntp/ntp.conf.el.erb'

      $servers         = [
        '0.centos.pool.ntp.org',
        '1.centos.pool.ntp.org',
        '2.centos.pool.ntp.org',
      ]
    }
    freebsd: {
      $package         = '.*/net/ntp'
      $service         = 'ntpd'

      $config          = '/etc/ntp.conf'
      $config_template = 'ntp/ntp.conf.freebsd.erb'

      $servers         = [
        '0.freebsd.pool.ntp.org iburst maxpoll 9',
        '1.freebsd.pool.ntp.org iburst maxpoll 9',
        '2.freebsd.pool.ntp.org iburst maxpoll 9',
        '3.freebsd.pool.ntp.org iburst maxpoll 9',
      ]
    }
    default: {
      fail("The ntp module is not currently supported on ${::operatingsystem}")
    }
  }
}
