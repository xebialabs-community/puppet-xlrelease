require 'spec_helper'

describe 'xlrelease' do
  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      describe "xlrelease class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('xlrelease::params') }

        it { should contain_class('xlrelease::install').that_comes_before('xlrelease::config') }
        it { should contain_class('xlrelease::config') }
        it { should contain_class('xlrelease::service').that_subscribes_to('xlrelease::config') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'xlrelease class without any parameters on Solaris' do
      let(:facts) {{
        :osfamily => 'Solaris'
      }}

      it { expect { should }.to raise_error(Puppet::Error, /Solaris not supported/) }
    end
  end
end
