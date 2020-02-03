require 'spec_helper'

RSpec.describe Transparam::FactCollector::Helper do
  let(:options) { { project_path: test_app_path, output_path: 'bar' } }

  before do
    allow(File).to receive(:file?)
    allow(File).to receive(:write)
  end

  def expect_result(result)
    expect(File).to have_received(:write).with('bar', result.to_json)
  end

  def allow_model_path(model_path)
    allow(File).to receive(:file?).with(Pathname.new("#{test_app_path}/app/models").join(model_path)).and_return(true)
  end

  context 'with User class' do
    before do
      allow_model_path('user.rb')
      described_class.call(options)
    end

    it 'has the expected result' do
      expect_result([{ 'klass_name' => 'User', 'permitted_params' => ['email', { 'phone_numbers_attributes' => { 'extra_attrs' => ['_destroy'], 'klass_name' => 'PhoneNumber' } }] }])
    end
  end
end
