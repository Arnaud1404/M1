#include <stdio.h>
#include <stdlib.h>

int main(void)
{
  printf("EGGSHELL is at %p\n", getenv("EGGSHELL"));

  return EXIT_SUCCESS;
}
