# == Class xlrelease::params
#
# This class is meant to be called from xlrelease
# It sets variables according to platform
#
class xlrelease::params {
  $os_user        = 'xl-release'
  $os_group       = 'xl-release'
  $xlr_version    = '4.0.13'
  $xlr_basedir    = '/opt'
  $xlr_serverhome = "/opt/xl-release/xl-release-server"
  $install_java   = true
  $puppetfiles_xlrelease_source  = undef
}
