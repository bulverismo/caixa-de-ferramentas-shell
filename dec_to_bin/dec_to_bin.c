#include<stdio.h>
#include<stdlib.h>

int main(int argc, char *argv[])
{ 
  int n, c, k;
  if (argc==1)
    scanf("%d",&n);
  else
    n=atoi(argv[1]);

  for(c=31;c>=0;c--)
  {
    k = n >> c;

    if (k & 1)
      printf("1");
    else
      printf("0");
  }
  printf("\n");
  return 0;
}
