FROM steamcmd/steamcmd
MAINTAINER Laura Demkowicz-Duffy <fragsoc@yusu.org>

# Directories
ENV INSTALL_LOC="/barotrauma"
ENV CONFIG_LOC="/config"
ENV MODS_LOC="/mods"
ENV SAVES_LOC="/saves"

# Required since useradd does not appear to set $HOME
ENV HOME=$INSTALL_LOC

# Build args
ARG UID=999
ARG GID=999
ARG GAME_PORT=27015
ARG STEAM_PORT=27016
ARG APPID=1026340

# Update and install unicode symbols
RUN apt-get update && \
    apt-get install --no-install-recommends --assume-yes icu-devtools && \
    # Symlink the game's steam client object into the include directory
    ln -s $INSTALL_LOC/linux64/steamclient.so /usr/lib/steamclient.so && \
    # Create a dedicated user
    groupadd -r -g $GID barotrauma && \
    useradd -rs /bin/false -d $INSTALL_LOC -u $UID -g barotrauma barotrauma && \
    # Setup directories
    mkdir -p $CONFIG_LOC $INSTALL_LOC $SAVES_LOC $MODS_LOC && \
    chown -R barotrauma:barotrauma $CONFIG_LOC $INSTALL_LOC $SAVES_LOC $MODS_LOC

# Install scripts
COPY install-mod.sh /usr/bin/install-mod

# Switch to our unprivileged user
WORKDIR $INSTALL_LOC
USER barotrauma

# Install the barotrauma server
RUN steamcmd \
        +login anonymous \
        +force_install_dir $INSTALL_LOC \
        +app_update $APPID validate \
        +quit && \
    # Setup config folder
    mv \
        $INSTALL_LOC/serversettings.xml \
        $INSTALL_LOC/Data/clientpermissions.xml \
        $INSTALL_LOC/Data/permissionpresets.xml \
        $INSTALL_LOC/Data/karmasettings.xml \
        $CONFIG_LOC && \
    ln -s $CONFIG_LOC/serversettings.xml $INSTALL_LOC/serversettings.xml && \
    ln -s $MODS_LOC/config_player.xml $INSTALL_LOC/config_player.xml && \
    ln -s $CONFIG_LOC/clientpermissions.xml $INSTALL_LOC/Data/clientpermissions.xml && \
    ln -s $CONFIG_LOC/permissionpresets.xml $INSTALL_LOC/Data/permissionpresets.xml && \
    ln -s $CONFIG_LOC/karmasettings.xml $INSTALL_LOC/Data/karmasettings.xml && \
    # Setup mods folder
    mv $INSTALL_LOC/Mods/* $MODS_LOC && \
    ln -s $MODS_LOC $INSTALL_LOC/Mods && \
    # Setup saves folder
    mkdir -p "$INSTALL_LOC/Daedalic Entertainment GmbH" && \
    ln -s $SAVES_LOC "$INSTALL_LOC/Daedalic Entertainment GmbH/Barotrauma"

# I/O and exec
VOLUME $CONFIG_LOC $MODS_LOC $SAVES_LOC
EXPOSE $GAME_PORT/udp $STEAM_PORT/udp
ENTRYPOINT ["./DedicatedServer"]
