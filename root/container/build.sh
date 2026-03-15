#!/bin/bash

PODMAN_IMAGE_NAME="gentoo-aarch64-build-container"

source binfmt_check.sh

podman build --platform linux/arm64 \
    --volume=/usr/bin/qemu-aarch64:/usr/bin/qemu-aarch64:ro \
    --volume=/var/db/repos/gentoo/:/var/db/repos/gentoo/:ro \
    --volume=/var/cache/distfiles/:/mnt/distfiles/:ro \
    --volume=$HOME/.ssh:/mnt/ssh/:ro \
    --no-hosts --no-hostname \
    -t $PODMAN_IMAGE_NAME -f Dockerfile
