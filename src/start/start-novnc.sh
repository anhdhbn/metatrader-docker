#!/usr/bin/env bash

set -e

sed -i "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'remote');/g" /usr/share/novnc/app/ui.js

websockify --web=/usr/share/novnc/ ${WEBSOCKIFY_PORT:-6900} localhost:${VNC_PORT:-5900}
