uses PT4;

type
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
    // ������ �� ���� �������
    if (u^.Arcs = nil) then
      NewArc(U^.Arcs, V, Y)
    else begin
      A := u^.Arcs;
      while (A^.Next <> nil) do
        A := A^.Next;
      NewArc(A^.Next, V, Y);
    end;
    // � ��� - �� ���� �����
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

// ���������� ���������� ������������� �����
procedure ReadGraphL(var G : PVertex; S : string);
var
  F : text;
  i, j, N, M, K, Z : integer;
  U, V : PVertex;
  X : string;
begin
  assign(F, S);
  reset(F);
  // ������� ����� ������
  readln(F, N);
  // ��������� ���������� � ��������
  for i := 1 to N do begin
    readln(F, X); // �������������� ���� ������ ��� �� ����������
    AddNode(G, i, 0);
  end;
  
  for i := 1 to N do begin
    // ������� ������ "���� �� ������� %i"
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
  // ��������� ����� ������
  while (Q <> nil) do begin
    inc(N);
    Q := Q^.Next;
  end;
  Show(N);
  Show(chr($0D) + chr($0A));
  
  Q := G;
  while (Q <> nil) do begin
    Show ('������� ' + IntToStr(Q^.id) + ': ');
    
    A := Q^.Arcs;
    while (A <> nil) do begin
      Show(IntToStr(A^.Adj^.id) + ' ');
      A := A^.Next;
    end;
    Show(chr($0D) + chr($0A));
    Q := Q^.Next;
  end;
end;

procedure TopoSortL(var G : PVertex);
var
  Q,P,Prev : PVertex;
  A : PArc;
  F : boolean;
begin
  Q := G;
  Prev := nil;
  while (Q <> nil) do begin
    P := G;
    // ����� �� ����� �� ����� �������� ����
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
      
    if (not F) then begin
      write(Q^.id);
      if (Prev <> nil) then
        Prev^.Next := Q^.Next
      else
        G := Q^.Next;
      DeleteNode(Q);
      Q := G;
      Prev := nil;
    end else begin
      Prev := Q;
      Q := Q^.Next;
    end;
  end;
end;

procedure ReadGraphM(var M : MGraph; var N : integer; S : string);
var
  F : text;
  i, j, X, Y, K : integer;
begin
  assign(F, S);
  reset(F);
  // ������� ����� ������
  readln(F, N);
  // ������� ������ ��� ������
  SetLength(M, N+1, N+1);
  for i := 1 to N do
    for j := 1 to N do
      M[i,j] := 0;
  
  // ���������� �������� �����
  for i := 1 to N do
    readln(F);
  
  // ��������� ���������� � ��������
  for i := 1 to N do begin
    // ���������� �����
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

procedure DumpGraphM(M : MGraph; N : integer);
var
  i,j : integer;
begin
  Show(N);
  
  for i := 1 to N do begin
    Show('������� ' + IntToStr(i) + ': ');
    for j := 1 to N do
      if (M[i,j] > 0) then
        Show(IntToStr(j) + ' ');
    Show(chr($0D) + chr($0A));
  end;
end;

procedure TopoSortM(var M : MGraph; N : integer);
var
  X : VSet;
  i,j : integer;
  F : boolean;
begin
  for i := 1 to N do
    X += [i];
    
  while (X <> []) do begin
    // ���� ������� ��� �������� ��� � �������� � X
    i := 0;
    F := false;
    while ((i < N) AND (not F)) do begin
      inc(i);
      if (i in X) then begin
        j := 1;
        F := true; // ��� �������� ���
        while ((j <= N) AND (F)) do begin
          if (M[i,j] < 0) then
            F := false;
          inc(j);
        end;
      end;
    end;
    
    if (F) then begin
      // ������� �����, ��������� �� �������
      for j := 1 to N do
        M[j,i] := 0;
      // � ������ �������� ����� �� ������� 1 � ����
      // ����� ������� �� ������ ����� ���������� ���������
      M[i,1] := -1;
      X -= [i];
      write(i);
    end;
  end;
end;

var
  M : MGraph;
  N : integer;
  S : string;
  G : PVertex;
begin
  Task('GraphWork11');
  read(S);
  {ReadGraphM(M, N, S);
  DumpGraphM(M, N);
  TopoSortM(M, N);}
  ReadGraphL(G, S);
  DumpGraphL(G);
  TopoSortL(G);
end.

