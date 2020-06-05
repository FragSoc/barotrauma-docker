#!/bin/bash

set -e

CONFIGS=(
    serversettings.xml
    karmasettings.xml
    permissionpresets.xml
    clientpermissions.xml
)

# Copy example configs in
for c in "${CONFIGS[@]}"; do
    if [[ ! -f $CONFIG_LOC/$c ]]; then
        cp "$CONF_BASE/$c" "$CONFIG_LOC"
    fi
done

"$INSTALL_LOC/DedicatedServer" $@
