program dining;

var chopsticks : array[1..3] of semaphore;
    mutex : semaphore;

process type phil(num : integer);
var l : integer;
begin
    for l := 1 to 20 do
    begin

        wait(mutex);

            sleep(random(5));
            writeln;
            write('Philosopher ', num, ' thinking');
            writeln;

        signal(mutex);

        wait(chopsticks[num]);
        wait(chopsticks[(num mod 3) + 1]);

        wait(mutex);

            sleep(random(5));
            writeln;
            write('Philosopher ', num, ' eating');
            writeln;

        signal(mutex);

        signal(chopsticks[num]);
        signal(chopsticks[(num mod 3) + 1]);


    end;
end;

var phils : array[1..3] of phil;

begin

    initial(chopsticks[1], 1);
    initial(chopsticks[2], 1);
    initial(chopsticks[3], 1);

    initial(mutex, 1);

    cobegin
        phils[1](1);
        phils[2](2);
        phils[3](3);
    coend;

end.
