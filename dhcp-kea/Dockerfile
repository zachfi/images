FROM  alpine:3.17
LABEL description "ISC KEA DHCP server"
RUN apk --update --no-cache add kea && rm -rf /var/cache/apk/*
#RUN touch /var/lib/dhcp/leases
COPY entrypoint.sh /sbin/entrypoint.sh
WORKDIR /tmp
EXPOSE 67/udp 67
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
CMD dhcpd -cf /etc/dhcp/dhcpd.conf -lf /var/lib/dhcp/leases -pf /run/dhcp/dhcpd.pid
