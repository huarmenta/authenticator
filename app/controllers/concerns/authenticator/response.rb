# frozen_string_literal: true

module Authenticator
  # Handles request response formats and functionality
  module Response
    def json_response(object: nil, status: :ok)
      render(json: { object: object }, status: status)
    end
  end
end
