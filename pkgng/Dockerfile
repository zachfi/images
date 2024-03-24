FROM nginx:alpine
RUN apk update && apk add rsync
COPY filter.txt filter.txt
RUN rsync --del -rRv --links --filter="merge filter.txt" 'rsync://olaf.wire.znet/freebsd-pkg/' /usr/share/nginx/html/
