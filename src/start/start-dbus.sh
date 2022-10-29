#!/bin/bash

set -e
SUDO=''
if [ "$(id -u)" != "0" ]; then
  if groups | grep "\<sudo\>" &> /dev/null; then
    if [ "$(stat -c '%u' /etc/sudo.conf)" == "0" ]; then
      echo "dbus is running with sudo"
      SUDO='sudo'
      sudo -k
    fi
  fi
fi

$SUDO /usr/bin/dbus-daemon --nofork --print-pid --config-file=/usr/share/dbus-1/system.conf
