# frozen_string_literal: true

require 'rails_helper'

module Authenticator
  RSpec.describe AuthorizeApiRequest do
    # Authentication user
    let(:user) { auth_user }

    # Test Suite for AuthorizeApiRequest#call
    # This is our entry point into the service class
    describe '#call' do
      # returns user object when request is valid
      context 'when valid request' do
        let(:request_obj) do
          described_class.new(
            token: auth_token(sub: user.id), entity_class: User
          )
        end

        it 'returns user object' do
          expect(request_obj.call).to eq(user)
        end
      end

      # returns error message when invalid request
      context 'when invalid request' do
        context 'when missing token' do
          let(:invalid_request_obj) { described_class.new(entity_class: User) }

          it 'raises a MissingToken error' do
            expect { invalid_request_obj.call }.to raise_error(
              JWTExceptionHandler::MissingToken, /Missing token/
            )
          end
        end

        context 'when token is invalid' do
          let(:invalid_request_obj) do
            described_class.new(
              token: auth_token(sub: 666), entity_class: User
            )
          end

          it 'raises an InvalidToken error' do
            expect { invalid_request_obj.call }.to raise_error(
              JWTExceptionHandler::InvalidToken, /Invalid token/
            )
          end
        end

        context 'when token is expired' do
          let(:expired_token) do
            Authenticator::JsonWebToken.encode(
              { sub: user.id }, exp: (Time.now.to_i - 10)
            )
          end
          let(:request_obj) do
            described_class.new(token: expired_token, entity_class: User)
          end

          it 'raises JWTExceptionHandler::ExpiredSignature error' do
            expect { request_obj.call }.to raise_error(
              JWTExceptionHandler::ExpiredSignature,
              /Signature has expired/
            )
          end
        end
      end
    end
  end
end
