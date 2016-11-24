# Module for installing CloudWatchMonitoringScripts and using them to schedule Cloud Watch metrics update
define awscloudwatchtools::monitordisk (
  $disk_path         = $title,
  $frequency_minutes = 5,
) {
  include awscloudwatchtools

  $monitordisk_command = "${awscloudwatchtools::scripts_dir}/mon-put-instance-data.pl --disk-space-util --disk-path=${disk_path} --from-cron ${awscloudwatchtools::aws_cli_config_file}"
  $cron_time = "*/${frequency_minutes} * * * *"

  file { "/etc/cron.d/monitor_${title}":
    content => "${cron_time} root ${monitordisk_command}",
    mode    => '0644',
    require => [
      Package['libwww-perl'],
      Package['libcrypt-ssleay-perl'],
    ],
  }

}
