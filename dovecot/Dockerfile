FROM alpine:3.18

EXPOSE 143/tcp
EXPOSE 993/tcp

RUN apk add ca-certificates dovecot dovecot-lmtpd dovecot-mysql dovecot-pigeonhole-plugin
RUN install -d -o dovecot -g dovecot /run/dovecot

VOLUME /etc/dovecot
CMD ["/usr/sbin/dovecot","-F","-c","/etc/dovecot/dovecot.conf"]

