FROM golang:1.25-alpine as builder

WORKDIR /workspace/

RUN go install github.com/letsencrypt/unbound_exporter@latest
RUN which unbound_exporter

FROM alpine:3.22

LABEL description "Unbound caching DNS resolver"

COPY --from=builder /go/bin/unbound_exporter /usr/bin

RUN set -xe; apk add --no-cache unbound ca-certificates openssl ldns-tools curl

RUN curl --output /etc/unbound/root.hints https://www.internic.net/domain/named.cache
RUN chown unbound /etc/unbound

COPY entrypoint.sh /sbin/entrypoint.sh

EXPOSE 53 53/udp
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
CMD unbound -d -v
