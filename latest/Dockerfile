## -*- docker-image-name: "scaleway/image-builer" -*-

ARG SCW_ARCH

FROM scaleway/docker:${SCW_ARCH}-stable

MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


ARG SCW_ARCH
ARG SCW_CLI_VERSION


COPY ./update_image_tools.sh /usr/local/bin/
COPY ./update_image_tools.service /etc/systemd/system/

RUN /usr/local/sbin/builder-enter \
 && apt-get -q -y update   \
 && apt-get install -y -q --no-install-recommends \
    curl \
    jq \
    make \
    netcat-openbsd \
    wget

RUN case "${SCW_ARCH}" in                                                                                                           \
    armv7l|armhf|arm)                                                                                                               \
        curl -L https://github.com/scaleway/scaleway-cli/releases/download/v${SCW_CLI_VERSION}/scw_${SCW_CLI_VERSION}_armhf.deb  > scw.deb  \
      ;;                                                                                                                            \
    arm64)                                                                                                                          \
        curl -L https://github.com/scaleway/scaleway-cli/releases/download/v${SCW_CLI_VERSION}/scw_${SCW_CLI_VERSION}_arm64.deb  > scw.deb  \
      ;;                                                                                                                            \
    amd64|x86_64|i386)                                                                                                              \
        curl -L https://github.com/scaleway/scaleway-cli/releases/download/v${SCW_CLI_VERSION}/scw_${SCW_CLI_VERSION}_amd64.deb  > scw.deb  \
      ;;                                                                                                                            \
    *)                                                                                                                              \
      echo "Unhandled architecture: ${SCW_ARCH}."; exit 1;                                                                          \
      ;;                                                                                                                            \
    esac \
    && dpkg -i scw.deb \
    && rm scw.deb \
    && systemctl enable update_image_tools.service \
    && /usr/local/sbin/builder-leave
