// dining phils
#include <string.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <pthread.h>

int stdin = 0,
    stdout = 1,
    stderr = 2,
    false = 0,
    true = 1;

char *buf;

struct data {
    pthread_mutex_t mutex;
    pthread_cond_t cond;
} thread_data;

void out(char str[])
{
    write(stdout, str, strlen(str));
}

void *th_read(void *arg)
{
    // lock the mutex
    pthread_mutex_lock(&thread_data.mutex);

    int fd, sz;

    buf = (char *) calloc(100, sizeof(char));

    sz = read(stdin, buf, 100);

    // unlock the mutex, finished reading
    pthread_mutex_unlock(&thread_data.mutex);
    // signal the cond
    pthread_cond_signal(&thread_data.cond);

    pthread_exit("read exited.\n");
}

void *th_write(void *arg)
{

    // wait until cond is signalled and mutex is unlocked
    pthread_cond_wait(&thread_data.cond, &thread_data.mutex);

    out("outputting read input in a different thread: "); 
    out(buf);

    pthread_exit("write exited. gg.\n");
}

void *phil(void *arg)
{
    
}

int main()
{
    pthread_t thread_read;
    pthread_t thread_write;


    // initialise mutex and cond
    pthread_mutex_init(&thread_data.mutex, NULL);
    pthread_cond_init(&thread_data.cond, NULL);

    char *str = "abc";
    char *str2;

    // create thread
    // arg1 = thread address, arg2 = attributes
    // arg3 = function to call on thread create
    // arg4 = arguments to pass to called function
    int r = pthread_create(&thread_read, NULL, th_read, NULL);
    int w = pthread_create(&thread_write, NULL, th_write, NULL);

    pthread_join(thread_read, &str2);
    printf("%s\n", str2);

    pthread_join(thread_write, &str2);
    printf("%s\n", str2);
}