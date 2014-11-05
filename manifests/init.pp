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
) inherits xlrelease::params {

  # validate parameters here

  anchor { 'xlrelease::begin': } ->
  class  { '::xlrelease::install': } ->
  class  { '::xlrelease::config': } ~>
  class  { '::xlrelease::service': } ->
  anchor { 'xlrelease::end': }
}
