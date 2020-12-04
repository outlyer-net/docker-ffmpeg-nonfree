FROM alpine:3

RUN apk add ffmpeg 

ENTRYPOINT [ "/usr/bin/ffmpeg" ]
