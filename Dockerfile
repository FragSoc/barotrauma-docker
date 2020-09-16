FROM steamcmd/steamcmd
MAINTAINER Laura Demkowicz-Duffy <fragsoc@yusu.org>

# Directories
ENV INSTALL_LOC "/barotrauma"
ENV CONFIG_LOC "/config"
ENV MODS_LOC "/mods"
ENV SAVES_LOC "/saves"
ENV CONF_BASE "/config_readonly"

# Required since useradd does not appear to set $HOME
ENV HOME $INSTALL_LOC

# Build args
ARG UID=999
ARG GAME_PORT=27015
ARG STEAM_PORT=27016

# Update and install unicode symbols
RUN apt update
RUN apt upgrade --assume-yes
RUN apt install icu-devtools --assume-yes

# Create a dedicated user
RUN useradd -rs /bin/false -d $INSTALL_LOC -u $UID barotrauma

# Install the barotrauma server
RUN steamcmd \
    +login anonymous \
    +force_install_dir /barotrauma \
    +app_update 1026340 validate \
    +quit

# Install scripts
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY install-mod.sh /usr/bin/install-mod

# Symlink the game's steam client object into the include directory
RUN ln -s $INSTALL_LOC/linux64/steamclient.so /usr/lib/steamclient.so

# Sort configs and directories
RUN mkdir -p $CONFIG_LOC $CONF_BASE
RUN mv \
    $INSTALL_LOC/serversettings.xml \
    $INSTALL_LOC/Data/clientpermissions.xml \
    $INSTALL_LOC/Data/permissionpresets.xml \
    $INSTALL_LOC/Data/karmasettings.xml \
    $CONF_BASE
RUN ln -s $CONFIG_LOC/serversettings.xml $INSTALL_LOC/serversettings.xml
RUN ln -s $CONFIG_LOC/config_player.xml $INSTALL_LOC/config_player.xml
RUN ln -s $CONFIG_LOC/clientpermissions.xml $INSTALL_LOC/Data/clientpermissions.xml
RUN ln -s $CONFIG_LOC/permissionpresets.xml $INSTALL_LOC/Data/permissionpresets.xml
RUN ln -s $CONFIG_LOC/karmasettings.xml $INSTALL_LOC/Data/karmasettings.xml

# Setup mods folder
RUN mv $INSTALL_LOC/Mods $MODS_LOC
RUN ln -s $MODS_LOC $INSTALL_LOC/Mods

# Setup saves folder
RUN mkdir -p "$INSTALL_LOC/Daedalic Entertainment GmbH" $SAVES_LOC
RUN ln -s $SAVES_LOC "$INSTALL_LOC/Daedalic Entertainment GmbH/Barotrauma"

# Set directory permissions
RUN chown -R barotrauma:barotrauma \
    $CONFIG_LOC $INSTALL_LOC $MODS_LOC $SAVES_LOC

# User and I/O
USER barotrauma
VOLUME $CONFIG_LOC
VOLUME $MODS_LOC
VOLUME $SAVES_LOC
EXPOSE $GAME_PORT/udp
EXPOSE $STEAM_PORT/udp

# Exec
WORKDIR $INSTALL_LOC
ENTRYPOINT ["/docker-entrypoint.sh"]
