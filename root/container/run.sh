#!/bin/bash

PODMAN_CONTAINER_NAME="gentoo-aarch64-build-container"

# Interactive shell
PODMAN_ARGUMENTS="-it --rm"
PODMAN_COMMAND="bin/bash" 

# Background sshd
#PODMAN_ARGUMENTS=""
#PODMAN_COMMAND=""

source binfmt_check.sh

# Start the container running
podman run --platform linux/arm64/v8 \
    --mount=type=bind,src=/usr/bin/qemu-aarch64,dst=/usr/bin/qemu-aarch64,ro=true \
    --mount=type=bind,src=/var/db/repos/gentoo/,dst=/var/db/repos/gentoo/,ro=true \
    --mount=type=bind,src=/var/cache/distfiles,dst=/mnt/distfiles/,ro=true \
    -p 52222:22 --no-hosts --no-hostname \
    $PODMAN_ARGUMENTS \
    $PODMAN_CONTAINER_NAME \
    $PODMAN_COMMAND

