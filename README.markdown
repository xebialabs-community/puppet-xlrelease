#xlrelease

####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with [puppet-xlrelease]](#beginning-with-[puppet-xlrelease])
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

##Overview

A module that takes care of the installation and configuration regarding XL-Release by Xebialabs      

##Module Description
This Module is geared toward the installation and configuration of Xebialabs XL-Release. It will take care of the installation of xl-release on linux based systems as well as doing a lot of the standard configuration required to setup a production ready instance of xl-release.

##Setup


###Setup Requirements 

This module requires the following:

* pluginsync enabled
* module puppetlabs-stdlib installed
* module puppetlabs-concat installed

  
###Beginning with [puppet-xlrelease]  

##Usage

###basic installation

    class{xlrelease:
        install_java => true,
        install_type: 'download'
        xlr_download_user: '<your download user>'
        xlr_download_password: '<your download password'
        xlr_licsource: 'https://dist.xebialabs.com/customer/licenses/download/xl-release-license.lic'
     }
    
this will install a basic instance of xl-release at /opt/xl-release/xl-release-server which will respond on port 5516.

###adding configuration
**adding a xl-deploy server to the configuration**

    xlrelease_xld_server{'default':
         properties => { 'url' => 'http://your.xld.instance:4516/<context_root>',
                         'username' => 'your xld user',
                         'password' => 'your xld password' 
                        }
    }          

**adding a jenkins server to the configuration**

    xlrelease_config_item{'jenkins_default':
        type => 'jenkins.Server',
        properties => { username: "jenkins user name"
                        title: "title in xlr"
                        proxyHost: <optional proxy host .. null for no proxy>
                        proxyPort: <optional proxy port .. null for no port>
                        password: "jenkins user password"
                        url: 'http://your_jenkins_host_goes_here:and_the_port_here'
        }
    }

**adding a git repo to the configuration**

    xlrelease_config_item{'your_git_repo':
        type => 'git.Repository',
        properties => { username: "git user name"
                        title: "title in xlr"
                        password: "git user password"
                        url: 'http://url.to.git/repo'
        }
    }

**adding a xl-deploy server to the configuration from a different system using puppet** 
this code could be used in a manifest when installing a xl-deploy server using puppet

    xlrelease_xld_server{'default':
             properties => { 'url' => "http://${fqdn}:4516/<context_root>",
                             'username' => 'your xld user',
                             'password' => 'your xld password' 
                            }
             rest_url => 'http://user:password@your.xl-release.com:5516/<something>'
        } 

**adding a jenkins server to the configuration from a different system using puppet**
this code could be used in a manifest when installing a jenkins server using puppet

    xlrelease_config_item{'jenkins_default':
        type => 'jenkins.Server',
        rest_url => 'http://user:password@your.xl-release.com:5516/<something>',
        properties => { username: "jenkins user name"
                        title: "title in xlr"
                        proxyHost: <optional proxy host .. null for no proxy>
                        proxyPort: <optional proxy port .. null for no port>
                        password: "jenkins user password"
                        url: 'http://your_jenkins_host_goes_here:and_the_port_here'
                        }
    }

**adding a git repo to the configuration form a different system using puppet**

    xlrelease_config_item{'your_git_repo':
        type => 'git.Repository',
        rest_url => 'http://user:password@your.xl-release.com:5516/<something>',
        properties => { username: "git user name"
                        title: "title in xlr"
                        password: "git user password"
                        url: 'http://url.to.git/repo'
                       }
    }


###using hiera 

**basic installation**

    ---
      xlrelease::install_java: true 
      xlrelease::install_type: 'download'
      xlrelease::xlr_download_user: 'get one'
      xlrelease::xlr_download_password: 'not telling you that'
      xlrelease::xlr_licsource: 'https://dist.xebialabs.com/customer/licenses/download/xl-release-license.lic'
      
**adding a xl-deploy server to the configuration**
the module commes equiped with a hash parameters for use with hiera

    ---
      xlrelease::xlr_xldeploy_hash:
          'default':
            properties:
             url: "http://your.xld.instance:4516/<context_root>"
             username: "your xld user"
             password: "your xld password"
      
    
**adding a jenkins server and a git repo to the configuration**

    ---
      xlrelease::xlr_config_item_hash:
          'jenkins1':
            type: 'jenkins.Server'
            title: 'jenkins1'
            properties:
              username: "jenkins user"
              title: "title in xlr"
              proxyHost:  <optional proxy host .. null for no proxy>
              proxyPort:  <optional proxy host .. null for no proxy>
              password: "jenkins user password"
              url: 'http://your_jenkins_host_goes_here:and_the_port_here'
          'git_test1':
             type: 'git.Repository'
             title: 'git_test1'
             properties:
               username: 'git user name'
               password: 'title in xlr'
               url: 'http://url.to.git/repo'
               title: 'title in xlr'
    

      
##Reference

####Public classes

**xlrelease**
#####os_user         
    the user that will be used to run xlr and installed on the os by the module (unless it's already there)
    default: xlrelease
#####os_group         
    the group that will be used to run xlr and installed on the os by the module (unless it's already there)
    default: xlrelease
#####tmp_dir   
    specifies a temporary file storage space for the module to store downloaded stuff
    default: /var/tmp
#####xlr_version     
    specifies the version of xlr to install
    default : 4.5.1
#####xlr_basedir   
    specifies the base installation directory for xlr
    default: /opt/xl-release
#####xlr_serverhome         
    specifies the xlrelease server home directory
    default: /opt/xl-release/xl-release-server
#####xlr_licsource
    specifies where the xl-release license can be obtained
    default: no help there .. sorry
#####xlr_repopath
    specifies the path to the xlr repository on the filesystem
    either specify a full path prefixed with file:/// or a directory relative to the server home 
    default: repository
#####xlr_initrepo      
    specifies if we should initialize the repo upon installation
    default: true
#####xlr_http_port                
    specifies the port xlr will respond to 
    default: 5516
#####xlr_http_bind_address
    specifies the address the instance binds to 
    default: 0.0.0.0 (listens to all incomming traffic)
#####xlr_http_context_root        
    specifies the context root xlr will respond on 
    default: /
#####xlr_importable_packages_path
    specifies the path to the imporatble packages 
    either specify a full path prefixed with file:/// or a directory relative to the server home 
    default: importablePackages
#####xlr_ssl  
    specifies if the module should setup ssl traffic to the server
    default: false
#####xlr_download_user
     specifies the xlr download user account (can be obtaind from xebialabs)
     default: undef
#####xlr_download_password
     specifies the xlr download user password (can be obtained form http://www.xebialabs.com)
     default: undef
#####xlr_download_proxy_url
     specifies a proxy url if one is needed to obtain a direct internet connection
     default: undef
#####xlr_rest_user 
     specifies the restuser to be used for interfacing from the module to the xlr instance
     default: admin
#####xlr_rest_password            
     specifies the restusers password
     default: xebialabs
#####xlr_admin_password           
     specifies the admin password xlr will be setup with
     default: xebialabs
#####java_home         
     specifies the java_home which will be used to run xlr
     default: 'RedHat' : '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64'
              'Debian' : '/usr/lib/jvm/java-7-openjdk-amd64'
#####install_java 
     specifies if java should be installed as part of this modules duties
#####install_type            
     specifies the type of installation method where gonna use: 
     default: download
     choices: 
        download: download source from xebialabs.com (preffered)
        puppetfiles: get the source from a specified puppet files location
#####puppetfiles_xlrelease_source 
     specifies the source location of the xlr installation for use with a puppetfiles installation type
#####custom_download_server_url   
     specify a custom download url (other than the standard xebialabs one provided by the module)
#####xlr_xldeploy_hash            
     allows for the specification of multiple xl-deploy instances in a hash format (see instructions above)
#####xlr_config_item_hash         
     allows for the specifiaction of multiple xl-release configuration items in a hash format (see instructions above) 

####types and provider pairs
**xlrelease_xld_server**

this resource can be used to configure a xl-deploy instance in a xlr instance

#####type
   the type of ci to configure in xlr (no point in changing this on this resource !!!!)
   default : 'xlrelease.DeployitServerDefinition'     
#####properties
   the properties the should be configured in xld 
        'url': the url to reach the xldeploy server on 
        'username': the username of the xldeploy server
        'password': the password to go along with the username
#####rest_url
   a url to reach the external xlr server on (which is optional) 
   use this if u are using this resource from a different server other than the xlr server
   default: undef

**xlrelease_config_item**

this resource can be used to influence a configuration item in an xlr instance

#####type
   the type of ci to configure in xlr 
   posiblities: jenkins.Server, git.Repository (amongst others ... this has to be valid in xlr)
#####properties
   the properties the should be configured in xld (dependent on the type)
#####rest_url
   a url to reach the external xlr server on (which is optional) 
   use this if u are using this resource from a different server other than the xlr server
   default: undef

##Limitations

###os compatibility
* Debian (all recent versions)
* Ubuntu (all recent versions) 12.02 and 14.02 supported
* Redhat (6&7 supported)
* CentOS (6&7 supported)

###xlrelease compatibility
versions 4.0.13 and 4.5.1 tested
##Development

* No real rules yet, but a test set will be setup pretty soon. 
* Pull requests will be evaluated and if they make sense they will be incorporated in the module

##Release Notes/Contributors/Etc **Optional**

###Maintainers
* Wian Vos 

###Contributors
* Wian Vos

** help wanted **