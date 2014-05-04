program P25;

{Задача номер 11 из третьей Д/З по графам}
{Найти пути максимальной длины и максимальной стоимости}
const
  MaxN = 100;

type
  TUsed = array [1..MaxN] of boolean;
  TInt = array [1..MaxN] of integer;
  TTInt = array [1..MaxN] of TInt;
  
  MGraph = array [,] of integer;
  IArray = array of integer;
  VSet = set of integer;
  
  PVertex = ^TVertex;
  PArc = ^TArc;
  
  TVertex = record
    id : integer;
    inf : integer;
    Next : PVertex;
    Arcs : PArc;
  end;
  TArc = record
    inf : integer;
    Next : PArc;
    Adj : PVertex;
  end;

procedure AddNode(var graph : PVertex; n,x : integer);
begin
  if (graph = nil) then begin
    New(graph);
    graph^.id := n;
    graph^.inf := x;
  end else
    AddNode(graph^.Next, n, x);
end;

procedure NewArc(var A : PArc; V : PVertex; Y : integer);
begin
  New(A);
  A^.Adj := V;
  A^.inf := Y;
  A^.Next := nil;
end;

procedure AddArc(var u, v : PVertex; Y : integer);
var
  A : PArc;
begin
  if ((u <> nil) AND (v <> nil)) then begin
    // Строит по типу очереди
    if (u^.Arcs = nil) then
      NewArc(U^.Arcs, V, Y)
    else begin
      A := u^.Arcs;
      while (A^.Next <> nil) do
        A := A^.Next;
      NewArc(A^.Next, V, Y);
    end;
    // А так - по типу стека
    {A := U^.Arcs;
    New(A);
    A^.Adj := V;
    A^.inf := Y;
    A^.Next := U^.Arcs;
    U^.Arcs := A;}
  end;
end;

function FindNode (G : PVertex; k : integer) : PVertex;
begin
  while ((G <> nil) and (G^.id <> k)) do
    G := G^.Next;
  FindNode := G;
end;

procedure DeleteNode(var G : PVertex);
var
  A,B : PArc;
begin
  A := G^.Arcs;
  while (A <> nil) do begin
    B := A^.Next;
    Dispose(A);
    A := B;
  end;
  Dispose(G);
end;

// Построение спискового представления графа
procedure ReadGraphL(var G : PVertex; S : string);
var
  F : text;
  i, j, N, M, K, Z : integer;
  U, V : PVertex;
  X : string;
begin
  assign(F, S);
  reset(F);
  // Считали число вершин
  readln(F, N);
  // Считываем информацию о вершинах
  for i := 1 to N do begin
    readln(F, X); // Информационные поля вершин нас не интересуют
    AddNode(G, i, 0);
  end;
  
  for i := 1 to N do begin
    // Считали строку "Дуги из вершины %i"
    readln(F);
    readln(F, M);
    U := FindNode(G, i);
    for j := 1 to M do begin
      readln(F, K, Z);
      V := FindNode(G, K);
      AddArc(U, V, Z);
    end;
  end;
  
  close(F);
end;

procedure DumpGraphL(G : PVertex);
var
  N : integer;
  Q : PVertex;
  A : PArc;
begin
  Q := G;
  N := 0;
  // Посчитали число вершин
  while (Q <> nil) do begin
    inc(N);
    Q := Q^.Next;
  end;
  write(N);
  write(chr($0D) + chr($0A));
  
  Q := G;
  while (Q <> nil) do begin
    write ('Вершина ' + IntToStr(Q^.id) + ': ');
    
    A := Q^.Arcs;
    while (A <> nil) do begin
      write (IntToStr(A^.Adj^.id) + ' ');
      A := A^.Next;
    end;
    write(chr($0D) + chr($0A));
    Q := Q^.Next;
  end;
end;

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
      //M[x,i] := -Y;
    end;
  end;
  
  close(F);
end;

procedure DumpGraphM(M : MGraph; N : integer);
var
  i,j : integer;
begin
  write(N);
  write(chr($0D) + chr($0A));
  
  for i := 1 to N do begin
    write('Вершина ' + IntToStr(i) + ': ');
    for j := 1 to N do
      if (M[i,j] > 0) then
        write(IntToStr(j) + ' ');
    write(chr($0D) + chr($0A));
  end;
end;

procedure DumpMaxWays(var MaxWays : TTInt; MaxWaysCnt,MaxC,MaxL : integer);
var
  i,j : integer;
begin
  for i := 1 to MaxWaysCnt do begin
    j := 1;
    write('Найден путь: ');
    while (MaxWays[i,j] <> 0) do begin
      write(MaxWays[i,j], ' ');
      inc(j);
    end;
    writeln('стоимостью ',MaxC,' длины ',MaxL);
  end;
end;

procedure FindMaxWaysM(
  var M : MGraph; 
  N, S, L, C : integer; 
  var MaxL, MaxC : integer;
  var used : TUsed;
  var MaxWays : TTInt;
  var way : TInt;
  var MaxWaysCnt : integer;
  var found : boolean);
var
  i : integer;
begin
  if ((MaxL <= L) and (MaxC <= C)) then begin
    if ((MaxL < L) or (MaxC < C)) then begin
      // Нужно забыть старые пути
      MaxL := L;
      MaxC := C;
      MaxWaysCnt := 0;
    end;
    found := true;
    inc(MaxWaysCnt);
    for i := 1 to L do
      MaxWays[MaxWaysCnt,i] := way[i];
    MaxWays[MaxWaysCnt,L+1] := 0;
  end;// else
    for i := 1 to N do
      if ((M[S, i] > 0) and (not used[i])) then begin
        used[i] := true;
        way[L+1] := i;
        FindMaxWaysM(M,N,i,L+1,C+M[S,i],MaxL,MaxC, used, MaxWays,way,MaxWaysCnt,found);
        used[i] := false;
        way[L+1] := 0;
      end;
end;

procedure FindAllMaxWaysM(var M : MGraph; N : integer);
var
  MaxL,MaxC,i,j : integer;
  
  found : boolean;
  way : TInt;
  used : TUsed;
  MaxWays : TTInt;
  MaxWaysCnt : integer;
begin
  MaxL := 0;
  MaxC := 0;
  MaxWaysCnt := 0;
  
  for i := 1 to N do begin
    used[i] := false;
    way[i] := 0;
    for j := 1 to N do
      MaxWays[i,j] := 0;
  end;
  
  for i := 1 to N do begin
    used[i] := true;
    way[1] := i;
    FindMaxWaysM(M,N,i,1,0,MaxL,MaxC,used,MaxWays,way,MaxWaysCnt,found);
    used[i] := false;
    // way[1] можно не сбрасывать
  end;
  
  if (not found) then
    writeln('NO WAI!')
  else
    DumpMaxWays(MaxWays, MaxWaysCnt, MaxC, MaxL);
end;

procedure FindMaxWaysL(
  G : PVertex; 
  S, L, C : integer; 
  var MaxL, MaxC : integer;
  var used : TUsed;
  var MaxWays : TTInt;
  var way : TInt;
  var MaxWaysCnt : integer;
  var found : boolean);
var
  i : integer;
  A : PArc;
begin
  if ((MaxL <= L) and (MaxC <= C)) then begin
    if ((MaxL < L) or (MaxC < C)) then begin
      // Нужно забыть старые пути
      MaxL := L;
      MaxC := C;
      MaxWaysCnt := 0;
    end;
    found := true;
    inc(MaxWaysCnt);
    for i := 1 to L do
      MaxWays[MaxWaysCnt,i] := way[i];
    MaxWays[MaxWaysCnt,L+1] := 0;
  end; // else
  
  A := G^.Arcs;
  while (A <> nil) do begin
    i := A^.Adj^.id;
    if ((A^.inf > 0) and (not used[i])) then begin
        used[i] := true;
        way[L+1] := i;
        FindMaxWaysL(A^.Adj,i,L+1,C+A^.inf,MaxL,MaxC, used, MaxWays,way,MaxWaysCnt,found);
        used[i] := false;
        way[L+1] := 0;
    end;
    A := A^.Next;
  end;
end;

procedure FindAllMaxWaysL(G : PVertex);
var
  MaxL,MaxC,i,j : integer;
  
  found : boolean;
  way : TInt;
  used : TUsed;
  MaxWays : TTInt;
  MaxWaysCnt : integer;
  Q : PVertex;
begin
  MaxL := 0;
  MaxC := 0;
  MaxWaysCnt := 0;
  
  for i := 1 to MaxN do begin
    used[i] := false;
    way[i] := 0;
    for j := 1 to 0 do
      MaxWays[i,j] := 0;
  end;
  
  Q := G;
  while (Q <> nil) do begin
    i := Q^.id;
    used[i] := true;
    way[1] := i;
    FindMaxWaysL(Q,i,1,0,MaxL,MaxC,used,MaxWays,way,MaxWaysCnt,found);
    used[i] := false;
    // way[1] можно не сбрасывать
    Q := Q^.Next;
  end;
  
  if (not found) then
    writeln('NO WAI!')
  else
    DumpMaxWays(MaxWays, MaxWaysCnt, MaxC, MaxL);
end;

var
  M : MGraph;
  N : integer;
  S : string;
  G : PVertex;
begin
  S := 'in25.txt';

  ReadGraphM(M, N, S);
  DumpGraphM(M, N);
  FindAllMaxWaysM(M, N);
  
  ReadGraphL(G, S);
  DumpGraphL(G);
  FindAllMaxWaysL(G);
end.
