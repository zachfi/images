FROM golang:alpine3.19 as builder
WORKDIR /workspace/
RUN go install github.com/optix2000/nsd_exporter@latest

FROM alpine:3.22
LABEL description "NSD authoratative DNS resolver"
COPY --from=builder /go/bin/nsd_exporter /usr/bin
RUN set -xe; apk add --no-cache nsd ca-certificates openssl ldns-tools curl && rm -rf /var/cache/apk/*
COPY entrypoint.sh /sbin/entrypoint.sh
EXPOSE 53 53/udp
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
CMD nsd -d -v
