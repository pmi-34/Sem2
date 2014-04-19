uses
  PT4;

function Sign(X : integer) : integer;
begin
  if (X = 0) then
    Sign := 0
  else
    Sign := X div Abs(X);
end;

function Compare(P1, P2 : PNode) : integer;
var
  res : integer;
begin
  res := ord(P2=nil) - ord(P1=nil);
  
  if (res = 0) and (P1<>P2) then begin
    res := Sign(P1^.Data-P2^.Data);
    if (res = 0) then
      res := Compare(P1^.Next, p2^.Next);
  end;
  Compare := res;
end;

var
  P1, P2 : PNode;
begin
  Task('ListID9');
  read(P1, P2);
  write(Compare(P1, P2));
end.
