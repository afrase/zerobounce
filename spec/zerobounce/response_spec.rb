# frozen_string_literal: true

RSpec.describe Zerobounce::Response do
  let(:response) { spy }
  let(:request) { spy }

  describe '#status' do
    before { allow(response).to receive(:body).and_return(status: 'DoNotMail') }

    it 'returns a symbol' do
      expect(described_class.new(response, request).status).to be_a(Symbol)
    end

    it 'converts camelcase to snakecase' do
      expect(described_class.new(response, request).status).to eq(:do_not_mail)
    end
  end

  describe '#sub_status' do
    before { allow(response).to receive(:body).and_return(sub_status: 'global_suppression') }

    it 'returns a symbol' do
      expect(described_class.new(response, request).sub_status).to be_a(Symbol)
    end
  end

  describe '#inspect' do
    it 'returns a string' do
      expect(described_class.new(response, request).inspect).to be_a(String)
    end
  end

  describe '#processed_at' do
    before { allow(response).to receive(:body).and_return(processedat: Time.now.to_s) }

    it 'returns a time object' do
      expect(described_class.new(response, request).processed_at).to be_a(Time)
    end
  end

  describe '#creation_date' do
    before { allow(response).to receive(:body).and_return(creationdate: Time.now.to_s) }

    it 'returns a time object' do
      expect(described_class.new(response, request).creation_date).to be_a(Time)
    end
  end

  describe '#valid?' do
    before { allow(response).to receive(:body).and_return(status: 'DoNotMail') }

    it 'can change what a valid email is' do
      expect { Zerobounce.config.valid_statuses = %i[do_not_mail] }.to(
        change { described_class.new(response, request).valid? }.from(false).to(true)
      )
    end
  end

  describe '#to_h' do
    before do
      allow(response).to receive(:body).and_return(processedat: Time.now.to_s, creationdate: Time.now.to_s)
    end

    it 'does not return request' do
      expect(described_class.new(response, request).to_h).not_to include(request: anything)
    end

    it 'does not return response' do
      expect(described_class.new(response, request).to_h).not_to include(response: anything)
    end

    it 'does not return inspect' do
      expect(described_class.new(response, request).to_h).not_to include(inspect: anything)
    end

    it 'does not return to_h' do
      expect(described_class.new(response, request).to_h).not_to include(to_h: anything)
    end

    it 'returns a hash' do
      expect(described_class.new(response, request).to_h).to be_a(Hash)
    end
  end
end
