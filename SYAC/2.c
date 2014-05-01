#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>

int main(void)
{
	char *c;
	int fd, sz, out;
	int stdout = 1,
		stdin = 0,
		stderr = 2;

	c = (char *) calloc(100, sizeof(char));

	fd = open("in1.txt", O_RDONLY);
	if (fd < 0)
	{
		perror("r");
		exit(1);
	}

	sz = read(fd, c, 10);write(stdout, c, strlen(c));
	printf("called read(%d, c, 10). Returned that %d bytes were read. \n", fd, sz);

	c[sz] = '\0';
	printf("The bytes are: %s\n", c);

	close(fd);

	out = open("out1.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
	write(stdout, c, strlen(c));
	write(out, c, strlen(c));

	return 0;
}