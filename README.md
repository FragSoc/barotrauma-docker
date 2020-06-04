# Barotrauma Docker Image

A docker image for running a dedicated server for the game [Barotrauma](https://barotraumagame.com/).
Build and run with:

```bash
docker build -t barotrauma .
docker run -p 27015:27015/udp -p 27016:27016/udp barotrauma
```

***Note:***

- The game configuration directory is at `/config` within the container; mount this if you wish
- **But** take note that if you use a bind mount, the place you mount into the container *must* be owned by UID/GID `999`
