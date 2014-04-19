uses PT4, Trees;

procedure DisposeTree(var P : PNode);
begin
  if (P <> nil) then begin
    DisposeTree(P^.Left);
    DisposeTree(P^.Right);
    Dispose(P);
    P := nil;
  end;
end;

procedure WalkD(var P : PNode; N : integer);
begin
  if (P <> nil) then begin
    if (P^.Data < N) then
      DisposeTree(P)
    else begin
      WalkD(P^.Left, N);
      WalkD(P^.Right, N);
    end;
  end;
end;

var
  P : PNode;
begin
  Task('Tree42');
  read(P);
  WalkD(P, P^.Data);
  PrintTree(P);
end.
