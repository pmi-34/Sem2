uses
  PT4;
  
function Pop(var S : PNode) : integer;
var
  res : integer;
  Q : PNode;
begin
  res := S^.data;

  Q := S^.Next;
  Dispose(S);
  S := Q;

  Pop := res;
end;

var
  P : PNode;
  i,X : integer;
begin
  Task('ListWork55');
  read(P);
  
  for i := 1 to 5 do begin
    write(Pop(P));
  end;

  write(P);
end.

