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

begin
end.