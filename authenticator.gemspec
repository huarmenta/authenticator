$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'authenticator/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'authenticator'
  s.version     = Authenticator::VERSION
  s.authors     = ['Hugo Armenta']
  s.email       = ['hugo@condovive.com']
  s.homepage    = 'https://bitbucket.org/condovive/authenticator.git'
  s.summary     = 'Condovive Authenticator'
  s.description = 'Authentication solution powered by JWT'
  s.license     = 'MIT'

  s.files = Dir[
    '{app,config,db,lib,spec}/**/*',
    'MIT-LICENSE',
    'Rakefile',
    'README.md'
  ]

  s.add_dependency 'rails', '~> 5.2.3', '>= 5.2.3'
  s.add_development_dependency 'pg', '>= 0.18', '< 2.0'

  # runtime dependencies
  s.add_dependency 'jwt', '~> 2.1'
end
