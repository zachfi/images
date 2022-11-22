FROM  alpine:3.17
LABEL description "Time sync with Chrony and GPSd"
RUN apk --update --no-cache add chrony gpsd gpsd-clients && \
  rm -rf /var/cache/apk/* /etc/chrony
COPY entrypoint.sh /sbin/entrypoint.sh
WORKDIR /tmp
EXPOSE 123/udp
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
CMD chronyd -n -d -s -f "/etc/chrony.conf"
