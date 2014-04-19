uses PT4, Dendrophylia;

var
  P,Q,R : PNode;
  X,K,I : integer;
  S : string;
  D : boolean;
begin
  Task('TreeWork35');
  readln(S);
  
  Show(ToPolish(S) + ' --- ');
  
  CreateInfixTree(P, S);
  
  write(P);
end.

