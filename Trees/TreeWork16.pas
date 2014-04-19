uses PT4;

procedure InsertX(var Node : PNode; X : integer);
begin
  if (Node = nil) then begin
    New(Node);
    Node^.Data := X;
  end else if (Node^.Data > X) then
    InsertX(Node^.Left, X)
  else
    InsertX(Node^.Right, X);
end;

{обратный обход, LNR}
procedure WalkLNR(Node :PNode);
begin
  if (Node <> nil) then begin
    WalkLNR(Node^.Left);
    write(Node^.Data);
    WalkLNR(Node^.Right);
  end;
end;

procedure CreateTree(var P : PNode);
var
  N, X : integer;
begin
  read(N);
  
  while (N > 0) do begin
    read(X);
    InsertX(P, X);
    dec(N);
  end;
end;

var
  P : PNode;
begin
  Task('TreeWork16');
  P := nil;

  CreateTree(P);

  write(P);
  
  WalkLNR(P);
end.

