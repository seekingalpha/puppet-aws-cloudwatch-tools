require 'spec_helper'

describe 'awscloudwatchtools::monitordisk' do
   let(:title) { '/mnt' }

   it do
      should contain_cron('monitor_/mnt').with({
         'minute' => '*/5',
         'command' => "/opt/aws-scripts-mon/mon-put-instance-data.pl --disk-space-util --disk-path=/mnt --from-cron ",
      })
   end

   context 'with frequency_minutes => 10' do
      let(:params) { { :frequency_minutes => 10} }

      it do
         should contain_cron('monitor_/mnt').with({
            'minute' => '*/10',
         })
      end
   end
end
