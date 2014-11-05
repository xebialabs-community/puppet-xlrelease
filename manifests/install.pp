# == Class xlrelease::install
#
class xlrelease::install {

  # Make this a private class
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { $xlrelease::params::package_name:
    ensure => present,
  }
}
