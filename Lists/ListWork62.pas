uses
  PT4, MemFix;

procedure InsertInto(var H : PNode; X : integer);
var
  Q : PNode;
begin
  if (H = nil) OR (H^.Data < X) then begin
    New(Q);
    Q^.Data := X;
    Q^.Next := H;
    H := Q;
  end else
    InsertInto(H^.Next, X);
end;

var
  S : string;
  F : text;
  i,N,X : integer;
  P : PNode;
begin
  Task('ListWork62');

  P := nil;

  read(S);
  assign(F, S);
  reset(F);
  readln(F, N);
  
  for i := 1 to N do begin
    read(F, X);
    InsertInto(P, X);
  end;
  
  close(F);
  write(P);
end.

