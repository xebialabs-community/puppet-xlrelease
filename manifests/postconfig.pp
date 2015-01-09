class xlrelease::postconfig{

  $xlr_xldeploy_hash  = $xlrelease::xlr_xldeploy_hash
  $rest_url           = $xlrelease::rest_url


  $defaults = { rest_url => $rest_url,
   require  => Xlrelease_check_connection['default']
   type     => 'xlrelease.DeployitServerDefinition',
  }

  # config stuff in xldeploy
  create_resources(xlrelease_xld_server, $xlr_xldeploy_hash, $defaults)

}