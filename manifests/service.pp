# == Class xlrelease::service
#
# This class is meant to be called from xlrelease
# It ensure the service is running
#
class xlrelease::service {

  $xlr_port_number = $xlrelease::xlr_port_number

  # Make this a private class
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  service { 'xl-release':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  } ->
  xlrelease_check_connection{'default':
    port => $xlr_port_number
  }

}
