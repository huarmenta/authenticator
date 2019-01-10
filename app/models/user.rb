# frozen_string_literal: true

# User model for gem testing (no functional value)
class User < ApplicationRecord
  # Avoids main application conflict with User models
  self.table_name = 'authenticator_users'
end
