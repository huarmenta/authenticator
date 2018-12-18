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
  # Countries is a collection of all sorts of useful information for every country in the ISO 3166 standard. It contains info for the following standards ISO3166-1 (countries), ISO3166-2 (states/subdivisions), ISO4217 (currency) and E.164 (phone numbers).
  # RuboCop is a Ruby static code analyzer and code formatter.
  gem 'rubocop', require: false
  # RSpec-specific analysis for your projects, as an extension to RuboCop.
  gem 'rubocop-rspec'
end

group :development, :test do
  # This gem is a port of Perl's Data::Faker library that generates fake data.
  gem 'faker', git: 'https://github.com/stympy/faker.git', branch: 'master'
end

group :test do
  # SimpleCov is a code coverage analysis tool for Ruby.
  gem 'simplecov', require: false
end
