uses
  PT4;

function Conv(N : integer) : integer;
begin
  if (N = 0) then
    Conv := 0
  else begin
    Conv := Conv(N div 4)*10 + N mod 4;
  end;
end;

var
  N : integer;
begin
  Task('Rec23');
  read(N);
  write(Conv(N));
end.

