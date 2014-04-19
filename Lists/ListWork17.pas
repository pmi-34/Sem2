uses
  PT4;

var
  I : integer;
  P : PNode;
begin
  Task('ListWork17');

  read(P);
  i := 1;
  while (P <> nil) do begin
    write(P^.Data);
    if (P^.Next = nil) then begin
      write(i, P);
    end;
    inc(i);
    P := P^.Next;
  end;
end.

