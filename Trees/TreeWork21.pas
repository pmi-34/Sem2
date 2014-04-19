uses PT4;

{просто обход}
function CountK(Node : PNode; K : integer) : integer;
begin
  if (Node <> nil) then begin
    if (K = 0) then
      CountK := 1
    else if (K > 0) then
      CountK := CountK(Node^.Left, K-1) + CountK(Node^.Right, K-1)
    else
      CountK := 0;
  end;
end;

var
  P : PNode;
  N : integer;
begin
  Task('TreeWork21');
  read(N, P);
  write(CountK(P,N));
end.

