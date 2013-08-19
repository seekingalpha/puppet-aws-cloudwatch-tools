class aws-cloudwatch-tools::packages {
  @package { [ "libwww-perl", "libcrypt-ssleay-perl" ]:
    ensure => installed,
  }
}
