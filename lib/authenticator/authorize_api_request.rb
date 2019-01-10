# frozen_string_literal: true

module Authenticator
  # Decodes token from authenticator headers & returns a user object.
  class AuthorizeApiRequest
    # :nocov:
    def self.call(*args)
      new(*args).call
    end
    # :nocov:

    def call
      entity # valid user object
    end

    private

    attr_reader :token
    attr_reader :entity_class

    def initialize(token: nil, entity_class:)
      @token = token
      @entity_class = entity_class
    end

    # An entity is the authenticable object model
    # For example:
    #   User model or Admin model
    def entity
      @entity ||= entity_class.find(decoded_auth_token['sub'])
    rescue ActiveRecord::RecordNotFound => e
      raise(JWTExceptionHandler::InvalidToken, ("Invalid token #{e.message}"))
    end

    def decoded_auth_token
      raise(JWTExceptionHandler::MissingToken, 'Missing token') if token.blank?

      @decoded_auth_token ||= JsonWebToken.decode(token)
    end
  end
end
