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

    context 'when token is valid' do
      before { allow(request).to receive(:headers).and_return(headers) }

      it 'returns user after authorization' do
        expect(controller.authenticate_for(User)).to eq(user)
      end

      it 'responds to #authenticate_user custom method' do
        expect(controller.authenticate_user).to eq(nil)
      end

      it 'gets current user method' do
        expect(controller.current_user).to eq(user)
      end
    end

    context 'when token is not passed' do
      before do
        allow(request).to receive(:headers).and_return(
          'Authorization' => nil
        )
      end

      it do
        expect { controller.authenticate_for(User) }.to raise_error(
          JWTExceptionHandler::MissingToken, /Missing token/
        )
      end
    end
  end
end
