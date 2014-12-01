class awscloudwatchtools::packages {
  @package { [ "libwww-perl", "libcrypt-ssleay-perl", "unzip" ]:
    ensure => installed,
  }
}
