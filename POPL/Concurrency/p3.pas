program update3;

var flagA, flagB, flagC : boolean;
    turn : integer;

process A;
var l : integer;
begin
    repeat

    while (turn <> 1) do
        null;

    for l := 1 to 4 do
        write('A');

    turn := 2;

    forever
end;

process B;
var l : integer;
begin
    repeat

    while (turn <> 2) do
        null;

    for l := 1 to 4 do
        write('B');

    turn := 3;

    forever
end;

process C;
var l : integer;
begin
    repeat

    while (turn <> 3) do
        null;

    for l := 1 to 4 do
        write('C');

    turn := 1;

    forever
end;

begin

    turn := 1;

    cobegin
        A;
        B;
        C;
    coend;

end.
