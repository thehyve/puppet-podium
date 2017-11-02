require 'spec_helper'
describe 'podium' do
  on_supported_os.each do |os, facts|
    context "with default values for all parameters on #{os}" do
      let(:facts) { facts }
      let(:node) { 'test2.example.com' }
      it { should compile.and_raise_error(/No database password specified. Please configure podium::gateway_db_password/) }
    end
    context "with proper values set on #{os}" do
      let(:facts) { facts }
      let(:node) { 'test.example.com' }
      it { is_expected.to create_class('podium') }
    end
  end
end
