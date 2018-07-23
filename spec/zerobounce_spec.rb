# frozen_string_literal: true

RSpec.describe Zerobounce do
  it 'has a version number' do
    expect(Zerobounce::VERSION).not_to be_nil
  end

  describe '.configure' do
    let(:apikey) { [*('a'..'z')].sample(32).join }

    it 'yields the configuration' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(Zerobounce::Configuration)
    end

    it 'sets the api key in configure block' do
      described_class.configure { |config| config.apikey = apikey }
      expect(described_class.configuration.apikey).to eq(apikey)
    end
  end

  describe '.configuration' do
    it 'returns the same configuration instance' do
      expect(described_class.configuration).to equal(described_class.configuration)
    end
  end

  describe '.validate' do
    let(:request) { instance_spy(Zerobounce::Request::V1Request) }

    before do
      allow(request).to receive(:validate)
      allow(request).to receive(:validate_with_ip)
      allow(Zerobounce::Request).to receive(:new).and_return(request)
    end

    it 'calls #validate on request' do
      described_class.validate(email: 'user@example.com')
      expect(request).to have_received(:validate).with(email: 'user@example.com')
    end
  end

  describe '.valid?' do
    let(:response) { instance_spy(Zerobounce::Response) }

    before do
      allow(response).to receive(:valid?).and_return(true)
      req = instance_double(Zerobounce::Request::V1Request)
      allow(Zerobounce::Request).to receive(:new).and_return(req)
      allow(req).to receive(:validate).and_return(response)
    end

    it 'calls #valid? on response' do
      described_class.valid?('user@example.com')
      expect(response).to have_received(:valid?)
    end
  end

  describe '.invalid?' do
    let(:response) { instance_spy(Zerobounce::Response) }

    before do
      allow(response).to receive(:invalid?).and_return(false)
      req = instance_double(Zerobounce::Request::V1Request)
      allow(Zerobounce::Request).to receive(:new).and_return(req)
      allow(req).to receive(:validate).and_return(response)
    end

    it 'calls #valid? on response' do
      described_class.invalid?('user@example.com')
      expect(response).to have_received(:invalid?)
    end
  end

  describe '.credits' do
    let(:request) { instance_spy(Zerobounce::Request) }

    before do
      allow(request).to receive(:credits)
      allow(Zerobounce::Request).to receive(:new).and_return(request)
    end

    it 'calls #credits on request' do
      described_class.credits
      expect(request).to have_received(:credits)
    end
  end
end
