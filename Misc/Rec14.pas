uses
  PT4;

function Rev(N : integer; var P : integer) : integer;
begin
  if (N = 0) then
    Rev := 0
  else begin
    Rev := Rev(N div 10, p) + (N mod 10)*p;
    p *= 10;
  end;
end;

var
  N : integer;
  P : integer;
begin
  Task('Rec14');
  read(N);
  P := 1;
  write(Rev(N, p));
end.

