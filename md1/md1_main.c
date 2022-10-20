#include <stdlib.h>
#include <stdio.h>
#include "md1.h"

int main(int argc, char **argv)
{
  if (argc < 2)
    return 0;

  char* n_str = argv[1];
  int n = atoi(n_str);
  int sum = asum(n);
  printf("%u\n", sum);

  return 0;
}