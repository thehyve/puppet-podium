require 'spec_helper'
describe 'podium::complete' do
  context 'with default values for all parameters' do
    let(:node) { 'test2.example.com' }
    it { should compile.and_raise_error(/No database password specified. Please configure podium::gateway_db_password/) }
  end
  context 'with proper values set' do
    let(:node) { 'test.example.com' }
    it { is_expected.to create_class('podium::user') }
    it { is_expected.to create_class('podium::config') }
    it { is_expected.to create_class('podium::artefacts') }
    it { is_expected.to create_class('podium::database') }
    it { is_expected.to create_class('podium::services') }
  end
end
