#!/bin/sh

# This script was verified with https://www.shellcheck.net/

# The Docker App Container's entrypoint.
# This is a script used by the project's Docker environment to
# setup the app containers and databases upon runnning.
set -e

: "${APP_PATH:=$PWD/spec/dummy}"
: "${APP_TEMP_PATH:="$APP_PATH/tmp"}"
: "${APP_SETUP_LOCK:="$APP_TEMP_PATH/setup.lock"}"
: "${APP_SETUP_WAIT:="5"}"

chown -R $USER:$USER /path/to/directory

# 1: Define the functions lock and unlock our app containers setup processes:
lock_setup() { mkdir -p "$APP_TEMP_PATH" && touch "$APP_SETUP_LOCK"; }
unlock_setup() { rm -rf "$APP_SETUP_LOCK"; }
wait_setup() { echo "Waiting for app setup to finish..."; sleep "$APP_SETUP_WAIT"; }

# 2: 'Unlock' the setup process if the script exits prematurely:
trap unlock_setup HUP INT QUIT TERM EXIT

# 3: Wait until the setup 'lock' file no longer exists:
while [ -f "$APP_SETUP_LOCK" ]; do wait_setup; done

# 4: 'Lock' the setup process, to prevent a race condition when the project's
# app containers will try to install gems and setup the database concurrently:
lock_setup

# 5: Check or install the app dependencies via Bundler:
bundle check || bundle install --jobs 20 --retry 5

# 6: Check if the database exists, or setup the database if it doesn't, as it # is the case when the project runs for the first time.
rake db:migrate 2>/dev/null || rake db:setup db:seed

# 7: 'Unlock' the setup process:
unlock_setup

# 8: Specify a default command, in case it wasn't issued.
# if [ -z "$1" ]; then set -- rails server -p 3000 -b 0.0.0.0 "$@"; fi

# 9: If the command to execute is 'rails server', then force it to write the
# pid file into a non-shared container directory. Suddenly killing and removing
# app containers without this would leave a pidfile in the project's tmp dir,
# preventing the app container from starting up on further attempts:
if [ -f "$APP_TEMP_PATH"/pids/server.pid ]; then
  rm -f "$APP_TEMP_PATH"/pids/server.pid
fi

# 10: Execute the given or default command:
exec "$@"
