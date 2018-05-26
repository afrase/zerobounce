# frozen_string_literal: true

RSpec.describe Zerobounce::Configuration do
  it 'has correct attributes' do
    expect(described_class.new).to have_attributes(
      api_key: be_nil, host: be_a(String), headers: be_a(Hash), middleware: be_a(Proc), valid_statuses: be_an(Array)
    )
  end

  describe '#api_key', mock_env: true do
    before { ENV['ZEROBOUNCE_API_KEY'] = 'foobar' }

    it 'uses the environment variable "ZEROBOUNCE_API_KEY" by default' do
      expect(described_class.new.api_key).to eq('foobar')
    end
  end

  describe '#middleware' do
    let(:builder) { spy }

    before do
      allow(builder).to receive(:response)
      allow(builder).to receive(:use)
      allow(builder).to receive(:adapter)
    end

    it 'uses json parser for response middleware' do
      described_class.new.middleware.call(builder)
      expect(builder).to have_received(:response).with(:json, Hash)
    end

    it 'uses the RaiseError class' do
      described_class.new.middleware.call(builder)
      expect(builder).to have_received(:use).with(Zerobounce::Middleware::RaiseError)
    end

    it 'uses Faraday default adapter' do
      described_class.new.middleware.call(builder)
      expect(builder).to have_received(:adapter).with(Faraday.default_adapter)
    end
  end
end
