class xlrelease::postconfig{

  $xlr_xldeploy_hash  = $xlrelease::xlr_xldeploy_hash
  $rest_url           = $xlrelease::rest_url

  $defaults = { rest_url => $rest_url,
   require  => Xldeploy_check_connection['default']
  }

  # config stuff in xldeploy
  create_resources(xlrelease_xld_server, $xlr_xldeploy_hash, $defaults)

}