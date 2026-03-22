// Compile with gcc qemu-aarch64-wrapper.c -static -o qemu-aarch64-wrapper

#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv, char **envp) {
    char **newargv = malloc(sizeof(char*) * (argc + 5));
    if (!newargv) return 1;

    // Program name
    newargv[0] = argv[0];

    // Raspberry Pi 5 CPU
    newargv[1] = "-cpu";
    newargv[2] = "cortex-a76";

    // Program being run
    memcpy(&newargv[3], &argv[1], sizeof(char*) * (argc - 1));
    newargv[argc + 2] = NULL;

    // Run qemu (requires /usr/bin/qemu-aarch64 to be mounted in the container)
    int fd = open("/usr/bin/qemu-aarch64", O_RDONLY);
    if (fd < 0) return 2;
    return fexecve(fd, newargv, envp);
}
