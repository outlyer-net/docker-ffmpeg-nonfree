FROM ubuntu:22.04
#           note latest maps to the LTS, not necessarily the current stable
#           22.04 *is* an LTS 

RUN apt-get update \
    &&  DEBIAN_FRONTEND=noninteractive \
            apt-get install -y --no-install-recommends \
                    ffmpeg \
    && apt-get clean \
    && rm -rf /var/apt/lists/*

ENTRYPOINT [ "/usr/bin/ffmpeg" ]
