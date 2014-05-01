#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>

int main(void)
{
	int fd1, fd2;

	fd1 = open("in1.txt", O_RDONLY);
	if (fd1 < 0 ) { perror("first"); exit(1); }

	fd2 = open("in1.txt", O_RDONLY);
	if (fd2 < 0) { perror("first"); exit(1); }

	printf("in1.txt: %d -- in2.txt: %d\n", fd1, fd2);

	if (close(fd1) < 0) { perror("first"); exit(1); }
	if (close(fd2) < 0) { perror("first"); exit(1); }

	printf("Closed both fd's.\n");

	if ((fd2 = open("in1.txt", O_RDONLY)) < 0)
	{
		perror("first");
		exit(1);
	}

	printf("Reopened in1.txt into fd2: %d\n", fd2);

	if (close(fd2) < 0)
	{
		perror("f");
		exit(1);
	}

	printf("Closed fd2. Now calling close(fd2) again.\n");
	printf("This should cause an error\n\n");

	if (close(fd2) < 0)
	{
		perror("f");
		exit(1);
	}
	
	return 0;
}
