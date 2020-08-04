FROM alpine:latest

LABEL "com.github.actions.name"="GitHub Action to purge Cloudflare cache"
LABEL "com.github.actions.description"="Purge the cache of an entire Zone or specific files from the Zone"
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="orange"

RUN apk update && apk add openssl curl

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]