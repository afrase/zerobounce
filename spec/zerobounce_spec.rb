# frozen_string_literal: true

RSpec.describe Zerobounce do
  it 'has a version number' do
    expect(Zerobounce::VERSION).not_to be_nil
  end

  describe '.configure' do
    let(:api_key) { [*('a'..'z')].sample(32).join }

    it 'yields the configuration' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(Zerobounce::Configuration)
    end

    it 'sets the api key in configure block' do
      described_class.configure { |config| config.api_key = api_key }
      expect(described_class.configuration.api_key).to eq(api_key)
    end
  end

  describe '.configuration' do
    it 'returns the same configuration instance' do
      expect(described_class.configuration).to equal(described_class.configuration)
    end
  end

  describe '.validate' do
    before do
      described_class.config.middleware = proc do |f|
        f.adapter(:test) do |stub|
          stub.get('/v1/validate') { |_| [200, {}, ''] }
        end
      end
    end

    it 'returns a response' do
      expect(described_class.validate(email: 'user@example.com')).to be_a(Zerobounce::Response)
    end
  end
end
