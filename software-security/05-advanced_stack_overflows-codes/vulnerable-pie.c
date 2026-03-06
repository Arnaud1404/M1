#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void login() {
  /* We use execv() in place of system() to be robust on stack alignment.
   * See: https://ropemporium.com/guide.html#Common%20pitfalls */
  char *argv[] = { "/bin/sh", NULL };
  execv(argv[0], argv);
}

bool check_password() {
  char password[32];

  printf("Enter password: ");
  scanf("%s", password);

  return false;
}

int main() {
  printf("Hint, main() is at: %p\n", main);

  if (check_password())
    {
      printf("Access granted!\n");
      login();
    }
  else
    printf("Access denied!\n");

  return EXIT_SUCCESS;
}

