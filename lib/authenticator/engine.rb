# frozen_string_literal: true

module Authenticator
  class Engine < ::Rails::Engine
    isolate_namespace Authenticator

    config.generators.api_only = true
    config.generators.test_framework(:rspec, fixtures: false)
  end
end
