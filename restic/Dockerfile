FROM alpine:3.21
LABEL description "NSD authoratative DNS resolver"
RUN set -xe; apk add --no-cache restic && rm -rf /var/cache/apk/*
COPY entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
