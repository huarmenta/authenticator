# frozen_string_literal: true

module Authenticator
  class ApplicationController < ActionController::API
    # protect_from_forgery with: :exception
    include Authenticator::Response
  end
end
