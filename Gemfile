source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in authenticator.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
gem 'byebug', group: [:development, :test]

group :development, :test do
  # rspec-rails brings the RSpec testing framework to Ruby on Rails as a
  # drop-in alternative to its default testing framework, Minitest.
  gem 'rspec-rails', '~> 3.8'
  # factory_bot is a fixtures replacement with a straightforward definition
  # syntax, support for multiple build strategies (saved instances, unsaved
  # instances, attribute hashes, and stubbed objects), and support for
  # multiple factories for the same class (user, admin_user, and so on),
  # including factory inheritance.
  gem 'factory_bot_rails'
  # This gem is a port of Perl's Data::Faker library that generates fake data.
  gem 'faker', git: 'https://github.com/stympy/faker.git', branch: 'master'
end

group :development do
  # RuboCop is a Ruby static code analyzer and code formatter.
  gem 'rubocop', require: false
  # RSpec-specific analysis, as an extension to RuboCop.
  gem 'rubocop-rspec'
  # Performance optimization analysis, as an extension to RuboCop.
  gem 'rubocop-performance'
end

group :test do
  # Fuubar is an instafailing RSpec formatter that uses a progress bar instead
  # of a string of letters and dots as feedback.
  gem 'fuubar'
  # Shoulda Matchers provides RSpec- and Minitest-compatible one-liners that
  # test common Rails functionality.
  gem 'shoulda-matchers'
  # SimpleCov is a code coverage analysis tool for Ruby.
  gem 'simplecov', require: false
  # RSpec 2 & 3 results that your CI can read. Jenkins, Buildkite, CircleCI,
  # and probably more, too.
  gem 'rspec_junit_formatter'
end
