uses
  PT4, MemFix;

function IsPrime(N : integer) : boolean;
var
  i,l : integer;
  res : boolean;
begin
  i := 2;
  
  repeat
    res := (N div i)*i <> N;
    inc(i);
    l := (N div i) + 1;
  until (i > l) or (not res);
  
  IsPrime := res;
end;

procedure AddToList(var H : PNode; X : integer);
begin
  if (H = nil) then begin
    New(H);
    H^.Next := nil;
    H^.Data := X;
  end else
    AddToList(H^.Next, X);
end;

procedure Remove(var H : PNode; X : PNode);
begin
  if (H <> nil) and (X <> nil) then begin
    if (H^.Data = X^.Data) then begin
      H := H^.Next;
      Dispose(X);
    end else
      Remove(H^.Next, X);
  end;
end; 

var
  N, i, X : integer;
  P,Q,Z : PNode;
begin
  Task('ListWork74');
  P := nil;
  
  readln(N);
  
  for i := 1 to N do begin
    readln(X);
    AddToList(P, X);
  end;
  
  Q := P;
  while (Q <> nil) do begin
    Z := Q^.Next;
    if (not IsPrime(Q^.Data)) then
      Remove(P, Q);
    Q := Z;
  end;
  
  write(P);
end.

