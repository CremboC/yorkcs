-- Write an Ada program in which 4 `consumer' tasks call a
-- protected object and are blocked until a `producer' task
-- places a integer value in the object. All the blocked tasks are
-- then released with the integer value being passed to the client tasks.
-- Hint: you will need to use the 'count attribute.

with Ada.integer_text_IO;
use Ada.integer_text_IO;

procedure ex2 is

    protected type Store is
        procedure Insert;
        entry Take(V : out Integer);
    private
        Thing : Integer;
    end Store;

    protected body Store is
        procedure Insert is
        begin
            Thing := Thing + 1;
        end Insert;

        entry Take(V : out Integer) when Thing > 0 is
        begin
            V := Thing;
            Thing := Thing - 1;
        end Take;
    end Store;

    task type Consumer is
    end Consumer;

    task body Consumer is
        Took : Integer;
    begin
        Store.Take(Took);
        -- put("Consumer took: ");
        -- put(Took);
    end Consumer;

    task type Producer is
    end Producer;

    task body Producer is
    begin
        Store.Insert;
    end Producer;

begin -- ex2

    declare
        C1, C2 : Consumer;
        P1 : Producer;
    begin
        null;
    end;

end ex2;
