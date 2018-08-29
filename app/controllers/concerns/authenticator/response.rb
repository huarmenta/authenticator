# frozen_string_literal: true

module Authenticator
  # Handles request response formats and functionality
  module Response
    # responds with JSON and an HTTP status code (200 by default)
    def json_response(object, status: :ok)
      render(json: object, status: status)
    end
  end
end
