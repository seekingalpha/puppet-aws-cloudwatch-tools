class aws-cloudwatch-tools::monitor(
  $frequency_minutes = 5,
  $mem_util = false,
  $mem_used = false,
  $mem_avail = false,
  $swap_util = false,
  $swap_used = false,
  $install_dir = '/opt'
) {

  $scripts_dir = "${install_dir}/aws-scripts-mon"

  $bool_mem_util = any2bool($mem_util)
  $bool_mem_used = any2bool($mem_used)
  $bool_mem_avail = any2bool($mem_avail)
  $bool_swap_util = any2bool($swap_util)
  $bool_swap_used = any2bool($swap_used)

  if !$bool_swap_used and !$bool_swap_util and !$bool_mem_avail and !$bool_mem_used and !$bool_mem_util
   {
     fail ("You have to use at least one of the available metrics")
   }

   if $bool_mem_util {
     $str_mem_util = ' --mem-util'
   } else {
     $str_mem_util = ''
   }

   if $bool_mem_used {
     $str_mem_used = ' --mem-used'
   } else {
     $str_mem_used = ''
   }

   if $bool_mem_avail {
     $str_mem_avail = ' --mem-avail'
   } else {
     $str_mem_util = ''
   }

   if $bool_swap_util {
     $str_swap_util = ' --swap_util'
   } else {
     $str_swap_util = ''
   }

   if $bool_swap_used {
     $str_swap_used= ' --swap-used'
   } else {
     $str_swap_used = ''
   }

   $string = "${str_mem_util}${str_mem_avail}${str_mem_used}${str_swap_util}${str_swap_used} --from-cron --aws-credential-file=${scripts_dir}/awscreds.conf"

  cron { "monitor_cloudwatch":
    command => "${scripts_dir}/mon-put-instance-data.pl ${str_mem_util}${str_mem_avail}${str_mem_used}${str_swap_util}${str_swap_used} --from-cron --aws-credential-file=${scripts_dir}/awscreds.conf",
    minute  => "*/$frequency_minutes",
    require => [Class[Aws-cloudwatch-tools::Install], Package["libwww-perl"], Package["libcrypt-ssleay-perl"]]
  }

}
