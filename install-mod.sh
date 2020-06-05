#!/bin/bash
set -e

# Perma-vars
BAROTRAUMA_ID=602960
DOWNLOAD_DIR=/tmp
RETRIEVE_DIR=$DOWNLOAD_DIR/steamapps/workshop/content/$BAROTRAUMA_ID

# Arg parsing
username=$1
shift
mod_nums=$@

# Create the steamcmd command
install_command=("steamcmd +login $username +force_install_dir $DOWNLOAD_DIR")
for mod in "${mod_nums[@]}"; do
    install_command+=("+workshop_download_item $BAROTRAUMA_ID $mod")
done
install_command+=("+quit")

# Download the mods
command ${install_command[@]}

# Move them
cp -r "$RETRIEVE_DIR"/* "$MODS_LOC"

printf "\n\nEnter the following line into your config_player.xml file to enable the mod:\n"
for mod in "${mod_nums[@]}"; do
    printf "<contentpackage path=\"Mods/%s/filelist.xml\" />\n" "$mod"
    sed -i "s/file=\"/file=\"Mods\\\\$mod\\\\/" "$MODS_LOC/$mod/filelist.xml"
done
