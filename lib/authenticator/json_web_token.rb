# frozen_string_literal: true

require 'jwt'

module Authenticator
  # Wraps JWT to provide token encoding and decoding methods for user auth.
  class JsonWebToken
    # The encode method will be responsible for creating tokens based on a
    # payload (user id) and expiration period
    def self.encode(payload, exp: Authenticator.token_lifetime.from_now)
      # set expiry time from now
      payload[:exp] = exp.to_i
      # sign token with application secret
      JWT.encode(
        payload,
        Authenticator.token_secret_signature_key.call,
        Authenticator.token_signature_algorithm
      )
    end

    # The decode method accepts a token and attempts to decode it using the
    # secret key used to sign tokens.
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
      # rescue from expiry exception
      raise(JWTExceptionHandler::ExpiredSignature, e.message)
    end
  end
end
