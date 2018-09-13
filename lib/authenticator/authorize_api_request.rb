# frozen_string_literal: true

module Authenticator
  # The AuthorizeApiRequest service gets the token from the authorization
  # headers and attempts to decode it to return a valid user object
  class AuthorizeApiRequest
    # :nocov:
    def self.call(*args)
      new(*args).call
    end
    # :nocov:

    # Service entry point - return valid user object
    def call
      entity
    end

    private

    attr_reader :token
    attr_reader :entity_class

    def initialize(token: nil, entity_class:)
      @token = token
      @entity_class = entity_class
    end

    def entity
      # check if entity is in the database and memoize entity object
      @entity ||= entity_class.find(decoded_auth_token['sub'])
    # handle entity record not found
    rescue ActiveRecord::RecordNotFound => e
      raise(JWTExceptionHandler::InvalidToken, ("Invalid token #{e.message}"))
    end

    # decode authentication token
    def decoded_auth_token
      raise(JWTExceptionHandler::MissingToken, 'Missing token') if token.blank?

      @decoded_auth_token ||= JsonWebToken.decode(token)
    end
  end
end
