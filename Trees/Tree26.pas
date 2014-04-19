uses PT4, Trees;

procedure Ins(var P : PNode; X : integer; D : boolean);
begin
  if (P = nil) then begin
    New(P);
    P^.Data := X;
    P^.Left := nil;
    P^.Right := nil;
  end else
    if (D) then
      Ins(P^.Left, X, not D)
    else
      Ins(P^.Right, X, not D);
end;

var
  P : PNode;
  N,X : integer;
begin
  Task('Tree26');
  read(N);
  P := nil;
  
  while (N > 0) do begin
    read(X);
    Ins(P, X, true);
    dec(N);
  end;
  
  PrintTree(P);
  write(P);
end.
