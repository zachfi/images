FROM golang:1.23-alpine3.19
LABEL maintainer="none"

# RUN apk update && apk add make go buildah git shadow-subids findmnt util-linux rootlesskit buildkit buildctl docker
RUN apk update && apk add make git util-linux bash docker kubectl openrc bash

RUN go install github.com/goreleaser/goreleaser/v2@v2.3.2
RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.62.2

# RUN echo nope:100000:65536 > /etc/subuid
# RUN echo nope:100000:65536 > /etc/subgid
#
# RUN addgroup -g 10001 -S nope && adduser -u 10001 -S nope -G nope

#RUN mkdir -p /var/lib/buildkit && chown nope:nope /var/lib/buildkit

#RUN mkdir -p /run/buildkit && chown nope:nope /run/buildkit

#RUN apk add --no-cache --update  fuse-overlayfs
#RUN sed -i 's/#mount_program/mount_program/' /etc/containers/storage.conf

# USER 10001
