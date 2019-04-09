# frozen_string_literal: true

require 'rails_helper'

module Authenticator
  RSpec.describe Response, type: :controller do
    controller(ApplicationController) do
      # skip_before_action :authenticate_user

      def index
        json_response(object: 'test')
      end
    end

    context 'with #json_response' do
      before { get :index }

      it "responds with a 'Content-Type' => 'application/json' header" do
        expect(
          response.get_header('Content-Type')
        ).to include('application/json')
      end

      it "responds with an 'object'" do
        expect(JSON.parse(response.body)).to eq('object' => 'test')
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end
end
