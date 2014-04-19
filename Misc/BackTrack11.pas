uses
  PT4;
const
  MaxN = 15;
type
  Lab = array [1..MaxN] of array [1..MaxN] of char;

function Go(var A : Lab; N, X, Y, XC, YC : integer) : integer;
var
  I, Max : integer;
begin
  if ((X < 1) OR (X > N) OR (Y < 1) OR (Y > N)) then
    Go := 0
  else begin
    if (XC = X) AND (YC = Y) then
      Go := 1
    else begin
      if (A[X][Y] = ' ') then begin
        A[X][Y] := '+';
        Max := Go(A,N,X-1,Y,XC,YC);
        I := Go(A,N,X+1,Y,XC,YC);
        if (I > Max) then
          Max := I;
        I := Go(A,N,X,Y-1,XC,YC);
        if (I > Max) then
          Max := I;
        I := Go(A,N,X,Y+1,XC,YC);
        if (I > Max) then
          Max := I;
        A[X][Y] := ' ';
        if (Max <> 0) then
          inc(Max);
        Go := Max;
      end;
    end;
  end;
end;

var
  N, X, Y, XC, YC :integer;
  f : text;
  S : string;
  i,j : integer;
  A : Lab;
begin
  Task('BackTrack11');
  read(S);
  read(N,X,Y,XC,YC);

  assign(f, S);
  reset(f);
  for i := 1 to N do begin
    for j := 1 to N do
      read(f, A[i][j]);
    readln(f);
  end;
  close(f);
  
  write(Go(A, N, X, Y, XC, YC));
end.

