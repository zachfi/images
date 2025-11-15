FROM golang:1.25-alpine

ARG TARGETOS
ARG TARGETARCH
ENV GOOS=$TARGETOS GOARCH=$TARGETARCH
RUN apk --update add --no-cache build-base bash git util-linux docker kubectl bash gcompat

WORKDIR /tools
COPY go.mod go.sum tools.go install.sh /tools
RUN /tools/install.sh
COPY entrypoint.sh /bin/entrypoint.sh
ENTRYPOINT [ "/bin/entrypoint.sh" ]
