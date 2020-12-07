IMAGE_NAMESPACE:=outlyernet
IMAGE_NAME=$(IMAGE_NAMESPACE)/ffmpeg-nonfree
DESTDIR:=
prefix:=/usr/local

bindir:=$(DESTDIR)$(prefix)/bin
BINARIES=ffmpeg ffplay ffprobe

###
### Main targets
###

all: build

build:
	docker build -t $(IMAGE_NAME) .

install: wrapper.sh
	mkdir -p $(bindir)
	for binary in $(BINARIES); do \
		install -m755 wrapper.sh $(bindir)/$$binary-ffmpeg-nonfree ; \
		sed -i "s/BINARY=ffmpeg/BINARY=$$binary/" $(bindir)/$$binary-ffmpeg-nonfree ; \
	done

install-shortnames: install
	for binary in $(BINARIES); do \
		ln -s $$binary-ffmpeg-nonfree $(bindir)/$$binary ; \
	done

uninstall:
	$(RM) $(addprefix $(bindir)/,$(addsuffix -ffmpeg-nonfree,$(BINARIES)))

uninstall-shortnames: uninstall
	$(RM) $(addprefix $(bindir)/,$(BINARIES))

# Print ffmpeg version and quit
version:
	@docker run --rm -it $(IMAGE_NAME) -version | grep ^ffmpeg

# Print the list of included codecs
codecs:
	docker run --rm -it $(IMAGE_NAME) -codecs

###
### Image/registry maintenance
###

pull:
	docker image pull $(IMAGE_NAME):latest

# Tag the image with relevant data:
#  1. Timestamp from the base Debian Testing image
#  2. ffmpeg package version
# debian:testing-slim has additional timestamp-based tags, e.g. testing-20201117-slim
# https://hub.docker.com/_/debian?tab=tags&page=1&ordering=last_updated
#  matching their build date. The timestamp of files coming from it can be used
BASEIMAGE_TIMESTAMP=$(shell docker run --rm -it \
		--entrypoint stat $(IMAGE_NAME) /usr --format='%y' \
		| awk '{print $$1}' \
		| sed 's/-//g')
FFMPEG_VERSION=$(shell docker run --rm -it \
		--entrypoint dpkg $(IMAGE_NAME) -s ffmpeg \
		| grep ^Version: \
		| cut -d: -f3)

# tag the image with the base debian tag
tag-snapshot: pull
	docker tag $(IMAGE_NAME):latest $(IMAGE_NAME):debian-testing-$(BASEIMAGE_TIMESTAMP)-ffmpeg-$(FFMPEG_VERSION)

shell:
	docker run --rm -it --entrypoint bash $(IMAGE_NAME)

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
