# == Class xlrelease::config
#
# This class is called from xlrelease
#
class xlrelease::config {

  # Make this a private class
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

}
