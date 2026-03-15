#!/bin/bash

PODMAN_IMAGE_NAME="gentoo-aarch64-build-container"

PS3="Select $PODMAN_IMAGE_NAME run mode: "
select MODE in Interactive sshd; do
    case $MODE in
        Interactive)
            # Settings for interactive shell interface
            PODMAN_ARGUMENTS="-it --rm"
            PODMAN_COMMAND="/bin/bash"
            break
            ;;
        sshd)
            # Settings for running with sshd in the background
            PODMAN_ARGUMENTS="-p 52222:22"
            PODMAN_COMMAND=""
            break
            ;;

        *)
            echo "Please select 1 or 2."
            ;;
    esac
done

if [ $(uname -m) != 'aarch64' ]; then
    source binfmt_check.sh
    PODMAN_QEMU_BIND="--mount=type=bind,src=/usr/bin/qemu-aarch64,dst=/usr/bin/qemu-aarch64,ro=true"
else
    PODMAN_QEMU_BIND=""
fi

# Assuming launching - this may change if we're in sshd mode and want to attach
DO_LAUNCH=1

# Check if an sshd container instance exists
if [ "$MODE" == "sshd" ]; then
    SSHD_CONTAINER=$(podman ps -a --sort runningfor | grep $PODMAN_IMAGE_NAME | grep 52222 | head -n1 | awk '{ print $1}')
    if [ $? -eq 0 ]; then
        DO_LAUNCH=0
        podman ps | grep -q $SSHD_CONTAINER
        # Check if it's running
        if [ $? -ne 0 ]; then
            # Not found running, so start it
            echo "Re-starting container..."
            podman start $SSHD_CONTAINER
        fi
    fi
fi

if [ $DO_LAUNCH -eq 1 ]; then
    echo "Starting container..."
    [ "$MODE" != "sshd" ] && echo ""

    # Start the container running
    podman run --platform linux/arm64/v8 \
        $PODMAN_QEMU_BIND \
        --mount=type=bind,src=/var/db/repos/gentoo/,dst=/var/db/repos/gentoo/,ro=true \
        --mount=type=bind,src=/var/cache/distfiles,dst=/mnt/distfiles/,ro=true \
        --no-hosts --no-hostname \
        $PODMAN_ARGUMENTS \
        $PODMAN_IMAGE_NAME \
        $PODMAN_COMMAND
fi

if [ "$MODE" == "sshd" ]; then
    echo -e "Connecting over ssh...\n"
    ssh localhost -p 52222 -l root -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no
fi
