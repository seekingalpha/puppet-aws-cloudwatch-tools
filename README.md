puppet-aws-cloudwatch-tools
===========================

Installs and activates AWS CloudWatch Tools for sending system metrics to CloudWatch console

Automates these instructions from AWS CloudWatch Developer Guide: http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/mon-scripts-perl.html

Usage
=====

```puppet
# First, install the tools package:
class { 'awscloudwatchtools::install':
    access_key  => "your-aws-access-key",
    secret_key  => "your-aws-secret-key"
}

# Then, you can monitor any number of disks (paths):
awscloudwatchtools::monitor-disk { ['/', '/dev']: }

# You can also specify a custom frequency (default is 5 minutes):
awscloudwatchtools::monitor-disk { '/mnt':
    frequency_minutes => 10,
}
```
