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

#  xlrelease_xld_server{'xldeploy2':
#    ensure      => 'present',
#    type        => 'xlrelease.DeployitServerDefinition',
#    rest_url    => 'http://admin:admin01@localhost:5516',
#    properties  => {  "url"      => "http://10.20.1.4:4516/deployit2",
#                      "username" => "admin",
#                      "password" => "admin01" }
#  } ->
#  xlrelease_xld_server{'xldeploy':
#    ensure      => 'present',
#    type        => 'xlrelease.DeployitServerDefinition',
#    rest_url    => 'http://admin:admin01@localhost:5516',
#    properties  => {  "url"      => "http://10.20.1.4:4516/deployit",
#                      "username" => "admin",
#                      "password" => "admin01" }
#  }
  xlrelease_config_item{'jenkinst1':
    ensure => 'present',
    type   => 'jenkins.Server',
    rest_url => 'http://admin:admin01@localhost:5516',

  }
}
