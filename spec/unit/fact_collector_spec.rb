require 'spec_helper'

RSpec.describe Transparam::FactCollector do
  let(:collector) { described_class.new(project_path: test_app_path) }

  describe '#call' do
    subject { collector.call }

    it 'returns the facts', with_sample_facts: true do
      expect(subject).to eq(sample_facts)
      expect(collector).to have_received(:`).with(/bundle exec rails runner/)
    end
  end
end
