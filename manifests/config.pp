# == Class xlrelease::config
#
# This class is called from xlrelease
#
class xlrelease::config {

  # get parameters
  $xlr_version                  = $xlrelease::xlr_version
  $xlr_basedir                  = $xlrelease::xlr_basedir
  $xlr_serverhome               = $xlrelease::xlr_serverhome
  $xlr_licsource                = $xlrelease::xlr_licsource
  $xlr_repopath                 = $xlrelease::xlr_repopath
  $xlr_initrepo                 = $xlrelease::xlr_initrepo
  $xlr_http_port                = $xlrelease::xlr_http_port
  $xlr_http_bind_address        = $xlrelease::xlr_http_bind_address
  $xlr_http_context_root        = $xlrelease::xlr_http_context_root
  $xlr_importable_packages_path = $xlrelease::xlr_importable_packages_path
  $xlr_ssl                      = $xlrelease::xlr_ssl
  $install_type                 = $xlrelease::install_type
  $install_java                 = $xlrelease::install_java
  $java_home                    = $xlrelease::java_home
  $os_user                      = $xlrelease::os_user
  $os_group                     = $xlrelease::os_group
  $tmp_dir                      = $xlrelease::tmp_dir
  $puppetfiles_xlrelease_source = $xlrelease::puppetfiles_xlrelease_source
  
  # Make this a private class
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }


  #flow controll
  anchor{'config_start':}
  -> File['xlrelease default properties']
  -> Ini_setting['xlrelease.admin.password','xlrelease.http.port','xlrelease.jcr.repository.path','xlrelease.jcr.repository.path',
                  'xlrelease.ssl','xlrelease.http.bind.address','xlrelease.http.context.root','xlrelease.importable.packages.path']
  -> Exec ['init xl-release']
  -> anchor{'config_end':}

  # resource defaults
  File {
    owner  => $os_user,
    group  => $os_group,
    ensure => present,
    mode   => '0640',
    ignore => '.gitkeep'
  }

  Ini_setting {
    path    => "${xlr_serverhome}/conf/xl-release-server.conf",
    ensure  => present,
    section => '',
  }

  # configuration settings
  #file { 'xlrelease default properties':
  #  ensure => present,
  #  path   => "${xlr_serverhome}/conf/deployit-defaults.properties",
  #}


  ini_setting {
    'xlrelease.admin.password':
    setting => 'admin.password',
    value   => 'admin01';
  
    'xlrelease.http.port':
    setting => 'http.port',
    value   => $xlr_http_port;
  
    'xlrelease.jcr.repository.path':
    setting => 'jcr.repository.path',
    value   => regsubst($xlr_repopath, '^/', 'file:///');
  
    'xlrelease.ssl':
    setting => 'ssl',
    value   => $xlr_ssl;
  
    'xlrelease.http.bind.address':
    setting => 'http.bind.address',
    value   => $xlr_http_bind_address;
  
    'xlrelease.http.context.root':
    setting => 'http.context.root',
    value   => $xlr_http_context_root;
  
    'xlrelease.importable.packages.path':
    setting => 'importable.packages.path',
    value   => $xlr_importable_packages_path;
  }


  if str2bool($xlr_initrepo) {
      exec { 'init xl-release':
        creates     => "${xlr_serverhome}/${xlr_repopath}",
        command     => "${xlr_serverhome}/bin/server.sh -setup -reinitialize -force -setup-defaults ${xlr_serverhome}/conf/xl-release-server.conf",
        user        => $os_user,
        environment => ["JAVA_HOME=${java_home}"]
      }
  } else {
      exec { 'init xl-release':
        creates     => "${xlr_serverhome}/${xlr_repopath}",
        command     => "${xlr_serverhome}/bin/server.sh -setup -force -setup-defaults ${xlr_serverhome}/conf/xl-release-server.conf",
        user        => $os_user,
        environment => ["JAVA_HOME=${java_home}"]
      }
  }
}
