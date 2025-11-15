FROM golang:1.25-alpine AS builder

ARG TARGETOS
ARG TARGETARCH
ENV GOOS=$TARGETOS GOARCH=$TARGETARCH

RUN apk --update add --no-cache bash

WORKDIR /tools
COPY go.mod go.sum tools.go install.sh /tools/
RUN /tools/install.sh

FROM golang:1.25-alpine
RUN apk --update add --no-cache build-base bash git util-linux docker kubectl bash gcompat
COPY --from=builder /go/bin/* /usr/local/bin/
COPY entrypoint.sh /bin/entrypoint.sh
ENTRYPOINT [ "/bin/entrypoint.sh" ]
