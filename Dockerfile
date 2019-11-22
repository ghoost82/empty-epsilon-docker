# Not using ubuntu:18.04 as it has problems with multi monitor setup
FROM ubuntu:19.10 AS build

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  ca-certificates \
  cmake \
  git \
  libfreetype6-dev \
  libglew-dev \
  libglu1-mesa-dev \
  libjpeg-dev \
  libopenal-dev \
  libpulse0 \
  libsfml-dev \
  libsndfile1-dev \
  libudev-dev \
  libx11-dev \
  libxcb1-dev \
  libxcb-image0-dev \
  libxrandr-dev \
  mesa-common-dev && \
  rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/daid/SeriousProton.git && \
  git clone https://github.com/daid/EmptyEpsilon.git
ARG RELEASE=master
RUN git -C /SeriousProton checkout ${RELEASE} && \
  git -C EmptyEpsilon checkout ${RELEASE}

RUN mkdir -p /EmptyEpsilon/_build
WORKDIR /EmptyEpsilon/_build/
RUN if [ "${RELEASE}" = "master" ]; then \
    cmake .. -DSERIOUS_PROTON_DIR=/SeriousProton/ \
    -DCMAKE_INSTALL_PREFIX=/usr/ \
    -DCMAKE_INSTALL_BINDIR=/usr/games/; \
  else \
    cmake .. -DSERIOUS_PROTON_DIR=/SeriousProton/ \
    -DCMAKE_INSTALL_PREFIX=/usr/ \
    -DCMAKE_INSTALL_BINDIR=/usr/games/ \
    -DCPACK_PACKAGE_VERSION_MAJOR=$(expr substr ${RELEASE} 4 4) \
    -DCPACK_PACKAGE_VERSION_MINOR=$(expr substr ${RELEASE} 9 2) \
    -DCPACK_PACKAGE_VERSION_PATCH=$(expr substr ${RELEASE} 12 2); \
  fi && \
  make && \
  make install


FROM ubuntu:19.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  libglu1-mesa \
  libpulse0 \
  libsfml-audio2.5 \
  libsfml-graphics2.5 \
  libsfml-network2.5 \
  libsfml-system2.5 \
  libsfml-window2.5 && \
  rm -rf /var/lib/apt/lists/*

RUN echo "default-server = unix:/run/user/1000/pulse/native \n autospawn = no \n daemon-binary = /bin/true \n enable-shm = false" > /etc/pulse/client.conf

RUN useradd -u 1000 -G audio ee
USER ee

COPY --from=build /usr/games/EmptyEpsilon /usr/games/
COPY --from=build /usr/share/emptyepsilon/ /usr/share/emptyepsilon/

ENV DISPLAY :0

ENTRYPOINT ["/usr/games/EmptyEpsilon"]
CMD ["fullscreen=0"]
