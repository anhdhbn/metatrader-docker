#!/usr/bin/env bash

#==============================================
# OpenShift or non-sudo environments support
# https://docs.openshift.com/container-platform/3.11/creating_images/guidelines.html#openshift-specific-guidelines
#==============================================

mkdir -p "/home/$(whoami)/.config"

SUDO=''
if [ "$(id -u)" != "0" ]; then
    if groups | grep "\<sudo\>" &> /dev/null; then
        if [ "$(stat -c '%u' /etc/sudo.conf)" == "0" ]; then
        SUDO='sudo'
        sudo -k
        fi
    fi
fi

$SUDO rm -rf /opt/scripts

if [[ ! -z "$USER_MOUNT_FOLDER" ]]; then
    if [ ! -d ${USER_MOUNT_FOLDER} ]
    then
        mkdir -p ${USER_MOUNT_FOLDER}
    fi
    CONFIG_FOLDER="/home/$(whoami)/.config"
    if [[ "$USER_MOUNT_FOLDER" == "$CONFIG_FOLDER"*  ]]; then
        $SUDO chown $(whoami) $CONFIG_FOLDER
    fi
    $SUDO chown $(whoami) $USER_MOUNT_FOLDER
fi

/usr/bin/supervisord --configuration /etc/supervisor/supervisord.conf &

SUPERVISOR_PID=$!

function shutdown {
    echo "Trapped SIGTERM/SIGINT/x so shutting down supervisord..."
    kill -s SIGTERM ${SUPERVISOR_PID}
    wait ${SUPERVISOR_PID}
    echo "Shutdown complete"
}

trap shutdown SIGTERM SIGINT
wait ${SUPERVISOR_PID}
