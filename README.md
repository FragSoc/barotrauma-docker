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

## Note

- The game configuration directory is at `/config` within the container; [mount](https://docs.docker.com/storage/volumes/) this if you wish
- **But** take note that if you use a [bind mount](https://docs.docker.com/storage/bind-mounts/), the place you mount into the container *must* be owned by UID/GID `999`

## Licensing

This repository is licensed under the [GPL](https://www.gnu.org/licenses/gpl-3.0.en.html).

However, Barotrauma is licensed by [Undertow Games](https://undertowgames.com/) and [Fakefish](http://fakefishgames.com/#home), I do not take any credit for the software running in this container.
