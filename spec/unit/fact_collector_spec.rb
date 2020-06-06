require 'spec_helper'

RSpec.describe Transparam::FactCollector, with_sample_facts: true do
  let(:collector) { described_class.new(project_path: test_app_path) }

  describe '#call' do
    subject { collector.call }

    it 'returns the facts' do
      expect(subject).to eq(sample_facts)
    end

    it 'shells out to to execute the colleector' do
      subject
      expect(collector).to have_received(:`).with(/bundle exec rails runner/)
    end
  end
end
