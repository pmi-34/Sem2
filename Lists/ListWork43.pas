uses
  PT4;

type
  APNode = array [false..true] of PNode;

var
  P, R : PNode;
  H, T : APNode;
  F : boolean;
begin
  Task('ListWork42');
  read(P);
  
  if (P^.Next <> nil) then begin
    for F := false to true do begin
      H[F] := nil;
      T[F] := nil;
    end;
    
    F := false;
    repeat
      R := P;
      P := P^.Next;
      
      R^.Next := nil;
  
      R^.Prev := T[F];
  
      if (H[F] = nil) then
        H[F] := R
      else
        T[F]^.Next := R;

      T[F] := R;
      
      F := not F;
    until P = nil;

    T[true]^.Next := H[false];
    H[false]^.Prev := T[true];

    P := H[true];
  end;
  write(P);
end.

