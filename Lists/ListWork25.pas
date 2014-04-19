uses
  PT4, MemFix;

procedure Insert(H : PNode; M : integer);
var
  i : integer;
  Q : PNode;
begin
  i := 1;
  while (H <> nil) do begin
    if (i mod 2 = 1) and (H^.Next <> nil) then begin
     New(Q);
     Q^.Data := M;
     Q^.Next := H^.Next;
     H^.Next := Q;
     H := Q^.next;
    end else
      H := H^.Next;
    inc(i);
  end;
end;

var
  P : PNode;
  m  : integer;
begin
  Task('ListWork25');
  read(m,P);
  Insert(P, m);
  while (P^.Next <> nil) do
    P := P^.Next;
    
  write(P);
end.
