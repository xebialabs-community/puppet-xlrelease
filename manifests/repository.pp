#private class
class xlrelease::repository{
  $os_user                               = $xlrelease::os_user
  $os_group                              = $xlrelease::os_group
  $xlr_basedir                           = $xlrelease::xlr_basedir
  $xlr_serverhome                        = $xlrelease::xlr_serverhome
  $xlr_repository_type                   = $xlrelease::xlr_repository_type
  $xlr_datastore_jdbc_driver_url         = $xlrelease::xlr_datastore_jdbc_driver_url
  $xlr_datastore_url                     = $xlrelease::xlr_datastore_url
  $xlr_datastore_user                    = $xlrelease::xlr_datastore_user
  $xlr_datastore_password                = $xlrelease::xlr_datastore_password
  $xlr_datastore_databasetype            = $xlrelease::xlr_datastore_databasetype
  $xlr_download_proxy_url                = $xlrelease::xlr_download_proxy_url
  $xlr_xlr_repopath                      = $xlrelease::xlr_xlr_repopath
  $xlr_cluster_role                = undef


  # Resource defaults
  File {
    owner  => $os_user,
    group  => $os_group,
    ensure => present,
    mode   => '0640',
    ignore => '.gitkeep'
  }

  if $xlr_repository_type == 'standalone' {
    file { "${xlr_serverhome}/conf/jackrabbit-repository.xml":
      content => template('xlrelease/repository/jackrabbit-repository-standalone.xml.erb')
    }
  } else {
    case $xlr_datastore_jdbc_driver_url {
      /^http/ : {
        xlrelease_repo_driver_netinstall{$xlr_datastore_jdbc_driver_url:
          ensure    => present,
          proxy_url => $xlr_download_proxy_url,
          lib_dir   => "${xlr_serverhome}/lib",
          owner     => $os_user,
          group     => $os_group,
        }
      }

      /^puppet/ : {
        $driver_file_name = get_filename($xlr_datastore_jdbc_driver_url)
        file{"${xlr_serverhome}/lib/${driver_file_name}":
          ensure => present,
          source => $xlr_datastore_jdbc_driver_url,
          owner  => $os_user,
          group  => $os_group,
        }
      }
      default : {}
    }

    if $xlr_cluster_role == undef {
      case $xlr_datastore_databasetype {
        /postgres/ : {
          file { "${xlr_serverhome}/conf/jackrabbit-repository.xml":
            content => template('xlrelease/repository/jackrabbit-repository-db-postgresql.xml.erb')
          }
        }
        /mysql/ : {
          file { "${xlr_serverhome}/conf/jackrabbit-repository.xml":
            content => template('xlrelease/repository/jackrabbit-repository-db-mysql.xml.erb')
          }
        }
        default : { fail "${xlr_datastore_databasetype} not supported" }
        }
      } else {
      case $xlr_datastore_databasetype {
        /postgres/ : {
          file { "${xlr_serverhome}/conf/jackrabbit-repository.xml":
            content => template('xlrelease/repository/jackrabbit-repository-db-postgresql-cluster.xml.erb')
          }
        }
        /mysql/ : {
          file { "${xlr_serverhome}/conf/jackrabbit-repository.xml":
            content => template('xlrelease/repository/jackrabbit-repository-db-mysql-cluster.xml.erb')
          }
        }
        default : { fail "${xlr_datastore_databasetype} not supported" }
        }
      }
    }

  /*if $xlr_cluster_role != undef {
    case $xlr_cluster_role {
      'master' : {
        class { 'nfs::server':}
        nfs::server::export{ "${xlr_serverhome}/${xlr_repopath}":
          ensure    => 'mounted',
          bind      => 'rbind',
          mount     => undef,
          remounts  => false,
          atboot    => true,
          options   => '_netdev',
          bindmount => undef,
          nfstag    => undef,
          clients   => '*(rw,no_subtree_check)'
        }
      }
      'slave'  : {
        if $use_exported_resources == true {
          include '::nfs::client'
          Nfs::Client::Mount <<| |>>{
            atboot    => true
          }
        } else {
          nfs::client::mount{ $xlrelease_cluster_nfs_repo_share:
            server => $xlrelease_cluster_leader,
            share  => $xlrelease_cluster_nfs_repo_share,
            owner  => $os_user,
            group  => $os_group
          }
        }
      }
      default : { fail 'cluster role should be set' }
    }
  }*/
}