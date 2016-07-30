#!/bin/bash
#########################################################################
# File Name: entrypoint.sh
# Author: LookBack
# Email: admin#dwhd.org
# Version:
# Created Time: 2016年07月29日 星期五 04时45分18秒
#########################################################################

set -e

CONFIG_DIR=/etc/transmission-daemon
SETTINGS=$CONFIG_DIR/settings.json
TRANSMISSION=/usr/local/bin/transmission-daemon

if [[ ! -f ${SETTINGS}.bak ]]; then
    if [ -z $ADMIN_PASS ]; then
        echo Please provide a password for the 'transmission' user via the ADMIN_PASS enviroment variable.
        exit 1
    fi

    [ -n $ADMIN_USER ] && sed -i.bak -e "s/@user@/$ADMIN_USER/" $SETTINGS
    [ -n $ADMIN_PASS ] && sed -i.bak -e "s/@password@/$ADMIN_PASS/" $SETTINGS
fi

exec $TRANSMISSION -f -M -g $CONFIG_DIR --log-info
