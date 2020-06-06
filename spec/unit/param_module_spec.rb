require 'spec_helper'

RSpec.describe Transparam::ParamModule do
  let(:param_module) { described_class.new(fact: sample_facts.first, project_path: Pathname.new(test_app_path)) }

  describe '#source_code' do
    subject { param_module.source_code }

    it { is_expected.to eq(sample_param_module) }
  end

  describe '#module_path' do
    subject { param_module.module_path.to_s }

    it { is_expected.to eq("#{test_app_path}/app/controllers/concerns/strong_parameters/foo/bar/user.rb") }
  end

  describe '#module_name' do
    subject { param_module.module_name }

    it { is_expected.to eq('Concerns::StrongParameters::Foo::Bar::User') }
  end
end
