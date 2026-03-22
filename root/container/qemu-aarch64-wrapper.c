// Compile with gcc qemu-aarch64-opts.c -static -o qemu-aarch64-wrapper

#include <string.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char **argv, char **envp) {
    char *newargv[6];

    // Program name
    newargv[0] = argv[0];

    // Raspberry Pi 5 CPU
    newargv[1] = "-cpu";
    newargv[2] = "cortex-a76";

    // Marginally faster load times
    newargv[3] = "-L";
    newargv[4] = "/usr/aarch64-unknown-linux-gnu";

    // Program being run
    memcpy(&newargv[5], &argv[1], sizeof(*argv) * (argc -1));
    newargv[argc + 4] = NULL;

    // Run qemu
    int fd = open("/usr/bin/qemu-aarch64", O_RDONLY);
    return fexecve(fd, newargv, envp);
}
