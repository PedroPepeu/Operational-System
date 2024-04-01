/* encerrar, abortar
 * carregar, executar
 * criar processo, encerrar processo
 * obter atributos do processo, definir atributos do processo
 * esperar hora
 * esperar evento, sinalizar evento
 * alocar e liberar memoria
 * */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int main(void)
{
    pid_t p1 = fork();
    assert(p1 >= 0);

    pid_t p2 = fork();
    assert(p2 >= 0);

    printf("Hello from pid %d\n", getpid());
}
