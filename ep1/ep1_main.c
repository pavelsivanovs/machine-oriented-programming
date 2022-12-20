#include <stdlib.h>
#include <stdio.h>
#include "ep1.h"

int main(int argc, char **argv)
{
    char *buffer;
    size_t length = 0;
    int lineLength = getline(&buffer, &length, stdin);

    // getline adds a newline symbol at the end. we don't need it
    for (int i = 0; i < 10000000; i++) {
        if (buffer[i] == '\n' || buffer[i] == '\r') {
            buffer[i] = '\0';
            break;
        }
    }
    
    int checksum = ep1(buffer);
    printf("%d", checksum);

    return 0;
}