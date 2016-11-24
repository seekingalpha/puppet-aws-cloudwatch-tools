class awscloudwatchtools::monitor (
  $frequency_minutes = 5,
  $mem_util = false,
  $mem_used = false,
  $mem_avail = false,
  $swap_util = false,
  $swap_used = false,
) {
  include awscloudwatchtools

  validate_bool($mem_util, $mem_used, $mem_avail, $swap_util, $swap_used)

  if !$swap_used and !$swap_util and !$mem_avail and !$mem_used and !$mem_util
  {
    fail ('You have to use at least one of the available metrics')
  }

  if $mem_util {
    $str_mem_util = ' --mem-util'
  } else {
    $str_mem_util = ''
  }

  if $mem_used {
    $str_mem_used = ' --mem-used'
  } else {
    $str_mem_used = ''
  }

  if $mem_avail {
    $str_mem_avail = ' --mem-avail'
  } else {
    $str_mem_util = ''
  }

  if $swap_util {
    $str_swap_util = ' --swap-util'
  } else {
    $str_swap_util = ''
  }

  if $swap_used {
    $str_swap_used= ' --swap-used'
  } else {
    $str_swap_used = ''
  }

  $monitor_opts = "${str_mem_util}${str_mem_avail}${str_mem_used}${str_swap_util}${str_swap_used}"
  $monitor_command = "${awscloudwatchtools::scripts_dir}/mon-put-instance-data.pl ${monitor_opts} --from-cron ${awscloudwatchtools::aws_cli_config_file}"
  $cron_time = "*/${frequency_minutes} * * * *"

  file{ '/etc/cron.d/monitor_cloudwatch':
    content => "${cron_time} root ${monitor_command}",
    mode    => '0644',
    require => [
      Class[Awscloudwatchtools],
      Package['libwww-perl'],
      Package['libcrypt-ssleay-perl']
    ],
  }

}
