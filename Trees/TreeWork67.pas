uses PT4;

procedure InsertX(var Node : PNode; X : integer);
begin
  if (Node = nil) then begin
    New(Node);
    Node^.Data := X;
  end else if (Node^.Data > X) then
    InsertX(Node^.Left, X)
  else
    InsertX(Node^.Right, X);
end;

procedure CreateTree(var P : PNode; S : string);
var
  F : text;
  X : integer;
begin
  assign(F, S);
  reset(F);
  while (not SeekEof(F)) do begin
    read(F, X);
    InsertX(P, X);
  end;
  close(F);
end;

{большой правый поворот}
procedure RotateRL(var R : PNode);
var
  P : PNode;
begin
  P := R^.Right^.Left;
  R^.Right^.Left := P^.Right;
  
  P^.Right := R^.Right;
  R^.Right := P^.Left;
  
  P^.Left := R;
  R := P;
end;

{высота дерева, корень на первом уровне}
function TreeH(Node : PNode) : integer;
var
  L, R : integer;
begin
  if (Node = nil) then
    TreeH := 0
  else begin
    L := TreeH(Node^.Left);
    R := TreeH(Node^.Right);
    if (L > R) then
      TreeH := L + 1
    else
      TreeH := R + 1;
  end;
end;

{проверка AVL-сбалансированности}
{автоматически выполнит указанный поворот}
function CheckAndRotateAVL(var R : PNode) : boolean;
var
  G : boolean;
begin
  G := false;
  if (R <> nil) then begin
    G := CheckAndRotateAVL(R^.Left);
    
    if (not G) then
      G := CheckAndRotateAVL(R^.Right);
    
    if (TreeH(R^.Right) - TreeH(R^.Left) > 1) and (not G) then begin
      RotateRL(R);
      G := true;
    end;      
  end;
  CheckAndRotateAVL := G;
end;

var
  P : PNode;
  S : string;
begin
  Task('TreeWork67');
  read(S);
  CreateTree(P, S);
  
  CheckAndRotateAVL(P);
  write(P);
end.
