# frozen_string_literal: true

RSpec.describe Zerobounce::Request do
  describe '.new' do
    context 'when middleware in params' do
      let(:middleware) { proc {} }

      it 'uses the middleware' do
        expect(described_class.new(middleware: middleware).middleware).to be(middleware)
      end
    end

    context 'when middleware not in params' do
      it 'uses Zerobounce::Configuration#middleware' do
        expect(described_class.new.middleware).to be(Zerobounce.config.middleware)
      end
    end

    context 'when headers in params' do
      let(:headers) { { user_agent: 'foobar' } }

      it 'uses the headers' do
        expect(described_class.new(headers: headers).headers).to be(headers)
      end
    end

    context 'when headers not in params' do
      it 'uses Zerobounce::Configuration#headers' do
        expect(described_class.new.headers).to be(Zerobounce.config.headers)
      end
    end

    context 'when host in params' do
      let(:host) { 'http://example.com' }

      it 'uses the host' do
        expect(described_class.new(host: host).host).to be(host)
      end
    end

    context 'when host not in params' do
      it 'uses Zerobounce::Configuration#host' do
        expect(described_class.new.host).to be(Zerobounce.config.host)
      end
    end

    context 'when ip_address in params' do
      it 'uses the validate with ip path' do
        expect(described_class.new(ip_address: '127.0.0.1').url).to be(described_class::VALIDATE_WITH_IP_PATH)
      end
    end

    context 'when ipaddress in params' do
      it 'uses the validate with ip path' do
        expect(described_class.new(ipaddress: '127.0.0.1').url).to be(described_class::VALIDATE_WITH_IP_PATH)
      end
    end

    context 'when ip address not in params' do
      it 'uses the validate path' do
        expect(described_class.new.url).to be(described_class::VALIDATE_PATH)
      end
    end
  end

  describe '#get' do
    let(:faraday_conn) { instance_spy(Faraday::Connection) }

    before do
      allow(faraday_conn).to receive(:get).and_return(spy)
      allow(Faraday).to receive(:new).and_return(faraday_conn)
    end

    it 'filters extra params' do
      described_class.new.get(foo: 'foo', bar: 'bar')
      expect(faraday_conn).to have_received(:get).with(String, apiKey: nil)
    end

    context 'when given an apiKey' do
      it 'uses it instead of Zerobounce::Configuration#api_key' do
        described_class.new.get(apiKey: 'foo')
        expect(faraday_conn).to have_received(:get).with(String, apiKey: 'foo')
      end
    end

    context 'when given ip_address' do
      it 'normalizes it to ipaddress' do
        described_class.new.get(ip_address: '127.0.0.1')
        expect(faraday_conn).to have_received(:get).with(String, apiKey: nil, ipaddress: '127.0.0.1')
      end
    end
  end
end
