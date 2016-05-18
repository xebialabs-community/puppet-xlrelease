#define: wrappersetting
# a defined resource that keeps track of xldeploy wrapper settings as set in the
# $server_home_dir/conf/xlr-wrapper-linux.conf file
define xlrelease::resources::wrappersetting (
  $value,
  $key = $name,
  $ensure = present,
  $server_home_dir = $xlrelease::xlr_serverhome 
) {
  $defaultFile = "${server_home_dir}/conf/xlr-wrapper-linux.conf"

  ini_setting { $name:
    ensure            => $ensure,
    setting           => $key,
    value             => $value,
    path              => $defaultFile,
    key_val_separator => '=',
    section           => ''
  }
}
