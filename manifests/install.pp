# Install AWS CloudWatch Tools
class aws-cloudwatch-tools::install (
    $access_key,
    $secret_key,
    $install_dir = '/opt',
) {

  include Aws-cloudwatch-tools::Packages
  realize Package['libwww-perl', "libcrypt-ssleay-perl", "unzip"]

  $file_name = "CloudWatchMonitoringScripts-v1.1.0.zip"
  $scripts_dir = "${install_dir}/aws-scripts-mon"

  exec { "download-aws-tools":
    cwd     => $install_dir,
    command => "wget http://ec2-downloads.s3.amazonaws.com/cloudwatch-samples/${file_name}",
    creates => "${install_dir}/${file_name}",
    timeout => 3600,
  }

  exec { "extract-aws-tools":
    command => "unzip ${file_name}",
    cwd     => $install_dir,
    creates => $scripts_dir,
    require => [Exec["download-aws-tools"], Package["unzip"]]
  }

  file { "${scripts_dir}/awscreds.conf":
    content => template('aws-cloudwatch-tools/awscreds.erb'),
    require => Exec["extract-aws-tools"]
  }
}
