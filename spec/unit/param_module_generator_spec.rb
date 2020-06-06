require 'spec_helper'

RSpec.describe Transparam::ParamModuleGenerator, with_sample_facts: true do
  let(:generator) { described_class.new(sample_facts, Pathname.new(test_app_path)) }

  describe '#call' do
    subject { generator.call }

    it 'returns generated module names' do
      expect(subject).to eq(['Concerns::StrongParameters::Foo::Bar::User'])
    end

    it 'creates the param module' do
      expect { subject }.to change {
        File.exists?("#{test_app_path}/app/controllers/concerns/strong_parameters/foo/bar/user.rb")
      }.to(true)
    end
  end
end
