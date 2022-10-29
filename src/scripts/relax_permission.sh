#/bin/bash
set -e
# Relaxing permissions for other non-sudo environments

FOLDERS="/opt/bin /opt/scripts /var/run/supervisor /var/log/supervisor /var/run/dbus /usr/share/novnc /etc/nginx /var/lib/nginx /var/log/nginx"

mkdir -p $FOLDERS

chmod -R 777 $FOLDERS /etc/passwd /run/nginx.pid
chgrp -R 0 $FOLDERS /etc/passwd /run/nginx.pid
chmod -R g=u $FOLDERS /etc/passwd /run/nginx.pid
