FROM alpine:3.21
LABEL description "Restic backups"
RUN set -xe; apk add --no-cache bash restic && rm -rf /var/cache/apk/*
COPY entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
