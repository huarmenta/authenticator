# frozen_string_literal: true

require 'rails_helper'

module Authenticator
  RSpec.describe AuthorizeApiRequest do
    # Authentication user
    let(:user) { auth_user }
    let(:token) { auth_token(sub: user.id) }

    # Test Suite for AuthorizeApiRequest#call
    describe '#call' do
      # returns user object when request is valid
      context 'when valid request' do
        let(:request_object) do
          described_class.call(token: token, entity_class: User)
        end

        it 'returns authorized object' do
          expect(request_object).to eq(user)
        end
      end

      # returns error message when invalid request
      context 'when invalid request' do
        context 'when missing token' do
          let(:invalid_request_object) do
            described_class.call(entity_class: User)
          end

          it do
            expect { invalid_request_object }.to raise_error(
              JWTExceptionHandler::MissingToken, /Missing token/
            )
          end
        end

        context 'when token is invalid' do
          let(:invalid_request_object) do
            described_class.call(
              token: auth_token(sub: 1000), entity_class: User
            )
          end

          it do
            expect { invalid_request_object }.to raise_error(
              JWTExceptionHandler::InvalidToken, /Invalid token/
            )
          end
        end

        context 'when token is expired' do
          let(:expired_request) do
            described_class.call(token: expired_auth_token, entity_class: User)
          end

          it do
            expect { expired_request }.to raise_error(
              JWTExceptionHandler::ExpiredSignature, /Signature has expired/
            )
          end
        end
      end
    end
  end
end
