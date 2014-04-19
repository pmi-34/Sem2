uses
  PT4;

type
  TListB = record
    Current,Barrier : PNode;
  end;
  PTListB = ^TListB;

procedure LBInsertLast(X : PTListB; Z : integer);
var
  Q,P : PNode;
begin
  New(Q);
  Q^.Data := Z;
  while X^.Current^.Next <> X^.Barrier do
    X^.Current := X^.Current^.Next;
    
  Q^.Prev := X^.Current;
  Q^.Next := X^.Barrier;
  X^.Current^.Next := Q;
  X^.Barrier^.Prev := Q;
  
  X^.Current := Q;
end;

var
  X : PTListB;
  N,Z,i : integer;
begin
  Task('Dynamic74');
  New(X);
  read(X^.Barrier, X^.Current);
  
  read(N);

  for i := 1 to N do begin
    read(Z);
    LBInsertLast(X, Z);
  end;

  write(X^.Current);
end.

