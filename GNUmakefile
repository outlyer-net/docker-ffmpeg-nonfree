IMAGE_NAMESPACE:=outlyernet
IMAGE_NAME=$(IMAGE_NAMESPACE)/ffmpeg-nonfree
DESTDIR:=
prefix:=/usr/local

binname:=$(DESTDIR)$(prefix)/bin/ffmpeg-nonfree-docker

###
### Main targets
###

all: build

build:
	docker build -t $(IMAGE_NAME) .

install:
	mkdir -p "$(shell dirname "$(binname)")"
	echo '#!/bin/sh' > $(binname)
	echo 'exec docker run --rm -it $(IMAGE_NAME) "$$@"' >> $(binname)
	chmod 0755 $(binname)

uninstall:
	$(RM) $(binname)

# Print ffmpeg version and quit
version:
	@docker run --rm -it $(IMAGE_NAME) -version | grep ^ffmpeg

# Print the list of included codecs
codecs:
	docker run --rm -it $(IMAGE_NAME) -codecs

###
### Targets aimed at comparing the differences between distributions' ffmpeg
### and this image's
###
### The -% suffix in the targets below map to the dockerfiles in downstream/
###

# Build a list of distributions present in downstream/
DOWNSTREAM_IMAGES=$(shell ls downstream/*.Dockerfile | xargs -n1 -I'{}' basename '{}' .Dockerfile)

build-%:
	docker build \
		-t $(IMAGE_NAME):downstream-$* \
		-f downstream/$*.Dockerfile \
		.

version-%:
	@echo $*:
	@docker run --rm -it $(IMAGE_NAME):downstream-$* -version | grep ^ffmpeg

versions: version $(addprefix version-,$(DOWNSTREAM_IMAGES))

pull-distro-%:
	docker pull $(IMAGE_NAME):downstream-$*

pull-distros: $(addprefix pull-distro-,$(DOWNSTREAM_IMAGES))

codecs-%:
	docker run --rm -it \
		$(IMAGE_NAME):downstream-$* \
		-codecs

# Filter the list of codecs to a small selection
codecs-selected:
	@$(MAKE) codecs | grep -E '[[:space:]](h264|hevc|mjpeg|mpeg2video|aac)[[:space:]]'
codecs-selected-%:
	@$(MAKE) codecs-$* | grep -E '[[:space:]](h264|hevc|mjpeg|mpeg2video|aac)[[:space:]]'

compare-codecs-%:
	@-bash -c 'diff --color \
		<( $(MAKE) codecs-selected-$* ) \
		<( $(MAKE) codecs-selected    )'
	@echo

# Special comparison: Check if there's an actual difference in Ubuntu versions
compare-codecs-ubuntu-lts-vs-current:
	@-bash -c 'diff --color \
		<( $(MAKE) codecs-ubuntu-lts ) \
		<( $(MAKE) codecs-ubuntu )'
	@echo
