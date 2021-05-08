#!/bin/bash
set -eo pipefail

CONFIGS=(
    serversettings.xml
    karmasettings.xml
    permissionpresets.xml
    clientpermissions.xml
)

# Copy example configs in
for c in "${CONFIGS[@]}"; do
    if [[ ! -f "$CONFIG_LOC/$c" ]]; then
        cp "$CONFIG_BASE/$c" "$CONFIG_LOC"
    fi
done
