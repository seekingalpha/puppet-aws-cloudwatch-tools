require 'spec_helper'

describe 'awscloudwatchtools' do
   let(:params) { {:access_key => 'ABC', :secret_key => '123'} }

   file_name = 'CloudWatchMonitoringScripts-1.2.1.zip'

   it do

      should contain_package('libwww-perl').with_ensure('installed')
      should contain_package('libcrypt-ssleay-perl').with_ensure('installed')
      should contain_package('unzip').with_ensure('installed')

      should contain_exec('download-aws-tools').with({
         'cwd' => '/opt',
         'creates' => "/opt/#{file_name}",
      })

     should contain_exec('extract-aws-tools').with({
         'cwd' => '/opt',
         'creates' => '/opt/aws-scripts-mon',
         'command' => "/usr/bin/unzip #{file_name}"
      })
   end

   it do
      should contain_file('/opt/aws-scripts-mon/awscreds.conf').
          with_content(/AWSAccessKeyId=ABC/).
          with_content(/AWSSecretKey=123/)
   end

   context 'with install_dir => /opt/tools' do
      let(:params) { {:access_key => 'ABC', :secret_key => '123', :install_dir => '/opt/tools'} }

      it do
         should contain_exec('download-aws-tools').with({
            'cwd' => '/opt/tools',
            'creates' => "/opt/tools/#{file_name}",
         })
      end
   end
end
