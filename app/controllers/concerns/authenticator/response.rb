# frozen_string_literal: true

module Authenticator
  # Handles request response formats and functionality
  module Response
    def json_response(object, status: :ok)
      render(json: object, status: status)
    end
  end
end
