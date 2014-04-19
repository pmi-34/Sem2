uses
  PT4;

var
  P : PNode;
begin
  Task('ListWork9');
  read(P);
  
  while (P <> nil) and (P^.Next <> nil) do
    P := P^.Next;
  
  write(P);
end.

