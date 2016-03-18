FROM scaleway/ubuntu:amd64-wily
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/ubuntu:armhf-wily       # arch=armv7l
#FROM scaleway/ubuntu:arm64-wily       # arch=arm64
#FROM scaleway/ubuntu:i386-wily        # arch=i386
#FROM scaleway/ubuntu:mips-wily        # arch=mips

# Prepare rootfs
RUN /usr/local/sbin/scw-builder-enter

# Add your commands here (before scw-builder-leave and after scw-builder-enter)

# Clean rootfs
RUN /usr/local/sbin/scw-builder-leave
