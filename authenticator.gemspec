$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
# require "authenticator/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "authenticator"
  # s.version     = Authenticator::VERSION
  s.version     = '0.1.0'
  s.authors     = ["Hugo Armenta"]
  s.email       = ["hugo@condovive.com"]
  s.homepage    = "https://bitbucket.org/condovive/authenticator.git"
  s.summary     = "Condovive Authenticator"
  s.description = "Authentication solution powered by JWT"
  s.license     = "MIT"

  s.files = Dir[
    "{app,config,db,lib}/**/*",
    "spec/factories/**/*",
    "spec/support/helpers/spec_helper.rb",
    "MIT-LICENSE",
    "Rakefile",
    "README.md"
  ]

  s.add_dependency "rails", "~> 5.2.0"

  # app dependencies
  s.add_development_dependency "pg"
  s.add_dependency 'jwt'

  # development/test dependencies
  s.add_development_dependency 'rspec-rails', '~> 3.7'
  s.add_development_dependency 'rubocop', '~> 0.55.0'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'shoulda-matchers', '~> 3.1'
  s.add_development_dependency 'database_cleaner'
  # s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rspec_junit_formatter'
end
