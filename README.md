<center>
    <a href=https://barotraumagame.com/>
        <img width=100% src="https://ehpodcasts.files.wordpress.com/2019/06/barotrauma-logo.jpg"/>
    </a>
</center>

![](https://img.shields.io/travis/com/FragSoc/barotrauma-docker?style=flat-square)

A [docker](https://www.docker.com/) image for running a dedicated server for the game [Barotrauma](https://barotraumagame.com/).
Tested with server version `0.9.9.1`.

## Usage

An example sequence to build then run:

```bash
docker build -t barotrauma .
docker run -d -p 27015:27015/udp -p 27016:27016/udp barotrauma
```

**Note:** *the UID of the user in the container defaults to `999`, pass `UID` as a build arg to change this*

### Ports

- Port `27015` *must* be opened for client connections
- Port `27016` can optionally be opened for steam communication

### Volumes

The container uses two volumes:

- Server configuration files at `/config`
- Mods files at `/mods`
- Saves at `/saves`

**Note:** *if you use a [bind mount](https://docs.docker.com/storage/bind-mounts/), the host path you mount into the container *must* be owned by the UID you passed to the build (default `999`)*

## Mods

A minimal shell script is included to install mods with.
The script can be invoked (inside the container) with:

```bash
install-mod <steam username> <list of workshop IDs>
```

- You will be prompted by steamcmd to log in, this is because the steam workshop requires someone who owns the game to be logged in to download anything
- The script will give you a list of lines to enter into your `/config/config_player.xml` file (make sure you get them inside the root tag)
- Some mods may require special attention to paths inside their `filelist.xml` files

## Licensing

The few files in this repository are licensed under the [GPL](https://www.gnu.org/licenses/gpl-3.0.en.html).

However, Barotrauma itself is licensed by [Undertow Games](https://undertowgames.com/) and [Fakefish](http://fakefishgames.com/#home), no credit is taken for the software running in this container.
Read [their EULA](https://github.com/Regalis11/Barotrauma/blob/master/EULA.txt) for more information.
