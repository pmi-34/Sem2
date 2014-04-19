uses PT4;

var fin, fout: text;
    fnin, fnout: string;
    A:array[0..30] of LongInt;
    i, N:integer;

begin
  Task('Dyn1');
  readln(fnin);
  readln(fnout);
  assign(fin, fnin);
  reset(fin);
  readln(fin, N);
  close(fin);
  A[0] := 1; A[1] := 1; A[2] := 2;
  for i := 3 to N do
    A[i] := A[i-1] + A[i-2] + A[i-3];
  assign(fout, fnout);
  rewrite(fout);
  writeln(fout, A[N]);
  close(fout);
end.