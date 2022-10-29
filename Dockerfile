ARG BASE_IMAGE=ubuntu:22.04

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    USERNAME=ubuntu \
    HOME=/home/ubuntu \
    SCREEN_WIDTH=1600 \
    SCREEN_HEIGHT=900 \
    SCREEN_DEPTH=24 \
    SCREEN_DPI=96 \
    DISPLAY=:99 \
    DISPLAY_NUM=99 \
    WEBSOCKIFY_PORT=6900 \
    AUDIO_WS=7000 \
    VNC_PORT=5900 \
    AUDIO_SERVER=1699 \
    VNC_PASSWD=

COPY src/common/*.sh /opt/scripts/

RUN bash /opt/scripts/apt_install.sh \
        sudo \
        supervisor \
        gettext \
    && bash /opt/scripts/apt_clean.sh

RUN bash /opt/scripts/apt_install.sh \
        dbus-x11 xvfb x11vnc x11-utils x11-xserver-utils \
        tigervnc-standalone-server tigervnc-common tigervnc-tools \
        novnc websockify \
        fluxbox lsb-release eterm \
    && bash /opt/scripts/apt_clean.sh

# audio + nginx + ucspi-tcp + gstreamer
RUN bash /opt/scripts/apt_install.sh \
        pulseaudio pavucontrol alsa-base nginx \
        ucspi-tcp \
        gstreamer1.0-plugins-good gstreamer1.0-pulseaudio gstreamer1.0-tools \
    && bash /opt/scripts/apt_clean.sh

#=========================================================================================================================================
# Run this command for executable file permissions for /dev/shm when this is a "child" container running in Docker Desktop and WSL2 distro
#=========================================================================================================================================
RUN chmod +x /dev/shm

# Creating base directory for Xvfb
RUN mkdir -p /tmp/.X11-unix /opt/bin /tmp/.ICE-unix && chmod 1777 /tmp/.X11-unix /tmp/.ICE-unix

RUN groupadd ${USERNAME} \
        --gid 1001 \
    && useradd ${USERNAME} \
            --create-home \
            --gid 1001 \
            --shell /bin/bash \
            --uid 1001 \
    && usermod -a -G sudo ${USERNAME} \
    && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo "${USERNAME}:${USERNAME}" | chpasswd

# Add Supervisor configuration file

COPY src/scripts/*.sh /opt/scripts/

RUN bash /opt/scripts/install_wine.sh

RUN bash /opt/scripts/setup_nginx.sh

RUN bash /opt/scripts/setup_dbus.sh

COPY src/conf/supervisor/supervisord.conf /etc/supervisor/

COPY src/conf/nginx/nginx.conf /etc/nginx/conf.d/nginx.conf.template

COPY src/conf/nginx/proxy_params /etc/nginx/proxy_params

COPY src/custom_novnc/* /usr/share/novnc/

COPY src/start/start-* /opt/bin/

COPY src/entry_point.sh /opt/bin/entry_point.sh

RUN bash /opt/scripts/relax_permission.sh

COPY assets/background.png /opt/background.png

USER ${USERNAME}

CMD ["/opt/bin/entry_point.sh"]
