uses PT4;

procedure SimplifyMult(var Root : PNode);
begin
  if (Root <> nil) then begin
    SimplifyMult(Root^.Left);
    SimplifyMult(Root^.Right);
    
    if (
        ((Root^.Data = -2) and 
         (Root^.Right^.Data >= 0) and
         (Root^.Right^.Data = Root^.Left^.Data)
        ) or
        ((Root^.Data = -3) and 
         ((Root^.Left^.Data = 0) or
          (Root^.Right^.Data = 0))
        ) or
        ((Root^.Data = -4) and 
         (Root^.Left^.Data = 0))
       ) then begin
        Dispose(Root^.Left);
        Dispose(Root^.Right);
        Root^.Left := nil;
        Root^.Right := nil;
        Root^.Data := 0;
      end;
  end;
end;

var
  P : PNode;
begin
  Task('TreeWork39');
  read(P);
  SimplifyMult(P);
  write(P);
end.

