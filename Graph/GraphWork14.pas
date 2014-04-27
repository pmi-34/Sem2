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
      M[x,i] := -Y;
    end;
  end;
  
  close(F);
end;

function FindIsolated(var G : MGraph; N : integer) : integer;
var
  i,j,S,R : integer;
begin
  R := 0;
  for i := 1 to N do begin
    S := 0;
    
    for j := 1 to N do
      if (G[i,j] = 0) then
        inc(S);
        
    if (S = N) then
      inc(R);
  end;
  FindIsolated := R;
end;

var
  G : MGraph;
  N : integer;
  S : string;
begin
  Task('GraphWork14');

  read(S);
  ReadGraphM(G, N, S);
  write(FindIsolated(G, N));
end.

