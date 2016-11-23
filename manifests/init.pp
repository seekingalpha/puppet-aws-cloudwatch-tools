# Install AWS CloudWatch Tools
class awscloudwatchtools (
  $access_key            = undef,
  $secret_key            = undef,
  $monitor_disks         = {},
  $cw_mon_script_version = $awscloudwatchtools::params::cw_mon_script_version,
  $install_dir           = $awscloudwatchtools::params::install_dir,
  $scripts_dir           = $awscloudwatchtools::params::scripts_dir,
) inherits awscloudwatchtools::params {

  include awscloudwatchtools::packages
  realize Package['libdatetime-perl', 'libswitch-perl', 'libwww-perl', 'libcrypt-ssleay-perl', 'unzip']

  $file_name = "CloudWatchMonitoringScripts-${cw_mon_script_version}.zip"
  $file_url = "http://aws-cloudwatch.s3.amazonaws.com/downloads/${file_name}"

  exec { 'download-aws-tools':
    cwd     => $install_dir,
    command => "/usr/bin/wget ${file_url}",
    creates => "${install_dir}/${file_name}",
    timeout => 3600,
  }

  exec { 'extract-aws-tools':
    command => "/usr/bin/unzip ${file_name}",
    cwd     => $install_dir,
    creates => $scripts_dir,
    require => [
      Exec['download-aws-tools'],
      Package[unzip],
    ],
  }

  if $access_key and $secret_key {
    validate_string($access_key, $secret_key)
    file { "${scripts_dir}/awscreds.conf":
      content => template('awscloudwatchtools/awscreds.erb'),
      require => Exec['extract-aws-tools'],
    }
  }

  if !empty($monitor_disks){
    create_resources('awscloudwatchtools::monitordisk',$monitor_disks)
  }
}
