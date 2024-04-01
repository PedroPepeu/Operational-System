#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <time.h>

void *thread_message(void *vargp)
{
    time_t t;

    int i;
    for(i = 0; i < 10e9; i++) {
        time_t t2;
        if(difftime(t, t2) > 1) {
            printf("error\n");
            return (int*)1;
        }
        printf("%d", i);
    }
    return NULL;
}

int main()
{
    pid_t pid = fork();
    pthread_t t1;

    pthread_create(&t1, NULL, thread_message, NULL);

    printf("dif\n");

    pthread_join(t1, NULL);
    printf("end process (%d)\n", getpid());
    return 0;
}
