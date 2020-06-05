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

# Copy mod filelists in
# find "$MODS_LOC" -maxdepth 1 -type d -exec sh -c 'sed "s/NewWorkshopItem/$(basename {})/" "{}/filelist.xml" > "$INSTALL_LOC/Data/ContentPackages/$(basename {}).xml"' \;

"$INSTALL_LOC/DedicatedServer" $@
