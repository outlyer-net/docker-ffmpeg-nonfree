FROM debian:stable

# Standard(ish) labels/annotations (org.opencontainers.*) <https://github.com/opencontainers/image-spec/blob/master/annotations.md>
LABEL maintainer="Toni Corvera <outlyer@gmail.com>" \
      org.opencontainers.image.name="FFmpeg non-free" \
      org.opencontainers.image.description="A dockerized FFmpeg compiled with non-free codecs in." \
      org.opencontainers.image.url="https://hub.docker.com/repository/docker/outlyernet/ffmpeg-nonfree" \
      org.opencontainers.image.source="https://github.com/outlyer-net/docker-ffmpeg-nonfree"
#LABEL org.opencontainers.image.version= # TODO
#LABEL org.opencontainers.image.licenses= # TODO

RUN echo deb http://www.deb-multimedia.org stable main non-free > /etc/apt/sources.list.d/deb-multimedia.list

RUN apt-get update '-oAcquire::AllowInsecureRepositories=true' \
    &&  DEBIAN_FRONTEND=noninteractive \
            apt-get install -y --no-install-recommends \
                    --allow-unauthenticated \
                    deb-multimedia-keyring \
                    ffmpeg \
    && apt-get clean \
    && rm -rf /var/apt/lists/*

ENTRYPOINT [ "/usr/bin/ffmpeg" ]
