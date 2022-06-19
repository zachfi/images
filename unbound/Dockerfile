FROM alpine:3.16

LABEL description "DNS caching server"

RUN set -xe; apk add --no-cache unbound ca-certificates openssl ldns-tools curl

RUN curl --output /etc/unbound/root.hints https://www.internic.net/domain/named.cache
RUN chown unbound /etc/unbound

COPY entrypoint.sh /sbin/entrypoint.sh

EXPOSE 53 53/udp
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
CMD unbound -d -v
