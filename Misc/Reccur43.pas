uses
  PT4;

procedure Det(var Max, First : integer; N, pos : integer);
var
  D : integer;
begin
  if (N = 0) then begin
    Max := 0;
    First := pos;
  end else begin
    Det(Max, First, N div 10, pos+1);
    D := N mod 10;
    if (D > Max) then begin
      Max := D;
      First := Pos;
    end else if ( D = Max ) then
      First += Pos;
  end;
end;

var
  N, Max, First : integer;
begin
  Task('Reccur48');
  read(N);
  Det(Max, First, abs(N), 1);
  write(Max, First);
end.

