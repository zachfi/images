FROM  alpine:3.22
LABEL description "ISC KEA DHCP server"
RUN apk --update --no-cache add kea && rm -rf /var/cache/apk/*
#RUN touch /var/lib/dhcp/leases
RUN mkdir -p /run/kea
COPY entrypoint.sh /sbin/entrypoint.sh
WORKDIR /tmp
EXPOSE 67/udp 67
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
CMD kea-dhcp4 -c /config/dhcp4.json
