#include <stdlib.h>
#include <stdio.h>
#include "md2.h"

int readMatrix(int *h, int *w, int **m);
int writeMatrix(int h, int w, int *m);

int main(int argc, char **argv)
{
    int h1, w1, h2, w2;
    int *m1, *m2, *m3;

    readMatrix(&h1, &w1, &m1);
    readMatrix(&h2, &w2, &m2);

    // m3 has num of rows from m1 and num of cols from m2
    m3 = (int *) malloc(h1 * w2 * sizeof(int));
    int result = matmul(h1, w1, m1, h2, w2, m2, m3);
    
    switch (result)
    {
    case 0:
        writeMatrix(h1, w2, m3);
        break;
    default:
        exit(result);
    }
    return 0;
}

// Reads a h*w matrix from stdin.
int readMatrix(int *h, int *w, int **m)
{
    scanf("%d", h);
    scanf("%d", w);
    *m = (int*) malloc((*h) * (*w) * sizeof(int));

    int *iter = *m;
    for (int i = 0; i < (*h) * (*w); i++) {
        scanf("%d", iter++);
    }
    return 0;    
}

// Outputs an h*w matrix to stdout.
int writeMatrix(int h, int w, int *m)
{
    int *iter = m;
    for (int i = 0; i < h; i++) {
        for (int j = 0; j < w; j++, iter++) {
            printf("%d ", *iter);
        }
        printf("\n");
    }
    return 0;
}