# frozen_string_literal: true

module JWTExceptionHandler
  # Define custom error subclasses - rescue catches `StandardError`
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ExpiredSignature < StandardError; end
end
