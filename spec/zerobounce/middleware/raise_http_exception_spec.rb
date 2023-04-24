# frozen_string_literal: true

RSpec.describe Zerobounce::Middleware::RaiseHttpException do
  describe '#on_complete' do
    context 'when response contains an error' do
      let(:env) { { status: 500 } }

      it 'raises an error' do
        expect { described_class.new.on_complete(env) }.to raise_error(Zerobounce::InternalServerError)
      end
    end

    context 'when response does not contain and error' do
      let(:env) { { status: 200 } }

      it 'does not return an error' do
        expect { described_class.new.on_complete(env) }.not_to raise_error
      end

      it 'returns nil' do
        expect(described_class.new.on_complete(env)).to be_nil
      end
    end
  end
end
