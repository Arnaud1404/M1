#include <stdio.h>
#include <stdlib.h>

#define BUFFER_SIZE 768

void foo (void) {
  char buffer[64];
  fgets (buffer, BUFFER_SIZE, stdin);
}

void bar (void) {
  long long v[5] = { 0xdec35a59bfc340, 0x34c31a8955c31f89, 0x050fc35bc358 };

  for (int i = 0; i < 5; ++i)
    if (v[i] == 0)
      return;
}

int main (int argc, char *argv[]) {
  if (argc < 2) {
    fputs("error: too few arguments!\n", stderr);
    exit(EXIT_FAILURE);
  }

  system ("ls /tmp");
  foo ();

  int p = atoi(argv[1]) * 2 + 0xdeadbeef;
  if (!(p >= 0 && p < 0xbaad))
    bar();

  return EXIT_SUCCESS;
}
