#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netdb.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <arpa/inet.h> 

int main(int argc, char *argv[])
{
    int sockfd = 0, n = 0;
    char recvBuff[1024];
    char *file;
    struct sockaddr_in serv_addr; 

    if(argc < 2)
    {
        printf("\n Usage: %s <ip of server> \n",argv[0]);
        return 1;
    } 

    memset(recvBuff, '0',sizeof(recvBuff));
    if((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        printf("\n Error : Could not create socket \n");
        return 1;
    } 

    memset(&serv_addr, '0', sizeof(serv_addr)); 

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(5000); 

    if(inet_pton(AF_INET, argv[1], &serv_addr.sin_addr)<=0)
    {
        printf("\n inet_pton error occured\n");
        return 1;
    } 

    if( connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
       printf("\n Error : Connect Failed \n");
       return 1;
    } 

    // if has three arguments, means user wants to send filename
    // and read from it
    if (argc == 3)
    {
        int size = strlen(argv[2]);
        // send the filename to the server
        write(sockfd, &size, sizeof(int));
        write(sockfd, argv[2], strlen(argv[2]));
    }

    int tempBuff;

    n = read(sockfd, &tempBuff, sizeof(int));
    
    while ( (n = read(sockfd, recvBuff, n)) > 0)
    {
        write(1, recvBuff, n);
    } 

    if(n < 0)
    {
        printf("\n Read error \n");
    } 

    return 0;
}
