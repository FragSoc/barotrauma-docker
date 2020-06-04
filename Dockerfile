FROM steamcmd/steamcmd
MAINTAINER Laura Demkowicz-Duffy

ENV INSTALL_LOC "/barotrauma"
ENV CONFIG_LOC "/config"
ENV CONF_BASE "/serversettings_ro.xml"
ENV HOME $INSTALL_LOC

# Update and install unicode symbols
RUN apt update && \
    apt upgrade --assume-yes && \
    apt install icu-devtools --assume-yes

# Create a dedicated user
RUN useradd -rs /bin/false -d $INSTALL_LOC barotrauma

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
RUN mkdir $CONFIG_LOC && \
    mv $INSTALL_LOC/serversettings.xml $CONF_BASE && \
    ln -s $CONFIG_LOC/serversettings.xml $INSTALL_LOC/serversettings.xml && \
    chown -R barotrauma:barotrauma $CONFIG_LOC $INSTALL_LOC

USER barotrauma
VOLUME $CONFIG_LOC
EXPOSE 27015/udp
EXPOSE 27016/udp

WORKDIR $INSTALL_LOC
ENTRYPOINT ["/docker-entrypoint.sh"]
