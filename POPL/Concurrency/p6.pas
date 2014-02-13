program barrier;

var mutex : condition;

monitor Barrier;
    export
        Wait, Release;
    var
        okToRelease : condition;

    procedure Wait;
    begin
        delay(okToRelease);
    end;

    procedure Release;
    begin
        while not empty(okToRelease) do
            resume(okToRelease);
    end;
end;

process type Caller(id : char);
begin

    writeln('Caller ', id, ' calling.');

    Barrier.wait;

end;

process Releaser;
begin

    Barrier.release;

end;

var C1, C2, C3, C4, C5 : Caller;

begin

    initial(mutex);

    cobegin
        C1;
        C2;
        C3;
        C4;
        C5;
        Releaser;
    coend;

end.
