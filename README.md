# Barotrauma Docker Image

A [docker](https://www.docker.com/) image for running a dedicated server for the game [Barotrauma](https://barotraumagame.com/).
Tested with server version `0.9.9.1`.

An example sequence to build then run:

```bash
docker build -t barotrauma .
docker run -d -p 27015:27015/udp -p 27016:27016/udp barotrauma
```

**Note:** *the UID of the user in the container defaults to `999`, pass `UID` as a build arg to change this*

## Ports

- Port `27015` *must* be opened for client connections
- Port `27016` can optionally be opened for steam communication

## Volumes

The container uses two volumes:

- Server configuration files at `/config`
- Mods files at `/mods`
- Saves at `/saves`

**Note:** *if you use a [bind mount](https://docs.docker.com/storage/bind-mounts/), the host path you mount into the container *must* be owned by the UID you passed to the build (default `999`)*

## Licensing

The few files in this repository are licensed under the [GPL](https://www.gnu.org/licenses/gpl-3.0.en.html).

However, Barotrauma itself is licensed by [Undertow Games](https://undertowgames.com/) and [Fakefish](http://fakefishgames.com/#home), no credit is taken for the software running in this container.
Read [their EULA](https://github.com/Regalis11/Barotrauma/blob/master/EULA.txt) for more information.
