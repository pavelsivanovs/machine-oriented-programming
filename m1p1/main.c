#include <stdio.h>
#include <stdlib.h>
#include "m1p1.h"

int main(int argc, char **argv)
{
    char *buffer;
    size_t length = 0;
    int lineLength = getline(&buffer, &length, stdin);

    m1p1(buffer);

    printf("%s", buffer);

    return 0;
}
