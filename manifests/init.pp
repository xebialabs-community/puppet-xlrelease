# == Class: xlrelease
#
# Full description of class xlrelease here.
#
# === Parameters
#
# [*os_user*]
#    the user that will be used to run xlr and installed on the os by the module (unless it's already there)
#    default: xlrelease
# [*os_group*]
#    the group that will be used to run xlr and installed on the os by the module (unless it's already there)
#    default: xlrelease
# [*tmp_dir*]
#    a temporary file storage space for the module to store downloaded stuff
#    default: /var/tmp
# [*xlr_version*]
#    specifies the version of xlr to install
#    default : 4.5.1
# [*xlr_basedir*]
#    the base installation directory for xlr
#    default: /opt/xl-release
# [*xlr_serverhome*]
#    specifies the xlrelease server home directory
#    default: /opt/xl-release/xl-release-server
# [*xlr_licsource*]
#    specifies where the xl-release license can be obtained
#    default: no help there .. sorry
# [*xlr_repopath*]
#    specifies the path to the xlr repository on the filesystem
#    either specify a full path prefixed with file:/// or a directory relative to the server home
#    default: repository
# [*xlr_initrepo*]
#    specifies if we should initialize the repo upon installation
#    default: true
# [*xlr_http_port*]
#    specifies the port xlr will respond to
#    default: 5516
# [*xlr_http_bind_address*]
#    specifies the address the instance binds to
#    default: 0.0.0.0 (listens to all incomming traffic)
# [*xlr_http_context_root*]
#    specifies the context root xlr will respond on
#    default: /
# [*xlr_importable_packages_path*]
#    specifies the path to the imporatble packages
#    either specify a full path prefixed with file:/// or a directory relative to the server home
#    default: importablePackages
# [*xlr_ssl*]
#    specifies if the module should setup ssl traffic to the server
#    default: false
# [*xlr_download_user*]
#    the xlr download user account (can be obtaind from xebialabs)
#    default: undef
# [*xlr_download_password*]
#    specifies the xlr download user password (can be obtained form http://www.xebialabs.com)
#    default: undef
# [*xlr_download_proxy_url*]
#    specifies a proxy url if one is needed to obtain a direct internet connection
#    default: undef
# [*xlr_rest_user*]
#    specifies the restuser to be used for interfacing from the module to the xlr instance
#    default: admin
# [*xlr_rest_password*]
#    specifies the restusers password
#    default: xebialabs
# [*xlr_admin_password*]
#    specifies the admin password xlr will be setup with
#    default: xebialabs
# [*java_home*]
#    specifies the java_home which will be used to run xlr
#    default: 'RedHat' : '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64'
#             'Debian' : '/usr/lib/jvm/java-7-openjdk-amd64'
# [*install_java*]
#    specifies if java should be installed as part of this modules duties
#    default: false
# [*install_type*]
#    specifies the type of installation method where gonna use:
#    default: download
#    choices:
#     - download: download source from xebialabs.com (preffered)
#     - puppetfiles: get the source from a specified puppet files location
# [*puppetfiles_xlrelease_source*]
#   specifies the source location of the xlr installation for use with a puppetfiles installation type
# [*custom_download_server_url*]
#   specify a custom download url (other than the standard xebialabs one provided by the module)
# [*xlr_xldeploy_hash*]
#    allows for the specification of multiple xl-deploy instances in a hash format (see instructions in documentation)
# [*xlr_config_item_hash*]
#    allows for the specifiaction of multiple xl-release configuration items in a hash format (see instructions in documentation)
#
# === basic usage
# xlrelease_xld_server{'default':
#   properties => { 'url' => 'http://your.xld.instance:4516/<context_root>',
#   'username' => 'your xld user',
#   'password' => 'your xld password'
#     }
#   }
#
# === adding a jenkins server to the configuration
#
# xlrelease_config_item{'jenkins_default':
#   type => 'jenkins.Server',
#   properties => { username: "jenkins user name"
#                   title: "title in xlr"
#                   proxyHost: <optional proxy host .. null for no proxy>
#                   proxyPort: <optional proxy port .. null for no port>
#                   password: "jenkins user password"
#                   url: 'http://your_jenkins_host_goes_here:and_the_port_here'
#                 }
#   }
#
# === adding a git repo to the configuration**
#
#   xlrelease_config_item{'your_git_repo':
#     type => 'git.Repository',
#     properties => { username: "git user name",
#                     title: "title in xlr",
#                     password: "git user password",
#                     url: 'http://url.to.git/repo'
#                   }
#   }
class xlrelease (
  $os_user                      = $xlrelease::params::os_user,
  $os_group                     = $xlrelease::params::os_group,
  $tmp_dir                      = $xlrelease::params::tmp_dir,
  $xlr_version                  = $xlrelease::params::xlr_version,
  $xlr_basedir                  = $xlrelease::params::xlr_basedir,
  $xlr_serverhome               = $xlrelease::params::xlr_serverhome,
  $xlr_repopath                 = $xlrelease::params::xlr_repopath,
  $xlr_initrepo                 = $xlrelease::params::xlr_initrepo,
  $xlr_http_port                = $xlrelease::params::xlr_http_port,
  $xlr_http_bind_address        = $xlrelease::params::xlr_http_bind_address,
  $xlr_http_context_root        = $xlrelease::params::xlr_http_context_root,
  $xlr_importable_packages_path = $xlrelease::params::xlr_importable_packages_path,
  $xlr_ssl                      = $xlrelease::params::xlr_ssl,
  $xlr_download_user            = $xlrelease::params::xlr_download_user,
  $xlr_download_password        = $xlrelease::params::xlr_download_password,
  $xlr_download_proxy_url       = $xlrelease::params::xlr_download_proxy_url,
  $xlr_rest_user                = $xlrelease::params::xlr_rest_user,
  $xlr_rest_password            = $xlrelease::params::xlr_rest_password,
  $xlr_admin_password           = $xlrelease::params::xlr_admin_password,
  $java_home                    = $xlrelease::params::java_home,
  $install_java                 = $xlrelease::params::install_java,
  $install_type                 = $xlrelease::params::install_type,
  $puppetfiles_xlrelease_source = $xlrelease::params::puppetfiles_xlrelease_source,
  $custom_download_server_url   = undef,
  $xlr_xldeploy_hash            = {},
  $xlr_config_item_hash         = {}
) inherits xlrelease::params {


  # compose some variables based on the input to the class
  if ( $custom_download_server_url == undef ) {
    $xlr_download_server_url = "https://dist.xebialabs.com/customer/xl-release/${xlr_version}/xl-release-${xlr_version}-server.zip"
  } else {
    $xlr_download_server_url = $custom_download_server_url
  }


  if versioncmp($xlr_version, '4.6.9') > 0 {
    $xlr_licsource = 'https://dist.xebialabs.com/customer/licenses/download/v3/xl-release-license.lic'
  } else {
    $xlr_licsource = 'https://dist.xebialabs.com/customer/licenses/download/v2/xl-release-license.lic'
  }


  if str2bool($::xlr_ssl) {
    $rest_protocol = 'https://'
    # Check certificate validation
  } else {
    $rest_protocol = 'http://'
  }

  if ($xlr_http_context_root == '/') {
    $rest_url = "${rest_protocol}${xlr_rest_user}:${xlr_rest_password}@${xlr_http_bind_address}:${xlr_http_port}"
  } else {
    if $xlr_http_context_root =~ /^\// {
      $rest_url = "${rest_protocol}${xlr_rest_user}:${xlr_rest_password}@${xlr_http_bind_address}:${xlr_http_port}${xlr_http_context_root}"
    } else {
      $rest_url = "${rest_protocol}${xlr_rest_user}:${xlr_rest_password}@${xlr_http_bind_address}:${xlr_http_port}/${xlr_http_context_root}"
    }
  }
# validate parameters here

  anchor { 'xlrelease::begin': } ->
  class  { '::xlrelease::install': } ->
  class  { '::xlrelease::config': } ~>
  class  { '::xlrelease::service': } ->
  class  { '::xlrelease::postconfig': } ->
  anchor { 'xlrelease::end': }
}
