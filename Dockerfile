FROM ruby:2.6.5-alpine3.11

WORKDIR /app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN set -eux; \
    apk add --update --no-cache --virtual .ruby-builddeps \
        alpine-sdk \
    ; \
    bundle install --jobs 20 --retry 5 \
    ; \
    apk del --purge .ruby-builddeps \
    ;

COPY lib/dlex_dns lib/dlex_dns
