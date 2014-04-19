uses
  PT4;


procedure AddToLL(var H : PNode; N : integer);
var
  Q,P : PNode;
begin
  New(Q);
  Q^.Data := N;
  Q^.Next := H;
  
  if (H = nil) then begin
    H := Q;
    Q^.Next := Q;
  end else begin
    P := H;
    while (P^.next <> H) do
      P := P^.Next;
    P^.Next := Q;
  end;
end;

procedure CreateList(var H : PNode; N :integer);
var
  i,X : integer;
begin
  for i := 1 to N do begin
    readln(X);
    AddToLL(H, X);
  end;
end;

var
  H : PNode;
  N : integer;
begin
  Task('ListWork30');
  readln(N);

  H := nil;

  CreateList(H, N);
  writeln(H);
end.

