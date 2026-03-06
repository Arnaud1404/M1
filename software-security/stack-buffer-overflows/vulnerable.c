#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void foo (char *str) {
    char buffer[64];
    strcpy (buffer, str);
}

int main (int argc, char **argv) {
    if (argc < 2) {
        printf ("missing args\n");
        exit (EXIT_FAILURE);
    }
    foo (argv[1]);
    
    return EXIT_SUCCESS;
}