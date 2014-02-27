-- Write an Ada program in which 4 `consumer' tasks call a
-- protected object and are blocked until a `producer' task
-- places a integer value in the object. All the blocked tasks are
-- then released with the integer value being passed to the client tasks.
-- Hint: you will need to use the 'count attribute.

with Ada.integer_text_IO;
    use Ada.integer_text_IO;

with Text_IO;
    use Text_IO;

procedure ex2 is

    -- the store!
    -- producers insert products into this store
    --     if less than 10 items in store
    -- consumers take from this store
    --     if there is more than 1 items in the store
    protected type Store is
        entry Insert;
        entry Take(V : out Integer);
    private
        Thing : Integer := 0;
    end Store;

    protected body Store is
        entry Insert when Thing < 10 is
        begin
            -- on insert just increase number of things by one
            Thing := Thing + 1;

            -- declare producer has inserted something
            put_line("Producer Inserted");
        end Insert;

        entry Take(V : out Integer) when Thing > 0 is
        begin
            -- on take, decrease by one and return it as the item taken
            V := Thing;
            Thing := Thing - 1;

            -- declare consumer took something
            put("Consumer took: ");
            put(V);
            put_line("");
        end Take;
    end Store;

    S : Store;

    -- the consumer!
    -- takes stuff from the store and prints out what it took
    task type Consumer is
    end Consumer;

    task body Consumer is
        Took : Integer;
    begin
        for Counter in 1 .. 500 loop
            S.Take(Took);
        end loop;
    end Consumer;

    -- the producer!
    -- inserts 'items' into the store, announces so once it has done it
    task type Producer is
    end Producer;

    task body Producer is
    begin
        for Counter in 1 .. 500 loop
            S.Insert;
        end loop;
    end Producer;

    C1, C2 : Consumer;
    P1 : Producer;

begin -- ex2
    null;
end ex2;
