-- The Bounded Buffer example was introduced in the lectures.
-- Use a single protected object to hold the buffer. The buffer
-- should hold 5 integers and be implemented as an array.
-- Write a program that contains this protected object and two task
-- types, one for writers to the buffer and one for readers.
-- Define 10 tasks of each of these types and allow them to access the
-- buffer. Use appropriate print statements to illustrate the
-- progress of your program. Each task should interact 4 times with
-- the buffer.

with Ada.integer_text_IO;
    use Ada.integer_text_IO;

with Text_IO;
    use Text_IO;

procedure ex3 is

    times : constant Integer := 50;

    task Bounded_Buffer is
        entry Insert(I : in Integer);
        entry Get(I : out Integer);
    end Bounded_Buffer;

    task body Bounded_Buffer is
        Size : constant Integer := 5;
        type Index is mod Size;
        Buffer : array(Index) of Integer;
        B, C : Index := 0;
        Current_Size : Integer := 0;
    begin
        loop
            select
                when Current_Size > 0 =>
                    accept Get(I : out Integer) do
                        Current_Size := Current_Size - 1;
                        I := Buffer(B);
                        B := B + 1;

                        put("Getting: ");
                        put(Index'Image(B));
                        put_line("");
                    end Get;
            or
                when Current_Size < Size =>
                    accept Insert(I : in Integer) do
                        Current_Size := Current_Size + 1;
                        Buffer(C) := I;
                        C := C + 1;

                        put("Putting: ");
                        put(Index'Image(C));
                        put_line("");
                    end Insert;
            or
                terminate;
            end select;
        end loop;
    end Bounded_Buffer;

    -- writes into the bounded buffer
    task type Writer is
    end Writer;

    task body Writer is
        Took : Integer;
    begin
        for Counter in 1 .. times loop
            Bounded_Buffer.Insert(Took);
        end loop;
    end Writer;

    -- reader! reads from the bounded buffer
    task type Reader is
    end Reader;

    task body Reader is
        Took : Integer;
    begin
        for Counter in 1 .. times loop
            Bounded_Buffer.Get(Took);
        end loop;
    end Reader;

    W : Writer;
    R : Reader;
    -- W1, W2, W3, W4, W5, W6, W7, W8, W9, W10 : Writer;
    -- R1, R2, R3, R4, R5, R6, R7, R8, R9, R10 : Reader;


begin -- ex3
    null;
end ex3;
