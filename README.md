puppet-aws-cloudwatch-tools
===========================

Installs and activates AWS CloudWatch Tools for sending system metrics to CloudWatch console

Automates these instructions from AWS CloudWatch Developer Guide: http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/mon-scripts-perl.html

Usage
=====

```puppet
# First, install the tools package:
aws-cloudwatch-tools::install { 'install-aws-tools':
    access_key  => "your-aws-access-key",
    secret_key  => "your-aws-secret-key",
    install_dir => "/opt/tools",   # Optional, default is /opt
}

# Then, you can monitor any number of disks (paths):
aws-cloudwatch-tools::monitor-disk { ['/', '/dev']: }

# You can also specify a custom frequency (default is 5 minutes):
aws-cloudwatch-tools::monitor-disk { '/mnt':
    frequency_minutes => 10,
}
```
