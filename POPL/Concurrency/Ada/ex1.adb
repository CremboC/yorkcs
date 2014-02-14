with Ada.integer_text_IO;
use Ada.integer_text_IO;
procedure ex1 is

    C : integer;

    task type P;

    task body P is
    begin
        for I in 1..10000000 loop
            C := C + 1;
        end loop;
    end P;

begin
    C := 0;

    -- Note the inner block is required to make sure the 'put' only
    -- occurs once the tasks have completed.
    declare
        P1, P2 : P;
    begin
        null;
    end;
    put(C);

end ex1;
