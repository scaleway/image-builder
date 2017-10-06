NAME =			image-builder
VERSION =		latest
VERSION_ALIASES = 	1.4.4 1.4 1
TITLE =			image-builder
DESCRIPTION =		An image to build other images
SOURCE_URL =		https://github.com/scaleway/image-builder


IMAGE_VOLUME_SIZE =	50G
IMAGE_BOOTSCRIPT =	docker
IMAGE_NAME =		Image Builder 1.4.4

DEFAULT_IMAGE_ARCH = x86_64

## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - https://j.mp/scw-builder | bash
-include docker-rules.mk
## Below you can add custom makefile commands and overrides
