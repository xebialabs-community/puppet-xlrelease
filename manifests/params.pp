# == Class xlrelease::params
#
# This class is meant to be called from xlrelease
# It sets variables according to platform
#
class xlrelease::params {
  $xlr_version    = '4.0.13'
  $xlr_basedir    = '/opt/xl-release'
  $xlr_serverhome = "/opt/xl-release/xl-release-server"

  $os_user        = 'xl-release'
  $os_group       = 'xl-release'
  $tmp_dir        = '/var/tmp'
  $install_java   = true
  $install_type   = 'puppetfiles'
  $puppetfiles_xlrelease_source  = undef
}
