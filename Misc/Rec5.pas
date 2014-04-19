uses
  PT4;

function MyMin(N : integer) :integer;
var
  M, D : integer;
begin
  if (N = 0) then
    MyMin := 10
  else begin
    D := N mod 10;
    M := MyMin(N div 10);
    
    if ( D > M ) then
      MyMin := M
    else
      MyMin := D;
   end;
end;

var
   N : integer;
begin
  Task('Rec5');
  read(N);
  if (N = 0) then
    write(0)
  else
    write(MyMin(abs(n)));
end.

