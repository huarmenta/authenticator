# frozen_string_literal: true

module AuthSpecHelper
  # create user for authentication
  def auth_user
    User.create
  end

  # return valid headers
  def valid_headers(token: auth_token)
    {
      'Authorization' => "Bearer #{token}",
      'Content-Type' => 'application/json'
    }
  end

  def invalid_headers
    {
      'Authorization' => nil,
      'Content-Type' => 'application/json'
    }
  end

  def auth_token(sub: nil)
    Authenticator::JsonWebToken.encode(sub: sub || auth_user.id)
  end

  def expired_auth_token
    Authenticator::JsonWebToken.encode(
      { sub: auth_user.id },
      exp: Time.zone.now - 100.days
    )
  end
end
