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

group :development do
  # RuboCop is a Ruby static code analyzer and code formatter.
  gem 'rubocop', require: false
  # RSpec-specific analysis for your projects, as an extension to RuboCop.
  gem 'rubocop-rspec'
end

group :development, :test do
  # rspec-rails is a testing framework for Rails 3.x, 4.x and 5.x.
  gem 'rspec-rails', '~> 3.8'
end

group :test do
  # Shoulda Matchers provides RSpec- and Minitest-compatible one-liners that 
  # test common Rails functionality. These tests would otherwise be much 
  # longer, more complex, and error-prone.
  gem 'shoulda-matchers', '~> 3.1'
  # Database Cleaner is a set of strategies for cleaning your database in Ruby.
  gem 'database_cleaner'
  # SimpleCov is a code coverage analysis tool for Ruby.
  gem 'simplecov', require: false
  # RSpec 2 & 3 results that your CI can read. Jenkins, Buildkite, CircleCI, 
  # and probably more, too.
  gem "rspec_junit_formatter"
end
