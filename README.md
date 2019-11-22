# [Empty Epsilon](http://daid.github.io/EmptyEpsilon/) for Linux as Docker container.

Since there is no Linux build available (http://daid.github.io/EmptyEpsilon/#tabs=5) and the build instructions can be bothersome (https://github.com/daid/EmptyEpsilon/wiki/Build-from-sources) if you just want a quick game.

## Requirements:

- Linux (tested on Ubuntu 19.04)
- X11
- Docker

## Build

Building a stable release, e.g. EE-2019.11.01

```
RELEASE="EE-2019.11.01"
docker build --build-arg RELEASE="${RELEASE}" --tag empty-epsilon:${RELEASE} .
docker tag empty-epsilon:${RELEASE} empty-epsilon:latest
```

Building from master branch:

```
docker build --tag empty-epsilon .
docker tag empty-epsilon:${RELEASE} empty-epsilon:latest
```

## Run

With using PulseAudio for sound:

```
docker run --name empty-epsilon --rm -ti \
  --env=PULSE_SERVER=unix:/run/user/1000/pulse/native \
  --volume=$XDG_RUNTIME_DIR/pulse:/run/user/1000/pulse \
  --volume=$HOME/.Xauthority:/root/.Xauthority \
  --network=host \
  empty-epsilon
```

With using ALSA for sound:

```
docker run --name empty-epsilon --rm -ti \
  --volume=$HOME/.Xauthority:/root/.Xauthority \
  --network=host \
  --device=/dev/snd \
  empty-epsilon
```

By default it will run in non-fullscreen mode. Configuration options can be passed as arguments, eg:

```
docker run --name empty-epsilon --rm -ti \
  --env=PULSE_SERVER=unix:/run/user/1000/pulse/native \
  --volume=$XDG_RUNTIME_DIR/pulse:/run/user/1000/pulse \
  --volume=$HOME/.Xauthority:/root/.Xauthority \
  --network=host \
  empty-epsilon fullscreen=1
```
