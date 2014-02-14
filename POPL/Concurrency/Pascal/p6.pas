program exc6;

var mutex : semaphore;

monitor Barrier;
    export
        Wait, Release;
    var
        arrived : integer;
        okToRelease : condition;
        releaseOccured : boolean;

    procedure Wait;
    begin
        arrived := arrived + 1;
        delay(okToRelease);
    end;

    procedure Release;
    begin
        if (arrived = 5) or (releaseOccured = true) then
        begin
            releaseOccured := true;

            while not empty(okToRelease) do
            begin
                resume(okToRelease);
                arrived := arrived - 1;
            end;

            if arrived = 0 then
            begin
                releaseOccured := false;
            end;
        end;
    end;
end;

process type Caller(id : char);
begin

    wait(mutex);

    writeln('Caller ', id, ' waiting.');
    writeln;

    signal(mutex);

    Barrier.Wait;

    wait(mutex);

    writeln('Caller ', id, ' calling.');
    writeln;

    signal(mutex);

end;

process Releaser;
begin
    repeat

    Barrier.Release;

    forever;
end;

var C1, C2, C3, C4, C5 : Caller;

begin

    initial(mutex, 1);

    cobegin
        C1('a');
        C2('b');
        C3('c');
        C4('d');
        C5('e');
        Releaser;
    coend;

end.
