uses PT4;

var
  P : pnode;
  i : integer;
begin
  Task('ListWork12');
  read(p);
  i := 0;
  
  while (P <> nil) AND (i < 2) do begin
    if (P^.Data mod 6 = 0) then
      inc(i);
    
    if (i < 2) then
      P := P^.Next; 
  end;
    
  write(P);
end.
