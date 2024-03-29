<!-- shields.io -->
[![Docker Image Size (latest by date)][badge_image_size]][dockerhub]
[![Docker Cloud Build Status][badge_cloud_build_status]][dockerhub]
[![GitHub last commit][badge_github_last_commit]][github_commits]
[![MIT License][badge_github_license]][github_license]

# FFmpeg non-free in Docker

A dockerized [FFmpeg] compiled with non-free codecs in.
\
A script for easy invocation is included.

For Linux distributions where the included FFmpeg package isn't compiled with non-free codecs included.

This image pulls [Deb Multimedia][deb-multimedia]'s ffmpeg package, which includes codecs such as *Fraunhofer FDK AAC* (aka `libfdk_aac`, [the highest-quality AAC encoder in FFmpeg as of this writing][encode_aac]), missing from most compilations.

## Wrapper script installation

You can install and uninstall a wrapper script with the included makefile for easy access to the image's ffmpeg.
\
Running the script will pull the image if required.

```shell
$ sudo make install
$ ffmpeg-nonfree-docker [...]
```

You may additionally install symbolic links without the `-nonfree-docker` suffix:

```shell
$ sudo make install-shortnames
$ ffmpeg [...]
```

You may uninstall it with `sudo make uninstall`.

**NOTE**: The script will mount the host's filesystem as `/host` and run from the invoking directory. Additionally `/home` will also be mounted as simply `/home`.
\
Referencing files with relative paths should work without any extra parameter whereas absolute paths should be prepended by `/host` unless they're under `/home`.

```shell
$ ffmpeg-nonfree-docker -i input_file               # Access ./input_file from the host
$ ffmpeg-nonfree-docker -i ../input_file            # Access ../input_file from the host
$ ffmpeg-nonfree-docker -i /home/user/input_file    # Access /home/user/input_file from the host
$ ffmpeg-nonfree-docker -i /host/path/to/input_file # Access /path/to/input_file from the host
```

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

| Codec | Encoder        | this image | Debian | Ubuntu LTS | Ubuntu  | Alpine | Fedora  
|-------|----------------|------------|--------|------------|---------|--------|---------
| h.264                                                                                  
|       | h264_amf      | yes         | no     | no         | no      | no     | yes    |
|       | h264_nvenc    | yes         | no     | yes        | yes     | no     | yes    |
|       | h264_omx      | yes         | yes    | yes        | yes     | no     | no     |
|       | h264_qsv      | yes         | yes    | yes        | yes     | no     | yes    |
|       | libopenh264   | yes         | no     | no         | no      | no     | no     |
|       | nvenc         | no          | no     | yes        | yes     | no     | no     |
|       | nvenc_h264    | no          | no     | yes        | yes     | no     | no     |
| HEVC                                                                                   
|       | hevc_amf      | yes         | no     | no         | no      | no     | yes    |
|       | hevc_nvenc    | yes         | no     | yes        | yes     | no     | yes    |
|       | hevc_qsv      | yes         | yes    | yes        | yes     | no     | yes    |
|       | libkvazaar    | yes         | no     | no         | no      | no     | no     |
|       | nvenc_hevc    | no          | no     | yes        | yes     | no     | no     |
| MJPEG                                                                                  
|       | mjpeg_qsv     | yes         | yes    | yes        | yes     | no     | yes    |
| MPEG-2                                                                                 
|       | mpeg2_qsv     | yes         | yes    | yes        | no      | no     | yes    |
| AAC                                                                                    
|       | libfdk_aac    | yes         | no     | no         | no      | no     | no     |

Versions:
```shell
$ make pull-distros # pull the latest images
[...]
$ make versions
ffmpeg version 5.1 Copyright (c) 2000-2022 the FFmpeg developers
alpine:
ffmpeg version 5.0.1 Copyright (c) 2000-2022 the FFmpeg developers
debian:
ffmpeg version 4.3.4-0+deb11u1 Copyright (c) 2000-2021 the FFmpeg developers
fedora:
ffmpeg version 5.0.1 Copyright (c) 2000-2022 the FFmpeg developers
ubuntu:
ffmpeg version 4.4.2-0ubuntu0.22.04.1 Copyright (c) 2000-2021 the FFmpeg developers
ubuntu-lts:
ffmpeg version 4.4.2-0ubuntu0.22.04.1 Copyright (c) 2000-2021 the FFmpeg developers
```

## Links

- [GitHub]
- [Docker Hub][dockerhub]

<!-- links -->

[ffmpeg]: https://ffmpeg.org/
[deb-multimedia]: https://www.deb-multimedia.org/
[encode_aac]: https://trac.ffmpeg.org/wiki/Encode/AAC

[github]:    https://github.com/outlyer-net/docker-ffmpeg-nonfree
[dockerhub]: https://hub.docker.com/repository/docker/outlyernet/ffmpeg-nonfree

[microbadger]:    https://microbadger.com/images/outlyernet/ffmpeg-nonfree
[github_commits]: https://github.com/outlyer-net/docker-ffmpeg-nonfree/commits/master
[github_license]: https://github.com/outlyer-net/docker-ffmpeg-nonfree/blob/master/LICENSE

<!-- Aliases for images -->

[badge_image_size]:         https://img.shields.io/docker/image-size/outlyernet/ffmpeg-nonfree/latest
[badge_cloud_build_status]: https://img.shields.io/docker/cloud/build/outlyernet/ffmpeg-nonfree
[badge_microbadger_layers]: https://img.shields.io/microbadger/layers/outlyernet/ffmpeg-nonfree:latest
[badge_github_last_commit]: https://img.shields.io/github/last-commit/outlyer-net/docker-ffmpeg-nonfree
[badge_github_license]:     https://img.shields.io/github/license/outlyer-net/docker-ffmpeg-nonfree
