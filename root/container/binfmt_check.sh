#!/bin/bash

# Check for aarch64 & binfmt support
which qemu-aarch64 > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "qumu-aarch64 required!"
    exit 1
fi

if [ ! -f /etc/binfmt.d/qemu.conf ]; then
    echo "/etc/binfmt.d/qemu.conf required!"
    exit 1
fi

grep -q qemu-aarch64 /etc/binfmt.d/qemu.conf
if [ $? -ne 0 ]; then
    echo "aarch64 binarch required!"
    exit 1
fi

systemctl is-active --quiet systemd-binfmt
if [ $? -ne 0 ]; then
    echo "systemd-binfmt must be running!"
    exit 1
fi
