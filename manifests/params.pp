
class ntp::params inherits ntp::default {

  $package         = module_param('package')
  $package_ensure  = module_param('package_ensure')
  $service         = module_param('service')
  $service_ensure  = module_param('service_ensure')

  $config          = module_param('config')
  $config_template = module_param('config_template')

  $servers         = module_array('servers')
}
