# https://docs.docker.com/develop/develop-images/multistage-build/
# ===== Stage: Base
FROM ruby:2.6.1-alpine AS Base

# Add gems installation requirements
RUN apk add --no-cache build-base git postgresql-dev

# ===== Stage: App
FROM ruby:2.6.1-alpine AS App

# Add Alpine runtime packages
RUN apk add --no-cache postgresql-client tzdata

# ===== Stage: Builder
FROM Base AS Builder

WORKDIR /tmp

COPY Gemfile* *.gemspec /tmp/
COPY lib/authenticator/version.rb /tmp/lib/authenticator/

# bundle for production by default
ARG BUNDLE_WITHOUT=test:development
ENV BUNDLE_WITHOUT ${BUNDLE_WITHOUT}

RUN bundle config --global frozen 1 \
    # Parallel donwload and install jobs
    && bundle install --jobs 4 --retry 3 \
    # Remove unneeded files (cached *.gem, *.o, *.c)
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

# ===== Stage: Final
FROM App AS Final
# Metadata
LABEL maintainer='Hugo Armenta <h.alexarmenta@gmail.com>' \
      name='Authenticator' \
      description='JWT Authentication solution'

# Add user: authenticator(default)
ARG UID=1000
ARG USER=authenticator
RUN addgroup -g ${UID} -S ${USER} \
    && adduser -u ${UID} -S ${USER} -G ${USER}
USER ${USER}

WORKDIR /app

# Copy app with gems from former build stage BUNDLE_PATH=/usr/local/bundle
COPY --chown=${USER}:${USER} --from=Builder $BUNDLE_PATH $BUNDLE_PATH
# Add app files
COPY --chown=${USER}:${USER} . .

ARG RAILS_ENV=production
ENV RAILS_ENV ${RAILS_ENV}
ENV RAILS_LOG_TO_STDOUT true

# Expose Puma port
EXPOSE 3000

# CMD runs once an image is prepared, make sure you have your dependencies
# already configured so application executes correclty.
CMD ["./docker-entrypoint.sh"]
