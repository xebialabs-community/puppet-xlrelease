#private class
class xlrelease::postconfig {

  $xlr_xldeploy_hash     = $xlrelease::xlr_xldeploy_hash
  $xlr_config_item_hash  = $xlrelease::xlr_config_item_hash
  $rest_url              = $xlrelease::rest_url

  # Make this a private class
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $defaults = {
    rest_url => $rest_url,
    require  => Xlrelease_check_connection['default'],
    'type'   => 'xlrelease.DeployitServerDefinition',
  }

  # config stuff in xldeploy
  create_resources(xlrelease_xld_server, $xlr_xldeploy_hash, $defaults)
  create_resources(xlrelease_config_item, $xlr_config_item_hash, $defaults)

}