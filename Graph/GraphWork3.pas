uses PT4;


type
  MGraph = array [,] of integer;
  IArray = array of integer;
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
      M[i,j] := MAXINT div 2; // Чтобы избежать переполнения
  
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

{алгоритм Дейкстры}
procedure Dijkstra(var M : MGraph; N, St : integer; var X : IArray; var P : MGraph);
var
  Used : array of boolean;
  
  {ищем еще не задействованную вершину с минимальным путем до нее}
  function FindMin : integer;
  var
    i,min,min_i : integer;
  begin
    min := MAXINT;
    min_i := -1;
    
    for i := 1 to N do
      if ((X[i] < min) AND (not Used[i])) then begin
        min := X[i];
        min_i := i;
      end;
    FindMin := min_i;
  end;

  {копирует путь от X-той вершины до Y-той}
  procedure CopyP(X, Y : integer);
  var
    i : integer;
  begin
    i := 1;
    while(P[Y,i] <> -1) do begin
      P[X,i] := P[Y,i];
      inc(i);
    end;
    P[X,i] := X;
    P[X,I+1] := -1;
  end;

var
  I,Q : integer;
begin
  SetLength(X, N+1);
  SetLength(Used, N+1);
  SetLength(P, N+2, N+2);
  
  for i := 1 to N do begin
    X[i] := MAXINT;
    Used[i] := false;
    P[i,1] := -1;
  end;
  
  X[St] := 0;
  P[St,1] := St;
  P[St,2] := -1;
  
  Q := FindMin;
  while (Q <> -1) do begin
  {
    Show('Выбрана вершина ' + IntToStr(Q) + ': ');
    for i := 1 to N do
      Show(IntToStr(X[i]) + ' ');
    Show(chr($0D) + chr($0A));
  }      
    Used[Q] := true;
    for i := 1 to N do
      if (X[i] > (M[Q,i] + X[Q])) then begin
        X[i] := M[Q,i] + X[Q];
        CopyP(i, Q);
      end;

    Q := FindMin;
  end;
end;

var
  M : MGraph;
  N, N1, N2, i : integer;
  S : string;
  X : IArray;
  P : MGraph;
begin
  Task('GraphWork3');
  read(S, N1, N2);
  ReadGraphM(M, N, S);
  //DumpGraphM(M, N);
  
  Dijkstra(M, N, N1, X, P);
  i := 1;
  while (P[N2,i] <> -1) do begin
    write(P[N2,i]);
    inc(i);
  end;
  write(X[N2]);
end.
