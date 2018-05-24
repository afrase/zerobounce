# frozen_string_literal: true

RSpec.describe Zerobounce::Configuration do
  describe '.api_key' do
    before { ENV['ZEROBOUNCE_API_KEY'] = 'foobar' }

    it 'uses the environment variable "ZEROBOUNCE_API_KEY" by default' do
      expect(described_class.new.api_key).to eq('foobar')
    end
  end
end
