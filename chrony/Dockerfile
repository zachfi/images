FROM  alpine:3.16
RUN apk --update --no-cache add chrony gpsd gpsd-clients bash && \
  rm -rf /var/cache/apk/* /etc/chrony
COPY files/start.sh /usr/local/bin/start.sh
RUN chmod 0755 /usr/local/bin/start.sh
WORKDIR /tmp
EXPOSE 123/udp
ENTRYPOINT ["/usr/local/bin/start.sh"]
