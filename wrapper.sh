#!/bin/sh

# Wrapper script for FFmpeg with non-free codecs on Docker
# <https://github.com/outlyer-net/docker-ffmpeg-nonfree>

IMAGE_NAME='outlyernet/ffmpeg-nonfree'
uid=`id -u`
gid=`id -g`
BINARY=ffmpeg

exec docker run --rm -it \
	-v /etc/localtime:/etc/localtime:ro \
	-v /etc/passwd:/etc/passwd:ro \
	-v /:/host:rw \
	-v /home:/home:rw \
	--entrypoint /usr/bin/$BINARY \
	--workdir "/host/$PWD" \
	--user $uid:$gid \
	"$IMAGE_NAME" \
	"$@"

