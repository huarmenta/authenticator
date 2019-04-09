#!/bin/sh

# This script was verified with https://www.shellcheck.net/
# 
# Deploy gem to private gemstash server

set -e

# Add push key to gem credentials
mkdir -p ~/.gem
echo ":gemstash: $GEMSTASH_PUSH_KEY" >> ~/.gem/credentials
chmod 0600 ~/.gem/credentials

# Build & Deploy to gemstash server
gem build "$COMPOSE_PROJECT_NAME.gemspec"
gem push --key gemstash --host "$GEMSTASH_URL/private" \
  `find ./ -name "*.gem" | sort | tail -1` # last built gem file

exec "$@"
