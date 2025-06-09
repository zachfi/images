FROM alpine:3.22

EXPOSE 25/tcp
EXPOSE 587/tcp

RUN apk add postfix postfix-pcre postfix-mysql  policyd-spf-fs cyrus-sasl cyrus-sasl-login cyrus-sasl-crammd5 cyrus-sasl-digestmd5 cyrus-sasl-scram
RUN chown root:root /var/spool/postfix /var/spool/postfix/pid

VOLUME /etc/postfix
VOLUME /var/spool/postfix
CMD ["/usr/sbin/postfix", "start-fg"]
