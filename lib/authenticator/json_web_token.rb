# frozen_string_literal: true

require 'jwt'

module Authenticator
  # Wraps JWT to provide token encoding and decoding methods for user auth.
  class JsonWebToken
    # Generates a token based on a payload (id) and an expiration period.
    def self.encode(payload, exp: Authenticator.token_lifetime)
      # set expiry time from now
      payload[:exp] = exp.to_i
      # sign token with application secret
      JWT.encode(
        payload,
        Authenticator.token_secret_signature_key.call,
        Authenticator.token_signature_algorithm
      )
    end

    # Decodes JWT token and returns a hash
    def self.decode(token)
      # get payload; first index in decoded Array
      body = JWT.decode(
        token,
        Authenticator.token_secret_signature_key.call,
        true,
        algorithm: Authenticator.token_signature_algorithm
      ).first
      HashWithIndifferentAccess.new(body)
    rescue JWT::ExpiredSignature, JWT::VerificationError => e
      raise(JWTExceptionHandler::ExpiredSignature, e.message)
    end
  end
end
