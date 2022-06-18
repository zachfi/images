#!/bin/sh

if [ ! -f /etc/unbound/unbound_server.pem ]; then
  unbound-control-setup
fi

exec "$@"
