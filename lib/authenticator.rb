# frozen_string_literal: true

require 'authenticator/engine'
require 'authenticator/authenticable'
require 'authenticator/json_web_token'
require 'authenticator/authorize_api_request'
require 'authenticator/jwt_exception_handler'

module Authenticator # :nodoc:
  mattr_accessor :token_lifetime
  self.token_lifetime = 7.days

  mattr_accessor :token_signature_algorithm
  self.token_signature_algorithm = 'HS256'

  mattr_accessor :token_secret_signature_key
  self.token_secret_signature_key = lambda do
    ENV['JWT_SECRET_KEY'] || Rails.application.credentials.secret_key_base ||
      ''
  end

  # Default way to setup authenticator.
  # Run `rails generate authenticator:install` to create a fresh initializer
  # with all configuration values.
  # :nocov:
  def self.setup
    yield self
  end
  # :nocov:
end
