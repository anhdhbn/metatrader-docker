#!/usr/bin/env bash

set -e

envsubst '\$PORT,\$WEBSOCKIFY_PORT,\$AUDIO_WS' < /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/nginx.conf

nginx -g 'daemon off; master_process on;'
