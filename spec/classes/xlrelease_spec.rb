require 'spec_helper'

describe 'xlrelease' do

  shared_examples 'a Linux Os' do

    context 'basic usage' do

      describe "xlrelease class without any parameters" do

        let(:params) {{ }}

        it { should contain_class('xlrelease::params') }
        it { should contain_class('xlrelease::install') }
        it { should contain_class('xlrelease::config') }
        it { should contain_class('xlrelease::postconfig') }
        it { should contain_class('xlrelease::service') }

        #install.pp related
        it { should contain_user('xl-release').with_ensure('present').with_gid('xl-release').with_managehome('false').with_home('/opt/xl-release/xl-release-server')}
        it { should contain_group('xl-release')}
        it { should contain_file('/opt/xl-release').with_ensure('directory').with_owner('xl-release').with_group('xl-release')}
        it { should contain_xlrelease_netinstall('https://dist.xebialabs.com/customer/xl-release/4.5.1/xl-release-4.5.1-server.zip').with_owner('xl-release').with_group('xl-release').with_user(nil).with_password(nil).with_destinationdir('/opt/xl-release')}
        it { should contain_file('xlr log dir link').with_ensure('link').with_path('/var/log/xl-release').with_target('/opt/xl-release/xl-release-4.5.1-server/log')}
        it { should contain_file('xlr conf dir link').with_ensure('link').with_path('/etc/xl-release').with_target('/opt/xl-release/xl-release-4.5.1-server/conf')}
        it { should contain_file('/etc/init.d/xl-release').with_owner('root').with_group('root').with_mode('0700')}
        it { should contain_file('/opt/xl-release').with_ensure('directory').with_group('xl-release').with_owner('xl-release')}
        it { should contain_file('/opt/xl-release/xl-release-server').with_ensure('link').with_group('xl-release').with_owner('xl-release').with_target('/opt/xl-release/xl-release-4.5.1-server')}
        it { should contain_file('/opt/xl-release/xl-release-server/scripts').with_ensure('directory').with_group('xl-release').with_owner('xl-release')}

        #config.pp related
        it { should contain_file('/opt/xl-release/xl-release-server/conf/xl-release-server.conf').with_owner('xl-release').with_group('xl-release').with_mode('0640').with_ignore('.gitkeep').with_ensure('present')}
        it { should contain_ini_setting('xlrelease.admin.password').with_setting('admin.password').with_value('xebialabs').with_ensure('present').with_section('')}
        it { should contain_ini_setting('xlrelease.http.port').with_setting('http.port').with_value('5516').with_ensure('present').with_section('')}
        it { should contain_ini_setting('xlrelease.jcr.repository.path').with_setting('jcr.repository.path').with_value('repository').with_ensure('present').with_section('')}
        it { should contain_ini_setting('xlrelease.ssl').with_setting('ssl').with_value('false').with_ensure('present').with_section('')}
        it { should contain_ini_setting('xlrelease.http.bind.address').with_setting('http.bind.address').with_value('0.0.0.0').with_ensure('present').with_section('')}
        it { should contain_ini_setting('xlrelease.http.context.root').with_setting('http.context.root').with_value('/').with_ensure('present').with_section('')}
        it { should contain_ini_setting('xlrelease.importable.packages.path').with_setting('importable.packages.path').with_value('importablePackages').with_ensure('present').with_section('')}
        it { should contain_exec('init xl-release').with_creates('/opt/xl-release/xl-release-server/repository').with_command('/opt/xl-release/xl-release-server/bin/server.sh -setup -reinitialize -force -setup-defaults /opt/xl-release/xl-release-server/conf/xl-release-server.conf')}

        #postconfig.pp related stuff

        #service.pp related
        it { should contain_service('xl-release').with_ensure('running').with_enable(true).with_hasstatus(true).with_hasrestart(true)}
        it { should contain_xlrelease_check_connection('default').with_port('5516')}

      end

      describe 'with installation type set to puppetfiles and puppetfiles_xlrelease_source specified ' do

        let(:params) {{ :install_type => 'puppetfiles',
                        :puppetfiles_xlrelease_source => 'puppet:///modules/xlrelease'
                      }}

        it { should contain_file('/var/tmp/xl-release-4.5.1-server.zip').with_source('puppet:///modules/xlrelease/xl-release-4.5.1-server.zip')}
        it { should contain_file('/opt/xl-release/xl-release-4.5.1-server').with_ensure('directory').with_owner('xl-release').with_group('xl-release')}
        it { should contain_exec('xlr unpack server file').with_command('/usr/bin/unzip /var/tmp/xl-release-4.5.1-server.zip;/bin/cp -rp /var/tmp/xl-release-4.5.1-server/* /opt/xl-release/xl-release-4.5.1-server')}

      end
    end
  end

  context "Debian OS" do
    let :facts do
      {
          :operatingsystem => 'Debian',
          :osfamily        => 'Debian',
          :lsbdistcodename => 'precise',
          :lsbdistid       => 'Debian',
          :concat_basedir  => '/var/tmp'
      }
    end
    it_behaves_like "a Linux Os" do

    end
    context "with install_java set to true" do

      let(:params) {{ :install_java => 'true' }}

      it { should contain_package('openjdk-7-jdk').with_ensure('present')}
    end
  end

  context "RedHat OS" do
    let :facts do
      {
          :operatingsystem => 'RedHat',
          :osfamily        => 'RedHat',
          :concat_basedir  => '/var/tmp'
      }
    end
    it_behaves_like "a Linux Os" do

    end

    context "with install_java set to true" do

      let(:params) {{ :install_java => 'true' }}

      it { should contain_package('java-1.7.0-openjdk').with_ensure('present')}
    end

  end



end
