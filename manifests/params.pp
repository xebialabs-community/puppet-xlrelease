# == Class xlrelease::params
#
# This class is meant to be called from xlrelease
# It sets variables according to platform
#
class xlrelease::params {
  case $::osfamily {
    'RedHat': {
      $package_name = 'xlrelease'
      $service_name = 'xlrelease'
    }
    default: {
      fail("${::osfamily} not supported")
    }
  }
}
