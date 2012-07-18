
class ntp::default {
  $ntp_package_ensure = 'present'
  $ntp_service_ensure = 'running'
}
