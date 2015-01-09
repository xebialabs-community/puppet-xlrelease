# == Class: xlrelease
#
# Full description of class xlrelease here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class xlrelease (
  $os_user                      = $xlrelease::params::os_user,
  $os_group                     = $xlrelease::params::os_group,
  $tmp_dir                      = $xlrelease::params::tmp_dir,
  $xlr_version                  = $xlrelease::params::xlr_version,
  $xlr_basedir                  = $xlrelease::params::xlr_basedir,
  $xlr_serverhome               = $xlrelease::params::xlr_serverhome,
  $xlr_licsource                = $xlrelease::params::xlr_licsource,
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
  $xlr_xldeploy_hash            = {}
) inherits xlrelease::params {


  # compose some variables based on the input to the class
  if ( $custom_download_server_url == undef ) {
    $xlr_download_server_url = "https://dist.xebialabs.com/xl-release/${xlr_version}/xl-release-${xlr_version}-server.zip"
  } else {
    $xlr_download_server_url = $custom_download_server_url
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
    if $http_context_root =~ /^\// {
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
  class  { '::xlrelease::postconfig':} ->
  anchor { 'xlrelease::end': }
}
