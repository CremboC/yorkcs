#include <string.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int stdin = 0,
    stdout = 1,
    stderr = 2,
    false = 0,
    true = 1;

void out(char str[])
{
    write(stdout, str, strlen(str));
}

void help()
{
    char *help_text = 
        "Possible commands: \n"
        "c, create: creates a new file, arg2 should be file name. ex: cshell create file.txt\n"
        "w, write: writes text to a file, arg2 - file name, arg3 - text. ex: cshell write file.txt \"abc\"\n"
        "d, delete: deletes a file, arg2 - file name. ex: cshell delete file.txt \n"
        "o, output: outputs the file text, arg2 - file name. ex: chsell output file.txt\n";

    out(help_text);
}

void create_file(char name[])
{
    int fd;

    fd = open(name, O_WRONLY | O_CREAT | O_TRUNC, 0644);

    if (fd < 0) 
    { 
        perror(name); 
        exit(1); 
    }
    else
    {
        out("Successfully created file ");
        out(name);
        out("\n");
    }

    close(fd);
}

void write_file(char name[], char text[])
{
    int fd, sz;

    fd = open(name, O_WRONLY, 0644);

    if (fd < 0) 
    { 
        perror(name); 
        exit(1); 
    }
    else
    {
        sz = write(fd, text, strlen(text));

        if (sz > 0)
        {
            out("Successfully wrote text to file ");
            out(name);
            out("\n");
        }

    }

    close(fd);
}

void delete_file(char name[])
{
    if (remove(name) == 0)
    {
        out("Successfully deleted file ");
        out(name);
        out("\n");
    }
}

void output_file(char name[])
{
    char *buf;
    int fd, sz;

    buf = (char *) calloc(100, sizeof(char));

    fd = open(name, O_RDONLY, 0644);

    out("Outputting file "); out(name); out(":\n");
    do 
    {
        sz = read(fd, buf, 100);
        write(stdout, buf, sz);
    } while (sz == 100);

}

void execute_cmd(char cmd[])
{
    int pid = fork();
    int stat_loc;

    if (pid == 0) 
    {
        out("Executing command: "); out(cmd); out("\n");

        char path[255] = "/bin/";
        strcat(path, cmd);

        execl(path, ".\0", NULL);
    }
    else
    {
        wait(&stat_loc);
    }
}

int main(int argc, char *argv[])
{
    char *welcome = "Enter some input: (use 'cshell help' or h for help) \n";

    if (argc < 2)
    {
        out(welcome);
        out("Must pass arguments\n");
        return 1;
    }
    else
    {
        char *cmd = argv[1];
        if (cmd[0] == '-') cmd++; // removing the dash

        if (strcmp(cmd, "help") == 0
            || strcmp(cmd, "h") == 0)
        {
            help();
        }

        if (strcmp(cmd, "create") == 0 
            || strcmp(cmd, "c") == 0)
        {
            if (argv[2])
            {
                char *name = argv[2];
                if (name[0] == '-') name++;

                create_file(name);
            }
            else
            {
                out("Must pass filename as a second argument \n");
            }
            
        }

        if (strcmp(cmd, "write") == 0
            || strcmp(cmd, "w") == 0)
        {
            if (argv[2])
            {
                char *name = argv[2];
                if (name[0] == '-') name++;

                if (argv[3])
                {
                    char *text = argv[3];
                    if (text[0] == '-') text++;

                    write_file(name, text);
                }
                else
                {
                    out("Must pass text to write to file\n");
                }
            }
            else
            {
                out("Must pass filename as a second argument\n");
            }
            
        }

        if (strcmp(cmd, "delete") == 0 
            || strcmp(cmd, "d") == 0)
        {
            if (argv[2])
            {
                char *name = argv[2];
                if (name[0] == '-') name++;

                delete_file(name);
            }
            else
            {
                out("Must pass filename as a second argument \n");
            }
            
        }


        if (strcmp(cmd, "output") == 0 
            || strcmp(cmd, "o") == 0)
        {
            if (argv[2])
            {
                char *name = argv[2];
                if (name[0] == '-') name++;

                output_file(name);
            }
            else
            {
                out("Must pass filename as a second argument \n");
            } 
        }

        // ex.: cshell e ls || cshell execute ls
        if (strcmp(cmd, "execute") == 0 
            || strcmp(cmd, "e") == 0)
        {
            if (argv[2])
            {
                char *name = argv[2];
                if (name[0] == '-') name++;

                execute_cmd(name);
            }
            else
            {
                out("Must pass a command as a second argument \n");
            } 
        }

        
    }

    return 0;
}