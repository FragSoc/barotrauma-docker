# Barotrauma Docker Image

A [docker](https://www.docker.com/) image for running a dedicated server for the game [Barotrauma](https://barotraumagame.com/).
Tested with server version `0.9.9.1`.

Build and run using [docker-compose](https://docs.docker.com/compose/):

```bash
docker-compose up -d
```

If you want to run without docker-compose:

```bash
docker build -t barotrauma .
docker run -d -p 27015:27015/udp -p 27016:27016/udp barotrauma
```

## Volumes

The container uses two volumes:

- Server configuration files at `/config`
- Mods files at `/mods`

**Note:** *if you use a [bind mount](https://docs.docker.com/storage/bind-mounts/), the host path you mount into the container *must* be owned by UID/GID `999`*

## Known Issues

- Game save state isn't stored in a volume yet
- Coloured output from the server does not appear in docker logs unless running in interactive mode
- Issuing commands to the server is extremely cumbersome

## Licensing

The few files in this repository are licensed under the [GPL](https://www.gnu.org/licenses/gpl-3.0.en.html).

However, Barotrauma itself is licensed by [Undertow Games](https://undertowgames.com/) and [Fakefish](http://fakefishgames.com/#home), I do not take any credit for the software running in this container.
Read [their EULA](https://github.com/Regalis11/Barotrauma/blob/master/EULA.txt) for more information.
