#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>

#define MAX_COUNT 200
#define BUF_SIZE  100

int main(void)
{
    pid_t   pid;
    char    buf[BUF_SIZE];

    pid = fork();
    if(pid<0) {
        perror("fork fail");
        exit(1);
    }
    else if(pid == 0) {
        sprintf(buf, "child process_id(pid) = %d\n", getpid());
        write(1, buf, strlen(buf));
    }
    else {
    }
    return 0;
}
