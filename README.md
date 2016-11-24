puppet-aws-cloudwatch-tools
===========================

Installs and activates AWS CloudWatch Tools for sending system metrics to CloudWatch console

Automates these instructions from AWS CloudWatch Developer Guide: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html

Usage
=====

```puppet
# First, install the tools package:
class { 'awscloudwatchtools': }

# You can also specify AWS credentials:
class { 'awscloudwatchtools':
    access_key  => "your-aws-access-key",
    secret_key  => "your-aws-secret-key",
}

# Or a specific version of the script package (defaults to: 1.2.1)
class { 'awscloudwatchtools':
    cw_mon_script_version => '1.0.1',
}

# Then, you can monitor any number of disks (paths):
class { 'awscloudwatchtools':
    monitor_disks => {
        'root_fs': {
            'disk_path': '/'
        },
        'another_disk': {
            'disk_path': '/data'
            # Default is 5 minutes
            'frequency_minutes': 10,
        }
    },
}

# Monitor memory and swap:
class { 'awscloudwatchtools::monitor':
  frequency_minutes => 5,
  mem_util => true,
  mem_used => false,
  mem_avail => true,
  swap_util => true,
  swap_used => true,
}

# Hiera:
awscloudwatchtools::monitor::mem_use: true
awscloudwatchtools::monitor::mem_avail: true
awscloudwatchtools::monitor::swap_util: true
awscloudwatchtools::monitor::swap_used: true
awscloudwatchtools::monitor_disks:
    'root_fs':
        disk_path: '/'
```
