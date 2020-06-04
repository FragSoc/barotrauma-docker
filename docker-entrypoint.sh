#!/bin/bash

set -e

if [[ ! -f $CONFIG_LOC/serversettings.xml ]]; then
    cp $CONF_BASE/* "$CONFIG_LOC"
fi

if [[ ! -f $MODS_LOC/info.txt ]]; then
    cp -r $MODS_BASE/* "$MODS_LOC"
fi

"$INSTALL_LOC/DedicatedServer" "$@"
