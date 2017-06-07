FROM scaleway/docker:amd64-latest
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/docker:armhf-latest	# arch=armv7l
#FROM scaleway/docker:arm64-latest	# arch=arm64
#FROM scaleway/docker:i386-latest		# arch=i386
#FROM scaleway/docker:mips-latest		# arch=mips

MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -qq update     \
 && apt-get -y -qq upgrade \
 && apt-get install -y -qq \
      s3cmd                \
      git                  \
      lftp                 \
      curl                 \
      nginx-full           \
 && apt-get clean

# Download scw
RUN case "${ARCH}" in                                                                                                                       \
	armv7l|armhf|arm)                                                                                                                       \
        scw_arch=arm                                                                                                                        \
      ;;                                                                                                                                    \
    amd64|x86_64|i386)                                                                                                                      \
        scw_arch=amd64                                                                                                                      \
      ;;                                                                                                                                    \
    i386)                                                                                                                                   \
        scw_arch=i386                                                                                                                       \
      ;;                                                                                                                                    \
    arm64|aarch64)                                                                                                                          \
        scw_arch=arm64                                                                                                                      \
      ;;                                                                                                                                    \
    *)                                                                                                                                      \
      echo "Unhandled architecture: ${ARCH}."; exit 1;                                                                                      \
      ;;                                                                                                                                    \
    esac;                                                                                                                                   \
    SCW_REPO=https://api.github.com/repos/scaleway/scaleway-cli/releases/latest;                                                            \
    JQ_FILTER='. as $root | .assets[] | select(.name | contains("scw_" + $root.tag_name[1:] + "_" + $a + ".deb")) | .browser_download_url'; \
    SCW_URL=$(curl -s -L $MACHINE_REPO | jq -r --arg a "${scw_arch}" $JQ_FILTER);                                                           \
    curl -L $SCW_URL > scw.deb

RUN dpkg -i scw.deb \
 && rm scw.deb

# Patch rootfs
ADD ./overlay/ /

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
