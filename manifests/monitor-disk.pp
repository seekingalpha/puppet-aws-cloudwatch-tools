# Module for installing CloudWatchMonitoringScripts and using them to schedule Cloud Watch metrics update 
define aws-cloudwatch-tools::monitor-disk (
    $disk_path = $title,
    $frequency_minutes,
    $access_key, 
    $secret_key,
    $install_dir,
    $owner,
    $group,
  ) {

  $file_name = "CloudWatchMonitoringScripts-v1.1.0.zip"
  $extracted_dir = "aws-scripts-mon"
  $scripts_dir = "${install_dir}/${extracted_dir}"

  $packages = [ "libwww-perl", "libcrypt-ssleay-perl" ]
  Package { ensure => "installed" }
  package { $packages: }

  exec { "download":
        user    => $owner,
        group   => $group,
        cwd     => $install_dir,
        command => "wget http://ec2-downloads.s3.amazonaws.com/cloudwatch-samples/${file_name}",
        creates => "${install_dir}/${file_name}",
        timeout => 3600,
  }

  exec { "extract":
        user    => $owner,
        group   => $group,
        command => "unzip ${file_name}",
        cwd     => $install_dir,
        unless  => "find ${install_dir} | grep ${extracted_dir}",
        require => [Exec["download"]]
  }

  file { "${scripts_dir}/awscreds.conf":
        content => template('aws-cloudwatch-tools/awscreds.erb'),
        owner   => $owner,
        group   => $group,
        require => Exec["extract"]
  }

  cron { "monitor $disk_path":
    command => "${scripts_dir}/mon-put-instance-data.pl --disk-space-util --disk-path=${disk_path} --from-cron --aws-credential-file=${scripts_dir}/awscreds.conf",
    user    => root,
    minute  => "*/$frequency_minutes",
    require => [File["${scripts_dir}/awscreds.conf"], Package["libwww-perl"], Package["libcrypt-ssleay-perl"]]
  }

}
