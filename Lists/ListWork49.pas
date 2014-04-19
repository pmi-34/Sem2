uses
  PT4;

function GetMaxL(H : PNode) : integer;
var
  Q : PNode;
  i,j,max : integer;
begin
  i := 0;
  j := 0;
  max := 0;
  
  Q := H;
  while (j < 3) do begin
    if (Q = H) then begin
      inc(j);
      if (max = 0) and (j = 2) then
        max := i;
    end;
      
    if (Q^.Data < 0) then
      inc(i)
    else begin
      if (i > max) then
        max := i;
      i := 0;
    end;
    Q := Q^.Next;
  end;
    
  GetMaxL := max;
end;

var
  H : PNode;
begin
  Task('ListWork49');

  read(H);
  
  write(GetMaxL(H));
end.

