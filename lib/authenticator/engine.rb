# frozen_string_literal: true

module Authenticator
  class Engine < ::Rails::Engine # :nodoc:
    isolate_namespace Authenticator

    config.eager_load_paths << File.expand_path(
      root.join('spec', 'support', 'helpers')
    )

    config.generators.api_only = true
    config.generators.test_framework(:rspec, fixtures: false)
  end
end
