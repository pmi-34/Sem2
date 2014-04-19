uses
  PT4;
  
var
  P,Q,S : PNode;
begin
  Task('ListWork53');

  read(P);
  
  S := nil;
  Q := nil;
  
  repeat
    Q := P;
     P := P^.Next;
    Q^.Next := S;
    S := Q;
  until P = nil;
  
  write(S);
end.

