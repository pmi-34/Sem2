uses
  PT4;

procedure RemoveFromLL(var H : PNode; X : PNode);
var
  P : PNode;
begin
  P := H;
  while (P^.Next <> X) do begin
    P := P^.Next;
  end;
    
  P^.Next := P^.Next^.Next;
  
  if (H = X) then
    H := X^.Next;
  
  Dispose(X);
end;

procedure DumpList(F : text; var H : PNode);
var
  Q,P : PNode;
begin
  Q := H;
  while (Q <> Q^.Next) do begin
    write(F, Q^.Data, ' ');
    P := Q^.Next;
    RemoveFromLL(H, Q);
    Q := P^.Next^.Next;
  end;
  write(F, Q^.Data);
  Dispose(Q);
end;

var
  S : string;
  H : PNode;
  F : text;
begin
  Task('ListWork66');
  read(H, S);

  assign(F, S);
  rewrite(F);
  
  DumpList(F, H);
  
  close(F);
end.

