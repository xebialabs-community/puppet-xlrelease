# == Class xlrelease::install
#
class xlrelease::install {

  $xlr_version  = $xlrelease::xlr_version
  $install_java = $xlrelease::install_java
  $os_user      = $xlrelease::os_user
  $os_group     = $xlrelease::os_group

  # Make this a private class
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # install java packages if needed
  if str2bool($install_java) {
    case $::osfamily {
      'RedHat' : {
        $java_packages = ['java-1.7.0-openjdk']
        if !defined(Package[$java_packages]){
          package { $java_packages: ensure => present }
        }
      }
      'Debian' : {
        $java_packages = ['openjdk-7-jdk']
        if !defined(Package[$java_packages]){
          package { $java_packages: ensure => present }
        }
        $unzip_packages = ['unzip']
        if !defined(Package[$unzip_packages]){
          package { $unzip_packages: ensure => present }
        }

      }
      default  : {
        fail("${::osfamily}:${::operatingsystem} not supported by this module")
      }
    }
  }

  # user and group

  group { $os_group: ensure => 'present' }

  user { $os_user:
    ensure     => present,
    gid        => $os_group,
    managehome => false,
    home       => $os_user_home
  }

  # base dir

  file { $base_dir:
    ensure => directory,
    owner  => $os_user,
    group  => $os_group,
  }

  #the actual xl-release installation
  # we're only supporting puppetfiles for now
  case $install_type {
    'puppetfiles' : {

      $server_zipfile = "xl-release-${xlr_version}-server.zip"

      Anchor['server::install']

      -> file { "${tmp_dir}/${server_zipfile}": source => "${puppetfiles_xlrelease_source}/${server_zipfile}" }

      -> file { $server_install_dir: ensure => directory }

      -> exec { 'unpack server file':
        command => "/usr/bin/unzip ${tmp_dir}/${server_zipfile};/bin/cp -rp ${tmp_dir}/xl-release-${xlr_version}-server/* ${server_install_dir}",
        creates => "${server_install_dir}/bin",
        cwd     => $tmp_dir,
        user    => $os_user
      }

      -> Anchor['server::postinstall']
    }

  default       : {
    }
  }

}
