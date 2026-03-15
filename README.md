# Gentoo (encrypted /) on Argon ONE UP (cm5)

This repo contains my configuration for Gentoo with an encrypted root filesystem on the [Argon ONE UP](https://wiki.argon40.com/en/AssemblyGuides/ONE_UP/OneUP_resource).

The intention is

## Usage

1. Have an Argon ONE UP with Gentoo installed
2. To be written...

To be written...

Notes:
- Replace `<UNENCRYPTED UUID GOES HERE>` in `/boot/cmdline.txt` and `/etc/fstab`
- Replace `<BOOT UUID GOES HERE>` in `/etc/fstab`
- Replace `<SWAP UUID GOES HERE>` in `/etc/fstab`
- Replace `<ENCRYPTED ROOT UUID GOES HERE>` in `/etc/crypttab`

## System Setup

*You might be wondering how I got here*

To be written...

## Build container

For larger packages you can cross-platform build them in a container on your x86-64 Gentoo system.
If you use another distribution some additional steps will be needed to use a [Portage container](https://hub.docker.com/r/gentoo/portage) instead of local Portage.
These instructions were written with [rootless](https://github.com/containers/podman/blob/main/README.md#rootless) [Podman](https://podman.io/) in mind, but will probably work with Docker.

1. Setup `qemu-aarch64` and `systemd-binfmt` according to the [Embedded Handbook](https://wiki.gentoo.org/wiki/Embedded_Handbook/General/Compiling_with_QEMU_user_chroot).
2. Update the configuration repository in [build.sh](./root/container/build.sh).
3. To build the container image run `bash build.sh`
4. Choose interactive or sshd in [run.sh](/root/container/run.sh).
5. To run the container for the first time run `bash run.sh`

To connect to the container using ssh run:

```shell
ssh localhost -p 52222 -l root -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no
```

Then assuming the default image name of `gentoo-aarch64-build-container`, to stop the container run:

```shell
podman kill $(podman ps --sort runningfor | grep gentoo-aarch64-build-container | head -n1 | awk '{ print $1}')
```

To restart the container run:

```shell
podman start $(podman ps -a --sort runningfor | grep gentoo-aarch64-build-container | head -n1 | awk '{ print $1}')
```

To remove the container after it's been stopped, run:

```shell
podman container rm $(podman ps -a --sort runningfor | grep gentoo-aarch64-build-container | head -n1 | awk '{ print $1}')
```

To remove the container image after the container's been removed, run:

```shell
podman image rm gentoo-aarch64-build-container
```

To clean dangling containers run

```shell
podman system prune --volumes
```

