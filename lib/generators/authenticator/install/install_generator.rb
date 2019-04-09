# frozen_string_literal: true

module Authenticator
  class InstallGenerator < Rails::Generators::NamedBase # :nodoc:
    source_root File.expand_path('templates', __dir__)

    desc 'Creates an Authenticator initializer.'

    def copy_initializer
      template('authenticator.rb', 'config/initializers/authenticator.rb')
    end
  end
end
