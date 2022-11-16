FROM  alpine:3.17
LABEL description "ISC DHCP server"
RUN apk --update --no-cache add dhcp && rm -rf /var/cache/apk/*
RUN touch /var/lib/dhcp/leases
COPY entrypoint.sh /sbin/entrypoint.sh
WORKDIR /tmp
EXPOSE 67/udp 67
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
CMD dhcpd -cf /etc/dhcp/dhcpd.conf -lf /var/lib/dhcp/leases -pf /run/dhcp/dhcpd.pid
