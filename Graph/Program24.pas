program P24;

type
  PVertex = ^TVertex;
  PArc = ^TArc;
  MGraph = array [,] of integer;
  
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

procedure AddNodeL(var graph : PVertex; n,x : integer);
begin
  if (graph = nil) then begin
    New(graph);
    graph^.id := n;
    graph^.inf := x;
  end else
    AddNodeL(graph^.Next, n, x);
end;

procedure AddArcL(var u, v : PVertex; Y : integer);
var
  A : PArc;
begin
  if ((u <> nil) and (v <> nil)) then begin
    New(A);
    A^.inf := Y;
    A^.Adj := V;
    A^.Next := U^.Arcs;
    U^.Arcs := A;
  end else
    writeln('AddArc : недопустимые входные данные!');
end;

function FindNodeL(G : PVertex; k : integer) : PVertex;
begin
  while ((G <> nil) and (G^.id <> k)) do
    G := G^.Next;
  FindNodeL := G;
end;

procedure ReadGraphL(var G : PVertex);
var
  F : text;
  i, N, X : integer;
  U, V : PVertex;
begin
  assign(F, 'in24.txt');
  reset(F);
  // Считали число вершин
  readln(F, N);
  
  // Создаем вершины
  for i := 1 to N do
    AddNodeL(G, i, -1);
  
  // Считываем информацию о вершинах
  for i := 1 to N do begin
    read(F, X);
    U := FindNodeL(G, i);
    U^.inf := X;
    while (not SeekEoln(F)) do begin
      read(F, X);
      V := FindNodeL(G, X);
      AddArcL(U, V, -1);
    end;
    readln(F);
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
  writeln(N);
  
  Q := G;
  while (Q <> nil) do begin
    write (Q^.inf, ' ');
    
    A := Q^.Arcs;
    while (A <> nil) do begin
      write(A^.Adj^.id, ' ');
      A := A^.Next;
    end;
    writeln;
    Q := Q^.Next;
  end;
end;

procedure ReadGraphM(var M : MGraph; var N : integer);
var
  F : text;
  i, X : integer;
begin
  assign(F, 'in24.txt');
  reset(F);
  // Считали число вершин
  readln(F, N);
  // Выделим память под массив
  SetLength(M, N+1, N+1);
  
  // Считываем информацию о вершинах
  for i := 1 to N do begin
    read(F, X);
    M[i,0] := X;
    while (not SeekEoln(F)) do begin
      read(F, X);
      M[i,X] := 1;
      M[X,i] := -1;
    end;
    readln(F);
  end;
  
  close(F);
end;

procedure DumpGraphM(M : MGraph; N : integer);
var
  i,j : integer;
begin
  writeln(N);
  
  for i := 1 to N do begin
    write(M[i,0], ' ');
    for j := 1 to N do
      if (M[i,j] = 1) then
        write(j, ' ');
    writeln;
  end;
end;

{только входящие дуги -> входящие есть, исходящих - нет}
procedure FindInputL(G : PVertex);
var
  Q,P : PVertex;
  A : PArc;
  F : boolean;
begin
  Q := G;
  while (Q <> nil) do begin
    if (Q^.Arcs = nil) then begin
      P := G;
      // Нужно найти хотя бы одну входящую дугу
      F := false;
      while ((P <> nil) and (not F)) do begin
        A := P^.Arcs;
        while (A <> nil) do begin
          if (A^.Adj = Q) then
            F := true;
          A := A^.Next;
        end;
        P := P^.Next;
      end;
      if (F) then
        write('Вершина ', Q^.id, ' [', Q^.inf, '] имеет только входящие дуги');
    end;
    
    Q := Q^.Next;
  end;
end;


{только исходящие дуги -> исходящие есть, входящих - нет}
procedure FindOutputL(G : PVertex);
var
  Q,P : PVertex;
  A : PArc;
  F : boolean;
begin
  Q := G;
  while (Q <> nil) do begin
    if (Q^.Arcs <> nil) then begin
      P := G;
      // Нужно не найти ни одной входящей дуги
      F := false;
      while ((P <> nil) and (not F)) do begin
        A := P^.Arcs;
        while (A <> nil) do begin
          if (A^.Adj = Q) then
            F := true;
          A := A^.Next;
        end;
        P := P^.Next;
      end;
      if (not F) then
        write('Вершина ', Q^.id, ' [', Q^.inf, '] имеет только исходящие дуги');
    end;
    
    Q := Q^.Next;
  end;
end;

procedure FindInputM(var M : MGraph; N : integer);
var
  i,j : integer;
  F,L : boolean;
begin
  for i := 1 to N do begin
    j := 1;
    F := false; // Есть ли исходящие дуги
    L := false; // Есть ли входящие дуги
    while ((J <= N) and (not F)) do begin
      if (M[i,j] = 1) then
        F := true
      else if (M[i,j] = -1) then
        L := true;
      inc(J);
    end;
    if ((not F) and L) then
      write('Вершина ', i, ' [', M[i,0], '] имеет только входящие дуги');
  end;
end;

procedure FindOutputM(var M : MGraph; N : integer);
var
  i,j : integer;
  F,L : boolean;
begin
  for i := 1 to N do begin
    j := 1;
    F := false; // Есть ли исходящие дуги
    L := false; // Есть ли входящие дуги
    while ((J <= N) and (not L)) do begin
      if (M[i,j] = 1) then
        F := true
      else if (M[i,j] = -1) then
        L := true;
      inc(J);
    end;
    if ((not L) and F) then
      write('Вершина ', i, ' [', M[i,0], '] имеет только исходящие дуги');
  end;
end;

var
  G : PVertex;
  M : MGraph;
  N : integer;
begin
  ReadGraphM(M, N);
  DumpGraphM(M, N);
  
  FindInputM(M, N);
  FindOutputM(M, N);
end.
