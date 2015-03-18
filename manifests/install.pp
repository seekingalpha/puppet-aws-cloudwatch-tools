# Install AWS CloudWatch Tools
class awscloudwatchtools::install (
    $access_key,
    $secret_key,
    $install_dir = '/opt',
) {

  include Awscloudwatchtools::Packages
  realize Package['libwww-perl', "libcrypt-ssleay-perl", "unzip"]

  $file_name = "CloudWatchMonitoringScripts-1.2.0.zip"
  $scripts_dir = "${install_dir}/aws-scripts-mon"

  exec { "download-aws-tools":
    cwd     => $install_dir,
    command => "/usr/bin/wget http://aws-cloudwatch.s3.amazonaws.com/downloads/${file_name}",
    creates => "${install_dir}/${file_name}",
    timeout => 3600,
  }

  exec { "extract-aws-tools":
    command => "unzip ${file_name}",
    cwd     => $install_dir,
    creates => $scripts_dir,
    path    => '/usr/bin',
    require => [Exec["download-aws-tools"], Package["unzip"]]
  }

  file { "${scripts_dir}/awscreds.conf":
    content => template('awscloudwatchtools/awscreds.erb'),
    require => Exec["extract-aws-tools"]
  }
}
