#!/bin/bash
for i in $(seq 1 30)
do
    sleep 1
    xdpyinfo -display ${DISPLAY} >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        break
    fi
    echo "Waiting for Xvfb..."
done

fbsetbg -u Esetroot /opt/background.png

/usr/bin/fluxbox -display ${DISPLAY}
