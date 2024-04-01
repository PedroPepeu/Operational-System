#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

void test_fork(int x) {
    printf("%d\n", )
}

int main()
{
    pid_t p = fork();
    if(p<0) {
        perror("fork fail");
        exit(1);
    }
    printf("process_id(pid) = %d\n", getpid());
    return 0;
}
