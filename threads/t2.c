#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

int g = 0;

void *thread_met(void *vargp)
{
    int *myid = (int *)vargp;

    static int s = 0;

    ++s, ++g;

    printf("id: %d\nstatic: %d\nglobal: %d\n", *myid, ++s,++g);
    return 0;
}

int main() 
{
    int i;
    pthread_t t1;

    for(i = 0; i < 3; i++) {
        pthread_create(&t1, NULL, thread_met, (void *)&t1);
    }

    printf("the end\n");

    pthread_exit(NULL);
    return 0;
}
