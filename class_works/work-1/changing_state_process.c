// Calling the libraries to use in the code
#include <stdio.h> // sprintf
#include <string.h> // strlen
#include <sys/types.h>
#include <unistd.h> // write
#include <signal.h> // SIGTSTP & SIGCONT

#include "changing_state_process.h" // include of the func library so I can sync the both archives

#define BUF_SIZE 100 
// defining the Buf size to use in char array, so I can print the message faster;


int stpcontfork(pid_t pid) 
    /* creating the method stdcont, where it will: 
        - ask for a pid;
        - stop this process and warn about it;
        - continue the process and warn about it;
    */    
{
    char    buf[BUF_SIZE]; // create a char array to display the output

    kill(pid, SIGTSTP); // stop the process sending to the process pid, with the int SIGTSTP
                        // the int signal SIGTSTP is used for stop the signal
    sprintf(buf, "Current process (%d) stopped.\n", getpid()); // warn being add to the buffer
    write(1, buf, strlen(buf)); // buffer printing the warn

    kill(pid, SIGCONT); // continue the process sending to it the int SIGTSTP
                        // the int signal SIGTSTP is used for continue the signal
    sprintf(buf, "Current process (%d) resumed.\n", getpid()); // warn being add to the buffer
    write(1, buf, strlen(buf)); // buffer printing the warn
    
    return 0; // returning 0 exiting the method
}
