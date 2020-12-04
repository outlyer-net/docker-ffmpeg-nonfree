# FFmpeg non-free in Docker

A dockerized [FFmpeg] compiled with non-free codecs in.
\
A script for easy invocation is included.

For Linux distributions where the included FFmpeg package isn't compiled with non-free codecs included.

This image pulls [Deb Multimedia][deb-multimedia]'s ffmpeg package, which includes codecs such as *Fraunhofer FDK AAC* (aka `libfdk_aac`, [the highest-quality AAC encoder in FFmpeg as of this writing][encode_aac]), missing from most compilations.

## A comparison of included codecs

Note the included makefile eases such comparisons (for a selection of codecs).
\
For each distribution with a corresponding Dockerfile in the `downstream/` directory you can get run:

```shell
$ make build-$distro compare-codecs-$distro
```

e.g.:
```shell
$ make build-debian compare-codecs-debian
```

Here's an excerpt of some important codecs (I'm only including differences):

| Codec | Encoder        | this image | Debian | Ubuntu LTS | Ubuntu  | Alpine
|-------|----------------|------------|--------|------------|---------|---------
| h.264                                                                         
|       | h264_nvenc    | yes         | no     | yes        | yes     | no     |
|       | h264_omx      | no          | yes    | yes        | yes     | no     |
|       | h264_qsv      | yes         | no     | no         | yes     | no     |
|       | libopenh264   | yes         | no     | no         | no      | no     |
|       | nvenc         | yes         | no     | yes        | yes     | no     |
|       | nvenc_h264    | yes         | no     | yes        | yes     | no     |
| HEVC                                                                          
|       | nvenc_hevc    | yes         | no     | yes        | yes     | no     |
|       | hevc_nvenc    | yes         | no     | yes        | yes     | no     |
|       | hevc_qsv      | yes         | no     | no         | yes     | no     |
|       | libkvazaar    | yes         | no     | no         | no      | no     |
| MJPEG                                                                         
|       | mjpeg_qsv     | yes         | no     | no         | yes     | no     |
| MPEG-2                                                                        
|       | mpeg2_qsv     | yes         | no     | no         | no      | no     |
| AAC                                                                           
|       | libfdk_aac    | yes         | no     | no         | no      | no     |

Versions:
```shell
$ make versions
ffmpeg version 4.1.6 Copyright (c) 2000-2020 the FFmpeg developers
debian:
ffmpeg version 4.1.6-1~deb10u1 Copyright (c) 2000-2020 the FFmpeg developers
ubuntu-lts:
ffmpeg version 4.2.4-1ubuntu0.1 Copyright (c) 2000-2020 the FFmpeg developers
ubuntu:
ffmpeg version 4.3.1-4ubuntu1 Copyright (c) 2000-2020 the FFmpeg developers
alpine:
ffmpeg version 4.3.1 Copyright (c) 2000-2020 the FFmpeg developers
```


[ffmpeg]: https://ffmpeg.org/
[deb-multimedia]: https://www.deb-multimedia.org/
[encode_aac]: https://trac.ffmpeg.org/wiki/Encode/AAC
