# https://docs.docker.com/develop/develop-images/multistage-build/
# Stage: Builder
FROM ruby:2.5.1-alpine as Builder

WORKDIR /app

ADD Gemfile* *.gemspec /app/

ARG BUNDLE_WITHOUT=test:development
ENV BUNDLE_WITHOUT ${BUNDLE_WITHOUT}

RUN apk add --no-cache build-base git postgresql-dev \
    # rails gems
    && bundle config --global frozen 1 \
    # Parallel donwload and install jobs 
    && bundle install --jobs 4 --retry 3 \
    # Remove unneeded files (cached *.gem, *.o, *.c)
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

# Add the Rails app
ADD . /app

# Stage: Final
FROM ruby:2.5.1-alpine
# Metadata
LABEL maintainer='Hugo Armenta <hugo@condovive.com>' \
      name='Authenticator' \
      description='JWT authentication solution for CondoVive' \
      version='4.0'

# Add Alpine packages
RUN apk add --update --no-cache \
    postgresql-client \
    tzdata

# Add user: condovive
ARG UID=1000

RUN addgroup -g 1000 -S condovive \
    && adduser -u ${UID} -S condovive -G condovive
USER condovive

# Copy app with gems from former build stage
COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder --chown=condovive:condovive /app /app
# set gem credentials
RUN printenv \
    mkdir -p ~/.gem \
    && echo ":gemstash: $GEMSTASH_PUSH_KEY" >> ~/.gem/credentials \
    && chmod 0600 ~/.gem/credentials

ARG RAILS_ENV=production
ENV RAILS_ENV ${RAILS_ENV}
ENV RAILS_LOG_TO_STDOUT true

WORKDIR /app

# Expose Puma port
EXPOSE 3000

# ENTRYPOINT runs everytime a container is prepared, make sure you have your
# dependencies already configured so entrypoint executes correclty.
ENTRYPOINT ["./docker-entrypoint.sh"]
