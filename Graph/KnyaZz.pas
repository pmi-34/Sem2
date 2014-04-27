unit KnyaZz;

type
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
  
  MGraph = array [,] of integer;
  IArray = array of integer;
  VSet = set of integer;

procedure AddNode(var graph : PVertex; n,x : integer);
begin
  if (graph = nil) then begin
    New(graph);
    graph^.id := n;
    graph^.inf := x;
  end else
    AddNode(graph^.Next, n, x);
end;

procedure AddArc(var u, v : PVertex; Y : integer);
begin
end;

function FindNode (G : PVertex; k : integer) : PVertex;
begin
  while ((G <> nil) and (G^.id <> k)) do
    G := G^.Next;
  FindNode := G;
end;

// Построение спискового представления графа
// БЫЛО НА ПАРЕ, БЛЕАТЬ
procedure Graph(var G : PVertex);
var
  F : text;
  i, j, N, M, X, K : integer;
  S : string;
  U, V : PVertex;
begin
  assign(F, 'input.txt');
  reset(F);
  // Считали число вершин
  readln(F, N);
  // Считываем информацию о вершинах
  for i := 1 to N do begin
    readln(F, X);
    AddNode(G, i, X);
  end;
  
  for i := 1 to N do begin
    // Считали строку "Дуги из вершины %i"
    readln(F);
    readln(F, M);
    U := FindNode(G, i);
    for j := 1 to M do begin
      readln(F, K, X);
      V := FindNode(G, K);
      AddArc(U, V, X);
    end;
  end;
  
  close(F);
end;

{итеративный алгоритм поиска количества компонент связности}
{Андреева - автор учебника}
{ЗАМЕТКИ ПО МОТИВАМ, НЕ РАБ-Т!}
function FindK (var U, V : integer; var Us :array of boolean) : integer;
var
  used : array of integer;
  ks, kol : integer;
begin
  if ((used[u] = 0) and (used[v] = 0)) then begin
    inc(ks);
    inc(kol);
    used[u] := ks;
    used[v] := ks;
  end else if ((used[u] = ks) and (used[v] = 0)) OR
              ((used[v] = ks) and (used[u] = 0)) then begin
  end else if (used[u] = used[v]) then begin
  end else begin
    dec(kol);
    // Найти все значения ks в used и заменить
  end;
  FindK := kol;
end;

{Овчинниковой алгоритм Дейкстры}
procedure D (W : MGraph; n,s: integer; var L : IArray);
var
  i,p,x : Byte;
  H : set of byte;
  mindist : integer;
begin
  H := [];
  for i := 1 to N do begin
    L[i] := MAXINT;
    H := H + [i];
  end;
  L[S] := 0;
  H := H -[S];
  P := S;
  
  for i := 1 to N-1 do begin
    for x := 1 to n do
      if (W[p,x] <> 0) then
        if(l[x] > l[p] + w[p,x]) then
          l[x] := l[p] + w[p,x];
          
    mindist := MAXINT;
    
    for x := 1 to N do
      if (x in H) and (mindist > l[x]) then begin
        mindist := l[x];
        p := x;
      end;
      
    H := H - [p];
  end;
end;

{Овчинниковой алгоритм Прима}
procedure Prime(G : MGraph; N : integer);
var
  Res : string;
  sel, not_sel : set of integer;
  i, j, minves, tekmin, mini, minj : integer;
begin
  res := '';
  sel := [1];
  not_sel := [];
  
  for i := 1 to N do
    not_sel := not_sel + [i];
    
  minves := 0;
  while not_sel <> [] do begin
    tekMin := MAXINT;
    for i := 1 to N do
      for j := 1 to N do
        if ((j in not_sel) and (i in sel)) then begin
          if (tekMin > G[i,j]) then begin
            tekMin := G[i,j];
            mini := i;
            minj := j;
          end;
        end else if ((j in sel) and (i in not_sel)) then begin
          if (tekMin > G[i,j]) then begin
            tekMin := G[i,j];
            mini := i;
            minj := j;
          end;
        end;
          
    if (mini in not_sel) then begin
      sel := sel + [mini];
      not_sel := not_sel - [mini];
    end;
    
    if (minj in not_sel) then begin
      sel := sel + [minj];
      not_sel := not_sel - [minj];
    end;
    minves := minves + tekmin;
    res := res {+ S1 + ' ' + S2};
  end;
end;

{Овчинниковой топологическая сортировка}
procedure TopologycalSort(var G : MGraph; N : integer; var X : IArray);
begin
  {Да вот хрен, нету}
end;

begin
end.
