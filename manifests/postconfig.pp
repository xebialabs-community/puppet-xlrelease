class postconfig{
  $xldeploy_server_hash = $xlrelease::xldeploy_server_hash
  $rest_url             = $xlrelease::rest_url

  $defaults = { rest_url => $rest_url,
   require  => Xldeploy_check_connection['default']
  }

  # config stuff in xldeploy
  create_resources(xlrelease_xld_server, $xldeploy_server_hash, $defaults)

}