#!/bin/sh

if [ ! -f /etc/unbound/unbound_server.pem ]; then
  unbound-control-setup
fi

if [ ! -f /etc/unbound/root.key ]; then
  unbound-anchor -a /etc/unbound/root.key
fi

exec "$@"
