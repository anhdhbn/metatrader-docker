#/bin/bash

set -e

sed -i -e 's/80/65535/g' /etc/nginx/sites-available/default

mkdir -p /var/lib/nginx/body /var/log/nginx

touch /run/nginx.pid
