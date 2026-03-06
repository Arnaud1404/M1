#include <stdio.h>
#include <stdlib.h>

#define BUFFER_SIZE 768

void foo (void) {
  char buffer[64];
  fgets (buffer, BUFFER_SIZE, stdin);
}

int main (int argc, char *argv[]) {
  if (argc > 1) {
    fputs("error: too many arguments!\n", stderr);
    exit(EXIT_FAILURE);
  }

  system ("ls /tmp");
  foo ();
  return EXIT_SUCCESS;
}
