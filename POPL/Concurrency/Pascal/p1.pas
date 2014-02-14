program update2;

var C, turn : integer;
    flag1, flag2 : boolean;

process P1;
    var l : integer;
begin
    for l := 1 to 20 do
    begin
        flag1 := true;
        turn := 2;

        while flag2 and (turn = 2) do
            null;  (* This is known as a busy-wait loop *)

        C := C + 1;

        flag1 := false;

    end;
end;

process P2;
    var l : integer;
begin
    for l := 1 to 20 do
    begin
        flag2 := true;
        turn := 1;

        while flag1 and (turn = 1) do
            null;  (* This is known as a busy-wait loop *)

        C := C + 1;

        flag2 := false;

    end;
end;

begin
    C := 0;

    flag1 := false;
    flag2 := false;

    cobegin
        P1;
        P2;
    coend;

    write(C);
end.
