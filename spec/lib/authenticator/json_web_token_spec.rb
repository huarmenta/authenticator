# frozen_string_literal: true

require 'rails_helper'

module Authenticator
  RSpec.describe JsonWebToken do
    let(:token) { auth_token }
    let(:decoded_token) { described_class.decode(token) }

    context 'when #encode is called' do
      let(:test_token) { described_class.encode(decoded_token) }

      it 'return encoded token' do
        expect(token).to eq(test_token)
      end
    end

    context 'when #decode is called' do
      context 'when token is valid' do
        it 'returns decoded token hash with sub key' do
          expect(decoded_token).to have_key(:sub)
        end

        it 'returns decoded token hash with expiry time key' do
          expect(decoded_token).to have_key(:exp)
        end
      end

      context 'when token is expired' do
        it do
          expect { described_class.decode(expired_auth_token) }.to raise_error(
            JWTExceptionHandler::ExpiredSignature, /Signature has expired/
          )
        end
      end
    end
  end
end
