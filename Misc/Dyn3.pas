//{$DEFINE DEBUG}
{$IFNDEF DEBUG}
uses
  PT4;
{$ENDIF}

const
  MaxN = 40;

type
  TArray = array [0..MaxN] of int64;

function CalcJump(var A : TArray; N, L : integer) : int64;
var
  i : integer;
begin
  if (N < 0) then
    CalcJump := 0
  else begin
    if (A[N] = 0) then begin
      for i := L downto 1 do begin
        A[N] += CalcJump(A, N-i, L);
      end;
    end;
    CalcJump := A[N];
  end;
end;

var
  Sin, Sout : string;
  f : text;
  N, L, i : integer;
  A : TArray;
begin
  {$IFNDEF DEBUG}
    Task('Dyn3');
  
    read(Sin, Sout);
    assign(f, Sin);
    reset(f);
    read(f, N, L);
    close(f);
  {$ELSE}
    read(N, L);
  {$ENDIF}
  
  A[0] := 1;
  for i := 1 to N do
    A[i] := 0;
  
  {$IFNDEF DEBUG}
    assign(f, Sout);
    rewrite(f);
    write(f, CalcJump(A, N, L));
    close(f);
  {$ELSE}
    write(CalcJump(A, N, L));
  {$ENDIF}
end.

