uses PT4;

type
  MGraph = array [,] of integer;
  VSet = set of integer;


procedure ReadGraphM(var M : MGraph; var N : integer; S : string);
var
  F : text;
  i, j, X, Y, K : integer;
begin
  assign(F, S);
  reset(F);
  // Считали число вершин
  readln(F, N);
  // Выделим память под массив
  SetLength(M, N+1, N+1);
  for i := 1 to N do
    for j := 1 to N do
      M[i,j] := 0;
  
  // Пропускаем ненужный мусор
  for i := 1 to N do
    readln(F);
  
  // Считываем информацию о вершинах
  for i := 1 to N do begin
    // Пропускаем мусор
    readln(F);
    readln(F, K);
    for j := 1 to K do begin
      readln(F, X, Y);
      M[i,x] := Y;
    end;
  end;
  
  close(F);
end;

procedure DumpGraphM(M : MGraph; N : integer);
var
  i,j : integer;
begin
  Show(N);
  
  for i := 1 to N do begin
    Show('Вершина ' + IntToStr(i) + ': ');
    for j := 1 to N do
      if (M[i,j] <> 0) then
        Show(IntToStr(j) + ' ');
    Show(chr($0D) + chr($0A));
  end;
end;

{процедура находит ребро с минимальным весом среди еще не найденных}
function FindMin(var M : MGraph; N : integer; var X : VSet; var U,V : integer) : integer;
var
  i,j, min : integer;
begin
  min := MAXINT;
  
  for i := 1 to N do
    for j := 1 to N do 
      if (((i in X) XOR (j in X)) AND (M[i,j] < min)) then begin
        min := M[i,j];
        u := i;
        v := j;
      end;
      
  if (min <> MAXINT) then begin
    // Упорядочим U и V так, чтобы U всегда входила в X
    if (V in X) then begin
      i := V;
      V := U;
      U := i;
    end;
    X += [u] + [v];
    FindMin := min;
  end else
    FindMin := -1;
end;

{алгоритм Прима}
function Prime(var M : MGraph; N : integer; var O : string) : integer;
var
  i,K,S, U,V : integer;
  X, Y : VSet;
begin
  X := [1];
  Y := [];
  for i := 1 to N do
    Y += [i];

  S := 0;
  O := '';

  while (X <> Y) do begin
    K := FindMin(M, N, X, U, V);
    if (K = -1) then begin
      Show('Internal error!');
      break;
    end else begin
      S += K;
      O += IntToStr(U) + '-' + IntToStr(V) + ',';
    end;
  end;
  Prime := S;
end;

var
  S : string;
  N,X : integer;
  M : MGraph;
begin
  Task('GraphWork4');
  read(S);
  ReadGraphM(M, N, S);
  //DumpGraphM(M, N);
  X := Prime(M,N,S);
  write(Copy(S, 1, Length(S)-1), X);
end.

