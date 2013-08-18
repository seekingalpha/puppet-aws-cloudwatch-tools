# Module for installing CloudWatchMonitoringScripts and using them to schedule Cloud Watch metrics update 
define aws-cloudwatch-tools::install (
    $access_key, 
    $secret_key,
    $destination_dir,
    $owner,
    $group,
  ) {

  $file_name = "CloudWatchMonitoringScripts-v1.1.0.zip"
  $extracted_dir = "aws-scripts-mon"
  $packages = [ "libwww-perl", "libcrypt-ssleay-perl" ]

  Package { ensure => "installed" }
  package { $packages: }

  exec { "download":
        user    => $owner,
        group   => $group,
        cwd     => $destination_dir,
        command => "wget http://ec2-downloads.s3.amazonaws.com/cloudwatch-samples/${file_name}",
        creates => "${destination_dir}/${file_name}",
        timeout => 3600,
  }

  exec { "extract":
        user    => $owner,
        group   => $group,
        command => "unzip ${file_name}",
        cwd     => $destination_dir,
        unless  => "find ${destination_dir} | grep ${extracted_dir}",
        require => [Exec["download"]]
  }

  file { "${destination_dir}/${extracted_dir}/awscreds.conf":
        content => template('aws-cloudwatch-tools/awscreds.erb'),
        owner   => $owner,
        group   => $group,
        require => Exec["extract"]
  }
}
