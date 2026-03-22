#!/bin/bash

PODMAN_IMAGE_NAME="gentoo-aarch64-build-container"

if [ $(uname -m) != 'aarch64' ]; then
    source binfmt_check.sh
    PODMAN_QEMU_BIND="--volume=/usr/bin/qemu-aarch64:/usr/bin/qemu-aarch64:ro"
    if [ -f /usr/local/bin/qemu-aarch64-wrapper ]; then
        PODMAN_QEMU_BIND="$PODMAN_QEMU_BIND --volume=/usr/local/bin/qemu-aarch64-wrapper:/usr/local/bin/qemu-aarch64-wrapper:ro"
    fi
else
    PODMAN_QEMU_BIND=""
fi

podman build --platform linux/arm64 \
    $PODMAN_QEMU_BIND \
    --volume=/var/db/repos/gentoo/:/var/db/repos/gentoo/:ro \
    --volume=/var/cache/distfiles/:/mnt/distfiles/:ro \
    --volume=$HOME/.ssh:/mnt/ssh/:ro \
    --no-hosts --no-hostname \
    -t $PODMAN_IMAGE_NAME -f Dockerfile
