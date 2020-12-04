FROM debian:stable

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
