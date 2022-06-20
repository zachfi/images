#!/bin/sh

if [ ! -f /etc/unbound/root.key ]; then
  unbound-anchor -a /etc/unbound/root.key
fi

exec "$@"
