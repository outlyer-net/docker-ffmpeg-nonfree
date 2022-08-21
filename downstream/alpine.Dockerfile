FROM alpine:latest

RUN apk add ffmpeg 

ENTRYPOINT [ "/usr/bin/ffmpeg" ]
