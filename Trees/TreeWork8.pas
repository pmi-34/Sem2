uses PT4;

{обратный обход, LNR}
procedure WalkLNR(Node :PNode);
begin
  if (Node <> nil) then begin
    WalkLNR(Node^.Left);
    write(Node^.Data);
    WalkLNR(Node^.Right);
  end;
end;

var
  P : PNode;
begin
  Task('TreeWork8');
  read(P);
  WalkLNR(P);
end.
