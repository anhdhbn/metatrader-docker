#!/usr/bin/env bash

set -e

if [ ! -z $VNC_PASSWD ]; then
    mkdir -p $HOME/.vnc $HOME/.Xauthority
    x11vnc -storepasswd $VNC_PASSWD $HOME/.vnc/passwd
    X11VNC_OPTS="-rfbauth $HOME/.vnc/passwd -SecurityTypes VncAuth"
else
    echo "Starting VNC server without password authentication"
    X11VNC_OPTS="-SecurityTypes None"
fi

vncserver \
    ${X11VNC_OPTS} -display ${DISPLAY} -fg -useold -verbose \
    -localhost yes -rfbport ${VNC_PORT:-5900} \
    -geometry ${SCREEN_WIDTH}x${SCREEN_HEIGHT} -depth ${SCREEN_DEPTH} \
    -autokill yes \
    -AlwaysShared -AcceptKeyEvents -AcceptPointerEvents -AcceptSetDesktopSize -SendCutText -AcceptCutText \
    -xstartup /opt/bin/start-ui.sh
