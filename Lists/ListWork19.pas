uses
  PT4, MemFix;

procedure AddToStack(var P : PNode; X : integer);
var
  Q : PNode;
begin
  New(Q);
  Q^.Data := X;
  Q^.Next := P;
  P := Q;
end;

var
  P : PNode;
  i,X,N : integer;
begin
  Task('ListWork19');

  P := nil;

  read(N);
  
  for i := 1 to N do begin
    read(X);
    AddToStack(P, X);
  end;
  
  write(P);
end.

