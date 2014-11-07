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
  $install_java                 = $xlrelease::params::install_java,
  $install_type                 = $xlrelease::params::install_type,
  $puppetfiles_xlrelease_source = $xlrelease::params::puppetfiles_xlrelease_source,
) inherits xlrelease::params {

  # validate parameters here

  anchor { 'xlrelease::begin': } ->
  class  { '::xlrelease::install': } ->
  class  { '::xlrelease::config': } ~>
  class  { '::xlrelease::service': } ->
  anchor { 'xlrelease::end': }
}
