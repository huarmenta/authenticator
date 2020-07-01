#!/bin/sh

# This script was verified with https://www.shellcheck.net/

# The Docker App Container's entrypoint.
# This is a script used by the project's Docker environment to
# setup the app containers and databases upon runnning.
set -e

# Check or install the app dependencies via Bundler:
echo "== Installing dependencies =="
bundle check || bundle install

# Check if the database exists, or setup the database if it doesn't, as it is
# the case when the project runs for the first time.
echo "== Preparing database =="

# db_host=${DB_HOST:-RDS_HOSTNAME} # check DB_HOST or RDS_HOSTNAME env variables
# # Wait for PostgreSQL
# until nc -z -v -w30 $db_host 5432
# do
#   echo 'Waiting for PostgreSQL...'
#   sleep 1
# done
# echo "PostgreSQL is up and running"
bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:setup

# 8: Specify a default command, in case it wasn't issued:
if [ -z "$1" ]; then set -- bundle exec puma "$@"; fi

# If the command to execute is 'rails server', then force it to write the
# pid file into a non-shared container directory. Suddenly killing and removing
# app containers without this would leave a pidfile in the project's tmp dir,
# preventing the app container from starting up on further attempts:
rm -f tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Docker
exec "$@"
