# frozen_string_literal: true

RSpec.describe Zerobounce::Response do
  let(:response) { spy }

  describe '#status' do
    before do
      allow(response).to receive(:body).and_return(status: 'DoNotMail')
    end

    it 'returns a symbol' do
      expect(described_class.new(response, nil).status).to be_a(Symbol)
    end

    it 'converts camelcase to snakecase' do
      expect(described_class.new(response, nil).status).to eq(:do_not_mail)
    end
  end

  describe '#sub_status' do
    before do
      allow(response).to receive(:body).and_return(sub_status: 'global_suppression')
    end

    it 'returns a symbol' do
      expect(described_class.new(response, nil).sub_status).to be_a(Symbol)
    end
  end

  describe '#inspect' do
    it 'returns a string' do
      expect(described_class.new(response, nil).inspect).to be_a(String)
    end
  end

  describe '#process_date' do
    before do
      allow(response).to receive(:body).and_return(processedat: Time.now.to_s)
    end

    it 'returns a time object' do
      expect(described_class.new(response, nil).process_date).to be_a(Time)
    end
  end

  describe '#creation_date' do
    before do
      allow(response).to receive(:body).and_return(creationdate: Time.now.to_s)
    end

    it 'returns a time object' do
      expect(described_class.new(response, nil).creation_date).to be_a(Time)
    end
  end

  describe '#to_h' do
    before do
      allow(response).to receive(:body).and_return(processedat: Time.now.to_s, creationdate: Time.now.to_s)
    end

    it 'does not return request' do
      expect(described_class.new(response, nil).to_h).not_to include(request: anything)
    end

    it 'does not return response' do
      expect(described_class.new(response, nil).to_h).not_to include(response: anything)
    end

    it 'does not return inspect' do
      expect(described_class.new(response, nil).to_h).not_to include(inspect: anything)
    end

    it 'does not return to_h' do
      expect(described_class.new(response, nil).to_h).not_to include(to_h: anything)
    end

    it 'returns a hash' do
      expect(described_class.new(response, nil).to_h).to be_a(Hash)
    end
  end
end
