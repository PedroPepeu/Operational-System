#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>

#include "changing_state_process.h" // include of the func library so I can sync the both archives
#include "warns.h"

#define BUF_SIZE 100
// defining the Buf size to use in char array, so I can print the message faster

int proc(pid_t pid) {
    char    buf[BUF_SIZE]; // creating a char array to display the output
    
    if(pid<0) { // check if fails
        perror("fork fail"); // sending error
        return ERROR_PROCESS_FAIL; // exiting
    }
    else if(pid == 0) { // checking if its a child process
        sprintf(buf, "child process_id(pid) = %d\n", getpid());
        // assigning the message to the char array
        write(1, buf, strlen(buf)); // printing the output
    }
    else { // checking if its a parent process
        sprintf(buf, "parent process_id(pid) = %d\n", getpid());
        // assigning the message to the char array
        write(1, buf, strlen(buf)); // printing the output
    }

    stpcontfork(pid); 
    return 0;
}

int main(void)
    /* creating the method main, where it will:
     *  - create a process;
     *  - if it fails than print it and exiting;
     *  - reconizing if its a child process or a parent process;
     *  - calling the method stdcont passing the process to stop and continue;
     * */
{
   
    pid_t   pid; // creating the pid to save the process
    
    for(int i = 0; i < 200; i++) {
        pid = fork(); // creating the process and assiging to pid
        proc(pid);
    }


    return 0; // returning 0 exiting the program
}
