# frozen_string_literal: true

require 'rails_helper'

module Authenticator
  RSpec.describe Authenticable, type: :controller do
    let(:user) { auth_user }
    let(:token) { auth_token(sub: user.id) }
    let(:headers) { valid_headers(token: token) }

    controller(ApplicationController) do
      include Authenticator::Authenticable

      def index; end
    end

    context 'with valid token' do
      before { allow(request).to receive(:headers).and_return(headers) }

      describe '#authenticate_for' do
        it 'returns user after authorization' do
          expect(controller.authenticate_for(User)).to eq(user)
        end
      end

      describe '#authenticate_' do
        before { controller.authenticate_user }

        it 'sets a custom current_ method' do
          expect(controller.respond_to?(:current_user)).to eq(true)
        end

        it 'returns current authorized object' do
          expect(controller.current_user).to eq(user)
        end
      end

      describe '#current_' do
        it 'returns current authorized object' do
          expect(controller.current_user).to eq(user)
        end
      end
    end

    context 'with invalid token' do
      before do
        allow(request).to receive(:headers).and_return('Authorization' => nil)
      end

      describe '#authenticate_for' do
        it do
          expect { controller.authenticate_for(User) }.to raise_error(
            JWTExceptionHandler::MissingToken, /Missing token/
          )
        end
      end

      describe '#authenticate_' do
        it do
          expect { controller.authenticate_user }.to raise_error(
            JWTExceptionHandler::MissingToken, /Missing token/
          )
        end
      end

      describe '#current_' do
        it do
          expect { controller.current_user }.to raise_error(
            JWTExceptionHandler::MissingToken, /Missing token/
          )
        end
      end
    end
  end
end
