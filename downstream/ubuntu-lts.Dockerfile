FROM ubuntu:latest
#           note latest maps the LTS, not the current stable

RUN apt-get update \
    &&  DEBIAN_FRONTEND=noninteractive \
            apt-get install -y --no-install-recommends \
                    ffmpeg \
    && apt-get clean \
    && rm -rf /var/apt/lists/*

ENTRYPOINT [ "/usr/bin/ffmpeg" ]
