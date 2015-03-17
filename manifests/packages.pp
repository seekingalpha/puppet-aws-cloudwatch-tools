class awscloudwatchtools::packages {
  @package { [ "libwww-perl", "libcrypt-ssleay-perl", "unzip" ]:
    ensure => installed,
  }
  case $::operatingsystem {
    ubuntu : {
      case $::lsbdistcodename {
        trusty : {
          package { [ 'libdatetime-perl', 'libswitch-perl' ]:
            ensure => installed,
          }
        }
      }
    }
  }
}
