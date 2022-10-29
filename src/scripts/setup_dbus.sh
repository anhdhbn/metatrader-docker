#/bin/bash

set -e

if [ ! -d /var/run/dbus ]; then
  mkdir -p /var/run/dbus
fi
