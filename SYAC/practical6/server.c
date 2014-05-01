#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <time.h> 
#include <fcntl.h>

void out(char str[])
{
    write(1, str, strlen(str));
}

void output_file(char name[], int connfd)
{
    char *buf;
    int fd, sz, tempSz;

    tempSz = 0;

    buf = (char *) calloc(100, sizeof(char));

    fd = open(name, O_RDONLY, 0644);

    do 
    {
        sz = read(fd, buf, 100);
        tempSz += sz;
    } while (sz == 100);

    write(connfd, &tempSz, sizeof(int));

    lseek(fd, 0, SEEK_SET);
    do 
    {
        sz = read(fd, buf, 100);
        write(connfd, buf, sz);
    } while (sz == 100);

    close(fd);
}

int main(int argc, char *argv[])
{
    int listenfd = 0, connfd = 0, n = 0;
    struct sockaddr_in serv_addr; 

    char sendBuff[1025];
    char recvBuff[1024];
    time_t ticks; 

    listenfd = socket(AF_INET, SOCK_STREAM, 0);
    memset(&serv_addr, '0', sizeof(serv_addr));
    memset(sendBuff, '0', sizeof(sendBuff)); 

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    serv_addr.sin_port = htons(5000); 

    int r = bind(listenfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr));

    if (r != 0) 
    {
        puts("Error binding");
    }    

    listen(listenfd, 10); 

    while(1)
    {
        connfd = accept(listenfd, (struct sockaddr*)NULL, NULL); 

        //ticks = time(NULL);
        //snprintf(sendBuff, sizeof(sendBuff), "%.24s\r\n", ctime(&ticks));
        //write(connfd, sendBuff, strlen(sendBuff)); 
        int tempSz = 0;
        read(connfd, &tempSz, sizeof(int));

        // reads any written data to the socket
        n = read(connfd, recvBuff, tempSz);
        recvBuff[n] = 0;
        out(recvBuff);

        output_file(recvBuff, connfd);

        close(connfd);
        sleep(1);
     }
}


