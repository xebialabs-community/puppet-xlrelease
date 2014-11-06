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
  $xlr_version                  = $xlrelease::params::xlr_version,
  $xlr_basedir                  = $xlrelease::params::xlr_basedir,
  $install_java                 = $xlrelease::params::install_java,
  $puppetfiles_xlrelease_source = $xlrelease::params::puppetfiles_xlrelease_source,
) inherits xlrelease::params {

  # validate parameters here

  anchor { 'xlrelease::begin': } ->
  class  { '::xlrelease::install': } ->
  class  { '::xlrelease::config': } ~>
  class  { '::xlrelease::service': } ->
  anchor { 'xlrelease::end': }
}
