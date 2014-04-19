program P123;

type
  PStudent = ^Student;
  Student = record
    Num, Grade : integer;
    Name : string;
    Next : PStudent;
  end;

procedure InsertInto(var H : PStudent; Num, Grade : integer; Name : string);
var
  Q : PStudent;
begin
  if (H = nil) OR (H^.Num > Num) then begin
    New(Q);
    Q^.Num := Num;
    Q^.Grade := Grade;
    Q^.Name := Name;
    Q^.Next := H;
    H := Q;
  end else
    InsertInto(H^.Next, Num, Grade, Name);
end;

procedure Dump(X : PStudent);
begin
  if (X <> nil) then begin
    writeln(X^.Num, ' ', X^.Grade, ' ', X^.Name);
    Dump(X^.Next);
  end;
end;

var
  S : string;
  F : text;
  Num, Grade : integer;
  P,Q : PStudent;
begin
  P := nil;

  assign(F, 'in.txt');
  reset(F);
  
  while not EOF(F) do begin
    readln(F, Num, Grade, S);
    InsertInto(P, Num, Grade, S);
  end;
  
  close(F);

  //Dump(P);
  
  assign(F, 'out.txt');
  rewrite(F);
  
  while (P <> nil) do begin
    writeln(F, P^.Num, ' ', P^.Grade, ' ', P^.Name);
    Q := P;
    P := P^.Next;
    Dispose(Q);
  end;
  
  close(f);
end.
