require 'spec_helper'
describe 'podium' do
  context 'with default values for all parameters' do
    let(:node) { 'test2.example.com' }
    it { should compile.and_raise_error(/No database password specified. Please configure podium::gateway_db_password/) }
  end
  context 'with proper values set' do
    let(:node) { 'test.example.com' }
    it { is_expected.to create_class('podium') }
  end
end
