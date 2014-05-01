all: 1c.c 3.c
	# export set PATH.=:$PATH
	gcc -o cshell 1c.c
	gcc -w -o test 2.c
	gcc -pthread -w -o p3 3.c
	gcc -pthread -w -o phil 3phil.c

clean:
	rm cshell p3