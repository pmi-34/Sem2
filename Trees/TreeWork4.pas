uses PT4, Dendrophylia;

var
  P : PNode;
begin
  Task('TreeWork4');
  read(P);
  WalkLeavesLR(P);
end.

