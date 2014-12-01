# Module for installing CloudWatchMonitoringScripts and using them to schedule Cloud Watch metrics update
define awscloudwatchtools::monitordisk (
    $disk_path = $title,
    $frequency_minutes = 5,
    $install_dir = '/opt',
  ) {

  $scripts_dir = "${install_dir}/aws-scripts-mon"

  cron { "monitor $disk_path":
    command => "${scripts_dir}/mon-put-instance-data.pl --disk-space-util --disk-path=${disk_path} --from-cron --aws-credential-file=${scripts_dir}/awscreds.conf",
    minute  => "*/$frequency_minutes",
    require => [Class[Awscloudwatchtools::Install], Package["libwww-perl"], Package["libcrypt-ssleay-perl"]]
  }

}
