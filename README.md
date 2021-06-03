<div align="center">
    <a href=https://barotraumagame.com/>
        <img width=100% src="https://ehpodcasts.files.wordpress.com/2019/06/barotrauma-logo.jpg"/>
    </a>
    <br/>
    <img alt="Travis (.com)" src="https://img.shields.io/travis/com/FragSoc/barotrauma-docker?style=flat-square">
    <img alt="GitHub" src="https://img.shields.io/github/license/FragSoc/barotrauma-docker?style=flat-square">
    <img alt="TestedVersion" src="https://img.shields.io/badge/tested%20with-0.12.0.3-informational?style=flat-square">
</div>


---

A [docker](https://www.docker.com/) image for running a dedicated server for the game [Barotrauma](https://barotraumagame.com/).

## Usage

### Quickstart

```bash
docker build -t barotrauma https://github.com/FragSoc/barotrauma-docker.git && \
    docker run -d -p 27015:27015/udp -p 27016:27016/udp barotrauma
```

### Ports

- Port `27015/udp` *must* be opened for client connections
- Port `27016/udp` can optionally be opened for steam communication

Both of these can be changed, see below.

### Volumes

The container uses three volumes:

- Server configuration files at `/config`
- Mods files at `/mods`
- Saves at `/saves`

**Note:** *if you use [bind mounts](https://docs.docker.com/storage/bind-mounts/), the host paths you mount into the container *must* be readable+writable by the UID and/or GID you passed to the build (default `999`)*

### Build Args

Argument Key | Default Value | Description
---|---|---
`UID` | `999` | The *nix UID to assign to the user in the container
`GID` | `999` | The *nix GID to assign to the container user's primary group
`GAME_PORT` | `27015` | The port to open and assign for the game, must still be set in configuration
`STEAM_PORT` | `27016` | The port to open and assign for steam queries, must still be set in configuration
`APPID` | `1026340` | The steam appid to install for the server, unlikely to need changing
`STEAM_BETA` | | The string to pass to `steamcmd` to install a beta version of the game, eg. `-beta mybetaname -betapassword letmein`
`STEAM_EPOCH` | | Used to rebuild the image when a new game version is released, retaining the cached `apt` packages etc. Value itself is ignored. When you want to rebuild the image for the latest version of the game, use any unique value (the current timestamp is a good idea).

## Mods

### Enabling

To enable mods you've placed within the `/mods` within the container, pass the `ENABLED_MODS` env var to the container.
This should be a comma-separated list of the folder names within the `/mods` folder which you want to load into the session.

### Install Script

A minimal shell script is included to install mods with.
The script can be invoked (inside the container, make sure you're in an interactive session) with:

```bash
install-mod <steam username> <space-delimited list of workshop IDs...>
```

- You will be prompted by steamcmd to log in, this is because the steam workshop requires someone who owns the game to be logged in to download anything
- **[Currently Unverified]** Some mods may require special attention to paths inside their `filelist.xml` files

## Licensing

The few files in this repository are licensed under the [GPL](https://www.gnu.org/licenses/gpl-3.0.en.html).

However, Barotrauma itself is licensed by [Undertow Games](https://undertowgames.com/) and [Fakefish](http://fakefishgames.com/#home), no credit is taken for the software running in this container.
Read [their EULA](https://github.com/Regalis11/Barotrauma/blob/master/EULA.txt) for more information.
