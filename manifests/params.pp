# == Class xlrelease::params
#
# This class is meant to be called from xlrelease
# It sets variables according to platform
#
class xlrelease::params {
  $xlr_version                  = '4.0.13'
  $xlr_basedir                  = '/opt/xl-release'
  $xlr_serverhome               = '/opt/xl-release/xl-release-server'
  $xlr_licsource                = undef
  $xlr_repopath                 = 'repository'
  $xlr_initrepo                 = true
  $xlr_http_port                = '5516'
  $xlr_http_bind_address        = '0.0.0.0'
  $xlr_http_context_root        = '/'
  $xlr_importable_packages_path = 'importablePackages'
  $xlr_ssl                      = false



  $os_user        = 'xl-release'
  $os_group       = 'xl-release'
  $tmp_dir        = '/var/tmp'
  $install_java   = true
  $install_type   = 'puppetfiles'
  $puppetfiles_xlrelease_source  = undef

  case $::osfamily {
    'RedHat' : {
      $java_home = '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64'
    }
    'Debian' : {
      $java_home = '/usr/lib/jvm/java-7-openjdk-amd64'
    }
    default  : { fail("operating system ${::operatingsystem} not supported") }
  }

}
