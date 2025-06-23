FROM  alpine:3.22
RUN apk update && apk add rsync cron bash && rm -rf /var/cache/apk/*
CMD cron -f
