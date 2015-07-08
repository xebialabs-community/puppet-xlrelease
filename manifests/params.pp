# == Class xlrelease::params
#
# This class is meant to be called from xlrelease
# It sets variables according to platform
#
class xlrelease::params {
  $xlr_version                  = '4.5.1'
  $xlr_basedir                  = '/opt/xl-release'
  $xlr_serverhome               = '/opt/xl-release/xl-release-server'
  $xlr_licsource                = 'https://dist.xebialabs.com/customer/licenses/download/v2/xl-release-license.lic'
  $xlr_repopath                 = 'repository'
  $xlr_initrepo                 = true
  $xlr_http_port                = '5516'
  $xlr_http_bind_address        = '0.0.0.0'
  $xlr_http_context_root        = '/'
  $xlr_importable_packages_path = 'importablePackages'
  $xlr_ssl                      = false
  $xlr_download_user            = undef
  $xlr_download_password        = undef
  $xlr_download_proxy_url       = undef
  $xlr_rest_user                = 'admin'
  $xlr_rest_password            = 'xebialabs'
  $xlr_admin_password           = 'xebialabs'
  $xlr_repository_type          = $xlrelease::params::xlr_repository_type
  $xlr_datastore_jdbc_driver_url= $xlrelease::params::xlr_datastore_jdbc_driver_url
  $xlr_datastore_url            = $xlrelease::params::xlr_datastore_url
  $xlr_datastore_user           = $xlrelease::params::xlr_datastore_user
  $xlr_datastore_password       = $xlrelease::params::xlr_datastore_password
  $xlr_datastore_databasetype   = $xlrelease::params::xlr_datastore_databasetype

  $os_user        = 'xl-release'
  $os_group       = 'xl-release'
  $tmp_dir        = '/var/tmp'
  $install_java   = true
  $install_type   = 'download'
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
