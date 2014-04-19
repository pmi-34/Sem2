uses PT4, Dendrophylia;

var
  P : PNode;
  N,X : integer;
begin
  Task('TreeWork15');
  read(P, N);
  X := 0;
  write(FindX(P, N, X));
  write(X);
end.

