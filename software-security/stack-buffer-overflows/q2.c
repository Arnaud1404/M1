#include <stdio.h>
int foo(void)
{
    int buffer[8];
    int *ret;
    ret = buffer + 0;
    (*ret) += 0;
    ret = buffer + 0;
    (*ret) = 10;
    return 0;
}

int main(void)
{
    int i = 0;
    for (i = 0; i < 15; i++)
        foo();
    i = 1;
    printf("%d\n", i);
    return 0;
}