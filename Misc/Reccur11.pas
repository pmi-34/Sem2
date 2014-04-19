uses
  PT4;

function Sum(x, y : real; N : integer) : real;
begin
  if (N > 1) then
    Sum := x + Sum(x*(y*y), y, N-1)
  else
    Sum := x;
end;

var
  x : real;
  N : integer;
begin
  Task('Reccur11');
  read(N, x);
  write(Sum(x,x,N));
end.

