#!/bin/bash
set -e

# Perma-vars
# This is the steam appid of the client, not the server!
BAROTRAUMA_ID=602960
DOWNLOAD_DIR=/tmp
RETRIEVE_DIR=$DOWNLOAD_DIR/steamapps/workshop/content/$BAROTRAUMA_ID

# Arg parsing
username=$1
shift
mod_nums=( "$@" )

# Create the steamcmd command
install_command=("steamcmd +login $username +force_install_dir $DOWNLOAD_DIR")
for mod in "${mod_nums[@]}"; do
    install_command+=("+workshop_download_item $BAROTRAUMA_ID $mod")
done
install_command+=("+quit")

# Download the mods
command ${install_command[@]}

# Move them, removing old copies
for mod in "${mod_nums[@]}"; do
    if [[ -d "$MODS_LOC/$mod" ]]; then
        rm -rf "$MODS_LOC/$mod"
    fi
    mv "$RETRIEVE_DIR/$mod" "$MODS_LOC/$mod"
done
