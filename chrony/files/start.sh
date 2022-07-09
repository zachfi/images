#!/bin/bash

GPS_DEVICE=${GPS_DEVICE:-""}

touch /var/lib/chrony/chrony.drift && \
chown chrony:chrony -R /var/lib/chrony

if [ -n "${GPS_DEVICE}" ]; then
  gpsd -N -n /dev/ttyACM0 &
fi

chronyd -n -d -s -f "/etc/chrony.conf" &
wait -n
exit $?
