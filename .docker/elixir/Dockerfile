FROM elixir:1.9-alpine

ENV APP_HOME        /heimdall
ENV MIX_HOME        "$APP_HOME/.mix"
ENV MIX_ARCHIVES    "$MIX_HOME/archives"
ENV HEX_HOME        "$APP_HOME/.hex"

RUN apk update                                                  \
    && apk add --update nodejs npm                              \
    && apk add --update make gcc libc-dev inotify-tools

RUN mkdir -p ${APP_HOME}
WORKDIR ${APP_HOME}

ADD . ${APP_HOME}

RUN source .env

RUN mix local.hex --force                                       \
    && mix archive.install --force hex phx_new                  \
    && mix local.rebar --force

CMD [ "mix", "phx.server" ]
