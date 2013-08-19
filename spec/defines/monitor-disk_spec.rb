require 'spec_helper'

describe 'aws-cloudwatch-tools::monitor-disk' do
   let(:title) { '/mnt' }

   it do
      should contain_cron('monitor /mnt').with({
         'minute' => '*/5',
         'command' => "/opt/aws-scripts-mon/mon-put-instance-data.pl --disk-space-util --disk-path=/mnt --from-cron --aws-credential-file=/opt/aws-scripts-mon/awscreds.conf",
      })

      should contain_package('libwww-perl').with_ensure('installed')
      should contain_package('libcrypt-ssleay-perl').with_ensure('installed')
   end

   context 'with frequency_minutes => 10' do
      let(:params) { { :frequency_minutes => 10} }

      it do
         should contain_cron('monitor /mnt').with({
            'minute' => '*/10',
         })
      end
   end

   context 'with install_dir => /opt/tools' do
      let(:params) { { :install_dir => '/opt/tools'} }

      it do
         should contain_cron('monitor /mnt').with({
            'command' => "/opt/tools/aws-scripts-mon/mon-put-instance-data.pl --disk-space-util --disk-path=/mnt --from-cron --aws-credential-file=/opt/tools/aws-scripts-mon/awscreds.conf",
         })
      end
   end

end
