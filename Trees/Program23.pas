program P12;

uses
  Trees;

const
  MaxN = 10;

type
  IntSet = set of byte;


procedure InsertX(var Node : PNode; Prev : PNode; X : integer);
begin
  if (Node = nil) then begin
    New(Node);
    Node^.Data := X;
    Node^.Parent := Prev;
  end else if (Node^.Data > X) then
    InsertX(Node^.Left, Node, X)
  else if (Node^.Data < X) then
    InsertX(Node^.Right, Node, X);
  // Дублирующиеся значения не включаем
end;

function GenerateSetAndTree(var P : PNode) : IntSet;
var
  Res : IntSet;
  i,x : integer;
begin
  Res := [];
  i := 1;
  while (i <= MaxN) do begin
    X := Random(255);
    if (not (X in Res)) then begin
      Res += [X];
      InsertX(P, nil, X);
      inc(i);
    end;
  end;
  GenerateSetAndTree := Res;
end;

procedure MergeTrees(var P1 : Pnode; P2 : PNode);
begin
  if (P2 <> nil) then begin
    InsertX(P1, nil, P2^.Data);
    
    MergeTrees(P1, P2^.Left);
    MergeTrees(P1, P2^.Right);
  end;  
end;

procedure FreeTree(var P : PNode);
begin
  if (P <> nil) then begin
    FreeTree(P^.Left);
    FreeTree(P^.Right);
    Dispose(P);
  end;
end;

var
  S1, S2 : IntSet;
  P1, P2 : PNode;
begin
  S1 := GenerateSetAndTree(P1);
  S2 := GenerateSetAndTree(P2);

  PrintTree(P1);
  readln;
  PrintTree(P2);
  readln;

  MergeTrees(P1, P2);
  PrintTree(P1);
  
  FreeTree(P1);
  FreeTree(P2);

end.