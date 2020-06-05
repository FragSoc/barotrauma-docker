FROM steamcmd/steamcmd
MAINTAINER Laura Demkowicz-Duffy

ENV INSTALL_LOC "/barotrauma"
ENV CONFIG_LOC "/config"
ENV MODS_LOC "/mods"
ENV SAVES_LOC "/saves"
ENV CONF_BASE "/config_readonly"
ENV MODS_BASE "/mods_readonly"
ENV HOME $INSTALL_LOC
ENV UID 999

# Update and install unicode symbols
RUN apt update && \
    apt upgrade --assume-yes && \
    apt install icu-devtools --assume-yes

# Create a dedicated user
RUN useradd -rs /bin/false -d $INSTALL_LOC -u $UID barotrauma

# Install the barotrauma server
RUN steamcmd \
    +login anonymous \
    +force_install_dir /barotrauma \
    +app_update 1026340 validate \
    +quit

COPY docker-entrypoint.sh /docker-entrypoint.sh

# Symlink the game's steam client object into the include directory
RUN ln -s $INSTALL_LOC/linux64/steamclient.so /usr/lib/steamclient.so

# Sort configs and directories
RUN mkdir -p $CONFIG_LOC $CONF_BASE && \
    mv \
        $INSTALL_LOC/serversettings.xml \
        $INSTALL_LOC/player_config.xml
        $INSTALL_LOC/Data/clientpermissions.xml \
        $INSTALL_LOC/Data/permissionpresets.xml \
        $INSTALL_LOC/Data/karmasettings.xml \
        $CONF_BASE && \
    ln -s $CONFIG_LOC/serversettings.xml $INSTALL_LOC/serversettings.xml && \
    ln -s $CONFIG_LOC/player_config.xml $INSTALL_LOC/player_config.xml && \
    ln -s $CONFIG_LOC/clientpermissions.xml $INSTALL_LOC/Data/clientpermissions.xml && \
    ln -s $CONFIG_LOC/permissionpresets.xml $INSTALL_LOC/Data/permissionpresets.xml && \
    ln -s $CONFIG_LOC/karmasettings.xml $INSTALL_LOC/Data/karmasettings.xml

# Setup mods folder
RUN mv $INSTALL_LOC/Mods $MODS_BASE && \
    mkdir -p $MODS_LOC && \
    ln -s $MODS_LOC $INSTALL_LOC/Mods

# Setup saves folder
RUN mkdir -p "$INSTALL_LOC/Daedalic Entertainment GmbH" $SAVES_LOC && \
    ln -s $SAVES_LOC "$INSTALL_LOC/Daedalic Entertainment GmbH/Barotrauma"

# Set directory permissions
RUN chown -R barotrauma:barotrauma \
    $CONFIG_LOC $INSTALL_LOC $MODS_LOC $SAVES_LOC

USER barotrauma
VOLUME $CONFIG_LOC
VOLUME $MODS_LOC
EXPOSE 27015/udp
EXPOSE 27016/udp

WORKDIR $INSTALL_LOC
ENTRYPOINT ["/docker-entrypoint.sh"]
