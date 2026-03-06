#include <stdio.h>

int foo(int a, char b, float c)
{
    char buffer[8];
    int *ret;
    ret = (int *)(buffer + 0x80a7614);
    (*ret) += 7;
    return 0;
}

int main(void)
{
    int i = 0;
    foo(1, 'a', 2.5);
    i = 1;
    printf("%d\n", i);
    return 0;
}