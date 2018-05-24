# frozen_string_literal: true

RSpec.describe Zerobounce::Error do
  describe '.from_response' do
    context 'when status is 500' do
      let(:env) { { status: 500 } }

      it 'returns InternalServerError error' do
        expect(described_class.from_response(env)).to be_a(Zerobounce::InternalServerError)
      end

      context 'when body starts with Missing parameter' do
        before { env[:body] = 'Missing parameter' }

        it 'returns MissingParameter error' do
          expect(described_class.from_response(env)).to be_a(Zerobounce::MissingParameter)
        end
      end
    end

    context 'when status is 200' do
      let(:env) { { status: 200 } }

      it 'returns nil' do
        expect(described_class.from_response(env)).to be_nil
      end

      context 'when body looks like an error' do
        before { env[:body] = '{"error":"Invalid API Key or your account ran out of credits"}' }

        it 'returns ApiError' do
          expect(described_class.from_response(env)).to be_a(Zerobounce::ApiError)
        end
      end
    end
  end

  describe '#message' do
    context 'when status is 500' do
      let(:env) { { status: 500, body: 'error' } }

      it 'uses the body for the message' do
        expect(described_class.from_response(env).message).to eq('error')
      end
    end

    context 'when body looks like an error' do
      let(:error_message) { 'Invalid API Key or your account ran out of credits' }
      let(:env) { { status: 200, body: JSON.dump(error: error_message) } }

      it 'parses the json to get error message' do
        expect(described_class.from_response(env).message).to eq(error_message)
      end
    end
  end
end
