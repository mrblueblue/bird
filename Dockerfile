FROM bitwalker/alpine-elixir:1.4.0

EXPOSE 4000
ENV PORT=4000 \
    MIX_ENV=prod

COPY . .
RUN \
    source .env && \
    mix do deps.get, deps.compile && \
    mix do compile, release --verbose --env=prod && \
