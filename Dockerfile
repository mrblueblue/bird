FROM bitwalker/alpine-elixir:1.4.0

EXPOSE 4000
ENV PORT=4000 \
    MIX_ENV=prod

COPY . .
RUN \
    source .env && \
    mix do deps.get, deps.compile && \
    mix do compile, release --verbose --env=prod && \
    mkdir -p /opt/bird/log && \
    cp rel/bird/releases/0.1.0/bird.tar.gz /opt/bird/ && \
    cd /opt/bird && \
    tar -xzf bird.tar.gz && \
    rm bird.tar.gz && \
    rm -rf /opt/app/* && \
    chmod -R 777 /opt/app && \
    chmod -R 777 /opt/bird

WORKDIR /opt/bird
