#include <string.h>
#include <fcntl.h>
#include <stdlib.h>
#include <pthread.h>

int stdin = 0,
    stdout = 1,
    stderr = 2,
    false = 0,
    true = 1;

char arr[1024*1024];

void *alt(size_t size)
{
    

    printf("%d\n", (int) size);

}

void alt_free(void *ptr)
{

}

int main()
{
    printf("Mallocing\n");
    alt();
}