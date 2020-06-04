#!/bin/bash

set -e

if [[ ! -f $CONFIG_LOC/serversettings.xml ]]; then
    cp "$CONF_BASE" "$CONFIG_LOC/serversettings.xml"
fi

"$INSTALL_LOC/DedicatedServer" "$@"
