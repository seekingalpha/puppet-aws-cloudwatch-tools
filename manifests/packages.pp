class awscloudwatchtools::packages {
  @package { [ 'libdatetime-perl', 'libswitch-perl', 'libwww-perl', 'libcrypt-ssleay-perl' ]:
    ensure => installed,
  }
}
