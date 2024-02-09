FROM golang:alpine3.19 as builder
WORKDIR /workspace/
RUN apk add git
RUN go install github.com/tomcz/openldap_exporter/v2@v2.2.2

FROM alpine:3.18
LABEL description "OpenLDAP exporter by tomcz"
COPY --from=builder /go/bin/openldap_exporter /usr/bin
#RUN set -xe; apk add --no-cache nsd ca-certificates openssl ldns-tools curl && rm -rf /var/cache/apk/*
#COPY entrypoint.sh /sbin/entrypoint.sh
#EXPOSE 53 53/udp
#ENTRYPOINT [ "/sbin/entrypoint.sh" ]
#CMD nsd -d -v

