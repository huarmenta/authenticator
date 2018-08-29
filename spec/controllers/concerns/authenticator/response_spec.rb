# frozen_string_literal: true

require 'rails_helper'

module Authenticator
  RSpec.describe Response, type: :controller do
    controller(ApplicationController) do
      # skip_before_action :authorize_request, only: :index
      def index
        json_response(object: 'test')
      end
    end
    before { get :index }

    context 'with #json_response method' do
      it 'responds with a json' do
        expect(response.header['Content-Type']).to include('application/json')
      end

      it 'includes an object key' do
        expect(JSON.parse(response.body)).to have_key('object')
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end
end
