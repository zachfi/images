FROM alpine:3.16

LABEL description "DNS caching server"

RUN set -xe; apk add --no-cache unbound ca-certificates openssl ldns-tools

COPY entrypoint.sh /sbin/entrypoint.sh

EXPOSE 53 53/udp
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
CMD unbound -d -v
