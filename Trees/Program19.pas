program P18 (input, output);

type
  PNode = ^TNode;
  TNode = record 
    Data : string[6];
    Count : integer;
    Left, Right : PNode;
  end;

procedure Create(var R : PNode; X : string);
begin
  New(R);
  R^.Data := X;
  R^.Count := 1;
  R^.Left := nil;
  R^.Right := nil;
end;

{вставка}
procedure InsertX(var R : PNode; X : string);
var
  Q : PNode;
  F : boolean;
begin  
  if (R = nil) then
    Create(R, X)
  else begin
    Q := R;
    F := false;
    repeat
      if (Q^.Data < X) then begin
        if (Q^.Left <> nil) then
          Q := Q^.Left
        else begin
          Create(Q^.Left, X);
          F := true;
        end;          
      end else if (Q^.Data > X) then begin
        if (Q^.Right <> nil) then
          Q := Q^.Right
        else begin
          Create(Q^.Right, X);
          F := true
        end;
      end else begin // Q^.Data = X
        inc(Q^.Count);
        F := true;
      end;
    until F;
  end;
end;

{поиск максимального элемента}
function FindMax(Node : PNode) : PNode;
begin
  while Node^.Right <> nil do
    Node := Node^.Right;
  FindMax := Node;
end;

{удаление}
procedure DeleteP(var Node, P : PNode);
var
  Q : PNode;
begin
  if ((Node <> nil) and (P <> nil)) then begin
    if (Node = P) then begin
      Q := P;
      // Ни одного потомка
      if (Node^.Left = Node^.Right) then begin
        Node := nil;
        Dispose(Q);
      // Только правый
      end else if (Node^.Left = nil) then begin
        Node := Node^.Right;
        Dispose(Q);
      // Только левый
      end else if (Node^.Right = nil) then begin
        Node := Node^.Left;
        Dispose(Q);
      // Есть оба, нужна замена
      end else begin
        Q := FindMax(Node^.Left);
        Node^.Data := Q^.Data;
        Node^.Count := Q^.Count;
        DeleteP(Node^.Left, Q);
      end;
      P := Node;
    end else if (Node^.Data < P^.Data) then
      DeleteP(Node^.Left, P)
    else
      DeleteP(Node^.Right, P);
  end;
end;

{концевой обход, LRN}
procedure FreeTree(var Root : PNode);
begin
  if (Root <> nil) then begin
    FreeTree(Root^.Left);
    FreeTree(Root^.Right);
    Dispose(Root);
    Root := nil;
  end;
end;

procedure CreateTree(var P : PNode);
var
  F : text;
  X : string;
begin
  assign(F, 'in.txt');
  reset(F);
    
  P := nil;  
    
  while (not SeekEof(F)) do begin
    read(F, X);
    InsertX(P, X);
  end;
    
  close(F);
end;

{зеркально-симметричный обратный обход, RNL}
procedure DumpTree(P : PNode; L : integer);
begin
  if (P <> nil) then begin
    DumpTree(P^.Right, L+1);
    writeln(' ':L*4, P^.Data:8, '(', P^.Count, ')');
    DumpTree(P^.Left, L+1);
  end;
end;

{зеркально-симметричный обратный обход, RNL}
procedure WalkRNL(var Root, Node : PNode; N : integer);
begin
  if (Node <> nil) then begin
    WalkRNL(Root, Node^.Right, N);
    
    while (Node <> nil) and (Node^.Count = N) do begin
      DeleteP(Root, Node);
      DumpTree(Root, 0);
      writeln('----------------');
    end;

    if (Node <> nil) then
      WalkRNL(Root, Node^.Left, N);
  end;
end;

var
  P : PNode;
  N : integer;
  out : textfile;
begin
  CreateTree(P);

  DumpTree(P, 0);
  
  write('Введите число вхождений: ');
  readln(N);
  
  out := output;
  
  assign(output, 'out.txt');
  
  WalkRNL(P, P, N);
  
  writeln('Итоговое дерево:');
  DumpTree(P, 0);
  close(output);
  
  output := out;
  
  FreeTree(P);
end.
