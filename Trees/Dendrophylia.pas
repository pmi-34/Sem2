unit Dendrophylia;

{
  ������� �������� ����������
  V4.0, 14.04.2014
}

uses PT4;

// ��� ��������� ��������
type
  Rotation = procedure (var R : PNode);

{--- ������ ---}

{�������� �������}

{����� ����-�����-������}
procedure WalkLRN(Node : PNode);
begin
  if (Node <> nil) then begin
    WalkLRN(Node^.Left);
    WalkLRN(Node^.Right);
    write(Node^.Data);
  end;
end;

{����� ����-������-�����}
procedure WalkLNR(Node :PNode);
begin
  if (Node <> nil) then begin
    WalkLNR(Node^.Left);
    write(Node^.Data);
    WalkLNR(Node^.Right);
  end;
end;

{����� �����-������-����}
procedure WalkRNL(Node :PNode);
begin
  if (Node <> nil) then begin
    WalkRNL(Node^.Right);
    write(Node^.Data);
    WalkRNL(Node^.Left);
  end;
end;

{����� ������-����-�����}
procedure WalkNLR(Node : PNode);
begin
  if (Node <> nil) then begin
    write(Node^.Data);
    WalkNLR(Node^.Left);
    WalkNLR(Node^.Right);
  end;
end;

{����� ������� ����� �������}
procedure WalkLeavesLR(Node : PNode);
begin
  if (Node <> nil) then begin
    if (Node^.Left <> Node^.Right) then begin
      WalkLeavesLR(Node^.Left);
      WalkLeavesLR(Node^.Right);
    end else write(Node^.Data);
  end;
end;

{����� ������� ������ ������}
procedure WalkLeavesRL(Node : PNode);
begin
  if (Node <> nil) then begin
    if (Node^.Left <> Node^.Right) then begin
      WalkLeavesRL(Node^.Right);
      WalkLeavesRL(Node^.Left);
    end else write(Node^.Data);
  end;
end;

{����� ������ �� K-�� ������ ����� �������}
procedure WalkK(Node : PNode; K : integer);
begin
  if (Node <> nil) then begin
    if (K = 0) then
      write(Node^.Data)
    else if (K > 0) then begin
      WalkK(Node^.Left, K-1);
      WalkK(Node^.Right, K-1);
    end;
  end;
end;

{����� ������ � ������������� ������}

{������ ���� ((3)4)5(6))7(8(9)), ��� ������� ������}
function WalkLNRStr(Root : PNode) : string;
begin
  if (Root <> nil) then begin
    WalkLNRStr := '';
    if (Root^.Left <> nil) then
      WalkLNRStr += '(' + WalkLNRStr(Root^.Left) + ')';
    WalkLNRStr += IntToStr(Root^.Data);
    if (Root^.Right <> nil) then
      WalkLNRStr += '(' + WalkLNRStr(Root^.Right) + ')';
  end else
    WalkLNRStr := '';
end;

{������ ���� 2(3,4(5,6))}
function WalkNLRStr(Root : PNode) : string;
begin
  if (Root <> nil) then begin
    WalkNLRStr := IntToStr(Root^.Data);
    if (Root^.Left <> Root^.Right) then begin
      WalkNLRStr += '(';
      if (Root^.Left <> nil) then
        WalkNLRStr += WalkNLRStr(Root^.Left);
      if (Root^.Right <> nil) then begin
        WalkNLRStr += ',' + WalkNLRStr(Root^.Right);  
      end;
      WalkNLRStr += ')';
    end;
  end;
end;

{��������}
{�������, ��� � ������ ���� �������?}

function TreeH(Node : PNode) : integer; forward;

{�������� AVL-������������������}
{������������� �������� ��������� �������}
procedure CheckAVL(var R : PNode; F : Rotation);
begin
  if (R <> nil) then begin
    CheckAVL(R^.Left, F);
    CheckAVL(R^.Right, F);
    
    if (Abs(TreeH(R^.Left) - TreeH(R^.Right)) > 1) then
      F(R);
  end;
end;

{����� ������ �������}
procedure RotateLL(var R : PNode);
var
  P : PNode;
begin
  P := R^.Left;
  R^.Left := P^.Right;
  P^.Right := R;
  R := P;
end;

{����� ����� �������}
procedure RotateRR(var R : PNode);
var
  P : PNode;
begin
  P := R^.Right;
  R^.Right := P^.Left;
  P^.Left := R;
  R := P;
end;

{������� ����� �������}
procedure RotateLR(var R : PNode);
var
  P : PNode;
begin
  P := R^.Left^.Right;
  R^.Left^.Right := P^.Left;
  
  P^.Left := R^.Left;
  R^.Left := P^.Right;
  
  P^.Right := R;
  R := P;
end;

{������� ������ �������}
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

{������� ������ ����}

{����� ����-������-�����}
procedure WalkCommonLNR(Node : PNode);
begin
  if (Node <> nil) then begin
    WalkCommonLNR(Node^.Left);
    write(Node^.Data);
    Node := Node^.Left;
    if (Node <> nil) then
      Node := Node^.Right;
      
    while (Node <> nil) do begin
      WalkCommonLNR(Node);
      Node := Node^.Right;
    end;
  end;
end;

{�������������� ��������� � ������ ������ ����}
{P - ����� ���������, Q - ������ ���������}
procedure ConvertFromBin(P,Q : PNode);
begin
  if (Q <> nil) then begin
    if (Q^.Left = nil) then begin
      Q^.Left := Q^.Right;
      Q^.Right := nil;
    end;
    ConvertFromBin(Q^.Left, Q^.Right);
    Q^.Right := nil;
  end;
  
  if (P <> nil) then begin
    if (P^.Left = nil) then begin
      P^.Left := P^.Right;
      P^.Right := nil;
    end;
    ConvertFromBin(P^.Left, P^.Right);
    P^.Right := Q;
  end;
end;

{--- �������, �����, �������� ---}

{�����, �� ���� ������ ��������� ����� ���������� ������, ������������ ���������}
function FindX(Node : PNode; X : integer; var N : integer) : PNode;
begin
  if (Node = nil) then
    FindX := nil
  else begin
    inc(N);
    if (Node^.Data = X) then
      FindX := Node
    else if (Node^.Data > X) then
      FindX := FindX(Node^.Left, X, N)
    else
      FindX := FindX(Node^.Right, X, N);
  end;
end;

{����� ����/���}
function FindX(Node : PNode; X : integer) : boolean;
{var
  N : integer;}
begin
  if (Node = nil) then
    FindX := false
  else if (Node^.Data = X) then
    FindX := true
  else if (Node^.Data > X) then
    FindX := FindX(Node^.Left, X)
  else
    FindX := FindX(Node^.Right, X);

  {FindX := FindX(Node, X, N) <> nil;}
end;

{����� ������������� ��������}
function FindMax(Node : PNode) : PNode;
begin
  while Node^.Right <> nil do
    Node := Node^.Right;
  FindMax := Node;
end;

function FindMaxN(Node : PNode) : integer;
begin
  FindMaxN := FindMax(Node)^.Data;
end;

{����� ������������ ��������}
function FindMin(Node : PNode) : PNode;
begin
  while Node^.Left <> nil do
    Node := Node^.Left;
  FindMin := Node;
end;

function FindMinN(Node : PNode) : integer;
begin
  FindMinN := FindMin(Node)^.Data;
end;
{����� � ��������������� ������}
function FindU(Node,X : PNode) : boolean;
begin
  if (Node = nil) then
    FindU := false
  else if (Node = X) then
    FindU := true
  else
    FindU := FindU(Node^.Right,X) or FindU(Node^.Left, X);
end;

{����� ���������� ������ ����� ��� P � Q}
function FindCommon(R, P,Q : PNode) : PNode;
begin
  if (FindU(R^.Left, P) and FindU(R^.Left, Q)) then
    FindCommon := FindCommon(R^.Left, P,Q)
  else if (FindU(R^.Right, P) and FindU(R^.Right, Q)) then
    FindCommon := FindCommon(R^.Right, P,Q)
  else
    FindCommon := R;
end;

{�������}
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

{�������� � ������� ������}
{������������ ������������ ������� �� ������ ���������}
procedure DeleteP(var Node : PNode; P : PNode);
var
  Q : PNode;
begin
  if ((Node <> nil) and (P <> nil)) then begin
    if (Node = P) then begin
      if (Node^.Left = Node^.Right) then begin
        Dispose(P);
        Node := nil;
      end else if (Node^.Left = nil) then begin
        Node := Node^.Right;
        Dispose(P);
      end else if (Node^.Right = nil) then begin
        Node := Node^.Left;
        Dispose(P);
      end else begin
        Q := FindMax(Node^.Left);
        Node^.Data := Q^.Data;
        DeleteP(Node^.Left, Q);
      end;
    end else if (Node^.Data > P^.Data) then
      DeleteP(Node^.Left, P)
    else
      DeleteP(Node^.Right, P);
  end;
end;

{�������� � ������� ������}
{�����, ������}
{������������ ����������� ������� �� ������� ���������}
procedure Delete (var Root : PNode; X : PNode);
var 
  Q : PNode;
  procedure Del(var R : PNode);
  begin
    if (R^.Left <> nil) then 
      Del(R^.left)
    else begin
      Q^.Data := R^.Data;
      Q := R;
      Q := R^.Right;
    end
  end;
begin
  if (Root = nil) then 
    write('����� ������� � ������ ���')
  else if (X^.Data < Root^.Data) then 
    Delete(Root^.Left, X)
  else if (X^.Data > Root^.Data) then 
    Delete(Root^.Right, X)
  else begin
    Q := Root;
    if (Q^.Right = nil) then 
      Root := Q^.Left
    else if (Q^.Left = nil) then 
      Root := Q^.Right
    else 
      Del(Q^.Right);
    Dispose(Q);
  end;
end;

{�������� � ������ � �������� ������}
{���������� ���������, ��� - ������ ������}
procedure DeleteX(var Node : PNode); forward;

procedure DoDeleteX(var Node : PNode);
var
  P, Q : PNode;
  {X, Y, Z : integer;}
begin
  if (Node <> nil) then begin
    if (Node^.Left = Node^.Right) then begin
      // ������ ������� �� ������ �����
      Dispose(Node);
      Node := nil;
    end else begin
      P := Node;
      // ���� �����-�� �� ����������� �����
      if (Node^.Left = nil) then begin
        Node := Node^.Right;
        Node^.Parent := P^.Parent;
        Dispose(P);
      end else if (Node^.Right = nil) then begin
        Node := Node^.Left;
        Node^.Parent := P^.Parent;
        Dispose(P);
      end else begin
        // ��� ��������� �� �����, ����� ������
        Q := FindMax(P^.Left);
        P^.Data := Q^.Data;
        DeleteX(Q);
      end;
    end;
  end;
end;

{��������������� �����-������� � ���������� �������}
procedure DeleteX(var Node : PNode);
begin
  if (Node^.Parent <> nil) then begin
    if (Node^.Parent^.Left = Node) then
      DoDeleteX(Node^.Parent^.Left)
    else
      DoDeleteX(Node^.Parent^.Right);
  end else
    DoDeleteX(Node);
end;

{����������� ������ � ������ � �������� ������}
procedure ConvertToRTree(Node, Prev : PNode);
begin
  if (Node <> nil) then begin
    Node^.Parent := Prev;
    ConvertToRTree(Node^.Left, Node);
    ConvertToRTree(Node^.Right, Node);
  end;
end;

{����������� ������}
procedure CopyTree(Root : PNode; var NewRoot : PNode);
begin
  if (Root <> nil) then begin
    New(NewRoot);
    NewRoot^.Data := Root^.Data;
    CopyTree(Root^.Left, NewRoot^.Left);
    CopyTree(Root^.Right, NewRoot^.Right);
  end;
end;

{����������� ������}
procedure FreeTree(var Root : PNode);
begin
  if (Root <> nil) then begin
    FreeTree(Root^.Left);
    FreeTree(Root^.Right);
    Dispose(Root);
    Root := nil;
  end;
end;

{�������� �������� ����������������� ������}
procedure CreateITree(var Root : PNode; N : integer);
begin
  if (N > 0) then begin
    New(Root);
    read(Root^.Data);
    CreateITree(Root^.Left, N div 2);
    CreateITree(Root^.Right, N - 1 - (N div 2));
  end;
end;

{�������� ������ �� ������}
{������ ���� 2(3,4(5,6))}
procedure CreateNLRTree(var Root : PNode; S : string; var I : integer);
begin
  if (I <= length(S)) and (S[i] <> ',') and (S[i] <> ')') then begin
    New(Root);
    Root^.Data := ord(S[I]) - $30;
    inc(I);
    if ((I < length(S)) and (S[i] = '(')) then begin
      // ��������� ������
      inc(i);
      CreateNLRTree(Root^.Left, S, I);
      if ((I < length(S)) and (S[i] = ',')) then begin
        // ��������� �������
        inc(i);
        CreateNLRTree(Root^.Right, S, I);
      end;
      // ��������� ����������� ������
      inc(i);
    end;
  end;
end;

{�������� ������ �� ������}
{�� ��, ��� � ����������, � ��������� ������������ �������!}
{���� �� ����, ������!}
{������ ���� 2(3,4(5,6))}
procedure TreeAbraman(var P : PNode; var S : String);
begin
  New(P);
  P^.Data := ord(S[1]) - ord('0');
  P^.Left := nil;
  P^.Right := nil;
  Delete(S, 1, 1);

  if (Length(S) > 0) then
    if (S[1] = '(') then begin
      Delete(S, 1, 1);

      if (S[1] <> ',') then
        TreeAbraman(P^.Left, S);
        
      if (S[1] = ',') then begin
        Delete(S, 1, 1);
        TreeAbraman(P^.Right, S);
      end;

      Delete(S, 1, 1);
    end;
end;

{������ ���� ((5)4(6))5(8)}
procedure CreateLNRTree(var Root : PNode; S : string; var I : integer);
begin
  if (I <= length(S)) then begin
    New(Root);
    if (S[i] = '(') then begin
      // ��������� ������
      inc(i);
      CreateLNRTree(Root^.Left, S, I);
      inc(i);
    end;
    
    Root^.Data := 0;
    
    while ((I <= length(S)) and (S[i] <> '(') and (S[i] <> ')')) do begin
      Root^.Data := Root^.Data*10 + ord(S[i]) - $30;
      inc(i);
    end;

    if ((I < length(S)) and (S[i] = '(')) then begin
      // ��������� ������
      inc(i);
      CreateLNRTree(Root^.Right, S, I);
      inc(i);
    end;
  end;
end;

{�� ��, ��� � ����}
{���� �� ����, ������}
procedure Tree1(var P : PNode; var S : string);
  function TakeNum(var S : string) : integer;
  var
    R : integer;
  begin
    R := 0;
    while ((S <> '') and (S[1] <> '(') and (S[1] <> ')')) do begin
      R := R*10 + ord(S[1]) - ord('0');
      Delete(S, 1, 1);
    end;
    TakeNum := R;
  end;

begin
  if (S[1] <> '(') then
    P := nil
  else begin
    New(P);
    Delete(S, 1, 1);
    Tree1(P^.Left, S);
    P^.Data := TakeNum(S);
    Tree1(P^.Right, S);
    Delete(S, 1, 1);
  end;
end;

{�������� ���� �� ��� ���}
function SignToCode(X : integer) : integer;
begin
  case chr(X) of
    '+': X := -1;
    '-': X := -2;
    '*': X := -3;
    '/': X := -4;
    '0'..'9': X := X - $30;
  end;
  SignToCode := X;
end;

{���������}
{����� � ����� -1 - ��������, -2 - ���������, -3 - ���������, -4 - �������}

{�������� ������ ���������}
{������ ���� ((8-5)+(6/4))}
procedure CreateExprTree(var Root : PNode; S : string; var I : integer);
begin
  if (I <= length(S)) then begin
    New(Root);
    if (S[i] = '(') then begin
      // ���������� ���������� ������
      inc(i);
      CreateExprTree(Root^.Left, S, I);
      Root^.Data := SignToCode(ord(S[i]));
      // ��������� ���� ��������
      inc(i);
      CreateExprTree(Root^.Right, S, I);
      // ��������� ����������� ������
      inc(i);
    end else begin
      Root^.Data := ord(S[i]) - $30;
      inc(i);
    end;
  end;
end;

{�������� ������ �� ��������� ������}
{���������� ������ �����������, � ��������� ������������ ��, ��� ����!}
{���� �� ����, ������}
{������ ���� (((0+1)*5)-(2*(4+1)))}
procedure Infix(var P : PNode);
var
  C : Char;
begin
  // ���������� �������� �������� - ���������!
  read(c);
  if (c = '(') then begin
    New(P);
    Infix(P^.Left);
    // ���������� �������� �������� - ���������!
    Read(P^.Data);
    Infix(P^.Right);
    Read(c);
  end else begin
    New(P);
    // �� ������ ������������� ����� ��������: '+' -> -1, '-' -> -2, etc
    P^.Data := ord(C);
    P^.Left := nil;
    P^.Right := nil;
  end;
end;

{�������� ������ �� ���������� ������}
{���� �� ����, ������}
{������ ���� * - 1 2 + 3 4 ��� ��������}
{���������� ������� - ����}
procedure Prefix(var P : PNode);
begin
  New(P);
  // ���������� ���������� �������� - ���������!
  read(P^.Data);
  if (chr(P^.Data) in ['*', '-', '*', '/']) then begin
    // ��������������� �������� �������� '+' -> -1, '-' -> -2, etc
    Prefix(P^.Left);
    Prefix(P^.Right);
  end else begin
    P^.Left := nil;
    P^.Right := nil;
  end;
end;

{��������� ��������������� ���������� �������}
procedure Prefix(var P : PNode; S: string; var I : integer);
begin
  if (I <= length(S)) then begin
    New(P);
    // ���������� ���������� ��������
    P^.Data := ord(S[i]);
    inc(i);
    if (chr(P^.Data) in ['*', '-', '*', '/']) then begin
      // ��������������� �������� �������� '+' -> -1, '-' -> -2, etc
      Prefix(P^.Left);
      Prefix(P^.Right);
    end else begin
      P^.Left := nil;
      P^.Right := nil;
    end;
  end;
end;

{�������� ������ �� ����������� ������}
{���� �� ����, ������}
{������ ���� 1 2 + 3 4 + * ��� ��������}
{���������� ������� - ����}
procedure Postfix(var R : PNode);
var
  P, Stack : PNode;
begin
  Stack := nil;
  while (not EOF(Input)) do begin
    New(P);
    // ���������� ���������� �������� - ���������!
    Read(Input, P^.Data);
    if (chr(P^.Data) in ['+', '-', '*', '/']) then begin
      // ��������������� �������� �������� '+' -> -1, '-' -> -2, etc
      P^.Right := Stack;
      P^.Left := Stack^.Next;
      P^.Next := Stack^.Next^.Next;
      Stack := P;
    end else begin
      P^.Left := nil;
      P^.Right := nil;
      P^.Next := Stack;
      Stack := P^.Next;
    end;
  end;
  R := Stack;
end;

{��������� ��������������� ���������� ���}
procedure CreatePostfixTree(var R : PNode; S : string);
var
  P, Stack : PNode;
  i : integer;
begin
  Stack := nil;
  i := 1;
  while (i <= length(S)) do begin
    New(P);
    // ���������� ���������� ��������
    P^.Data := SignToCode(ord(S[i]));
    if (P^.Data < 0) then begin // ���� ��� ���� ��������      
      P^.Right := Stack;
      P^.Left := Stack^.Next;
      P^.Next := Stack^.Next^.Next;
    end else begin
      P^.Left := nil;
      P^.Right := nil;
      P^.Next := Stack;
    end;
    Stack := P;
    
    inc(i);
  end;
  R := Stack;
end;

{�������� ������ ���������}
{������ ���� 5+2-4/5*(8-9)}
{��������� ������� �� ��������� � ����������� ������}
{������������ ������������� ������� ����� =)}
function ToPolish(S : string) : string;
var
  Stack : array [0..100] of char;
  SP : integer;
  
procedure Push(X : char);
begin 
  Stack[SP] := X;
  inc(SP);
end;

function Pop : char;
begin
  if (SP > 1) then begin
    dec(SP);
    Pop := Stack[SP];
  end;
end;

var
  I : integer;
  C : char;
  res : string;
begin
  res := '';
  SP := 1;
  
  for I := 1 to Length(S) do begin
    if (S[i] >= '0') and (S[i] <= '9') then
      res += S[i];
  
    if (S[i] = '(') then
      Push(S[i]);
      
    if (S[i] = ')') then begin
      C := Pop;
      while (C <> '(') do begin
        res += C;
        C := Pop;
      end;
    end;
    
    if ((S[i] = '*') or (S[i] = '/')) then begin
      if ((Stack[SP-1] = '*') or (Stack[SP-1] = '/')) then
        res += Pop;
      Push(S[i]);
    end;
      
    if ((S[i] = '+') or (S[i] = '-')) then begin
      if ((Stack[SP-1] = '*') or
          (Stack[SP-1] = '+') or
          (Stack[SP-1] = '-') or
          (Stack[SP-1] = '/')
         ) then begin
        res += Pop;    
      end;
      Push(S[i]);
    end;
  end;
  
  while (SP > 1) do
    res += Pop;
    
  ToPolish := res;
end;

{���������� ���������� ������}
procedure CreateInfixTree(var R : PNode; SI : string);
var
  Stack : array [0..100] of PNode;
  SP : integer;
  
procedure Push(X : PNode);
begin
  Stack[SP] := X;
  inc(SP);
end;

function Pop : PNode;
begin
  if (SP > 1) then begin
    dec(SP);
    Pop := Stack[SP];
  end;
end;

var
  {P,} Q : PNode;
  i : integer;
  S : string;
begin
  S := ToPolish(SI);

  SP := 1;
  
  for i := 1 to length(S) do begin
    New(Q);
    Q^.Data := SignToCode(ord(S[i]));
    if (Q^.Data < 0) then begin // ���� ��� ���� ��������
      Q^.Right := Pop;
      Q^.Left := Pop;
    end else begin
      Q^.Left := nil;
      Q^.Right := nil;
    end;
    Push(Q);
  end;
  R := Pop;
end;

{��������� �������� - ����������� a+0, 0+a, a-0}
procedure SimplifyAdd(var Root : PNode);
var
  P : PNode;
begin
  if (Root <> nil) then begin
    SimplifyAdd(Root^.Left);
    SimplifyAdd(Root^.Right);
    
    if (Root^.Data = -1) then begin
      if (Root^.Left^.Data = 0) then begin
        P := Root;
        Root := Root^.Right;
        Dispose(P);
      end else if (Root^.Right^.Data = 0) then begin
        P := Root;
        Root := Root^.Left;
        Dispose(P);
      end;
    end else if (Root^.Data = -2) then begin
      if (Root^.Right^.Data = 0) then begin
        P := Root;
        Root := Root^.Left;
        Dispose(P);
      end;
    end;
  end;
end;

{��������� ��������� - ���������� a*0, 0*a, 0/a, a-a}
procedure SimplifyMult0(var Root : PNode);
begin
  if (Root <> nil) then begin
    SimplifyMult0(Root^.Left);
    SimplifyMult0(Root^.Right);
    
    if (
        ((Root^.Data = -2) and 
         (Root^.Right^.Data >= 0) and
         (Root^.Right^.Data = Root^.Left^.Data)
        ) or
        ((Root^.Data = -3) and 
         ((Root^.Left^.Data = 0) or
          (Root^.Right^.Data = 0))
        ) or
        ((Root^.Data = -4) and 
         (Root^.Left^.Data = 0))
       ) then begin
        Dispose(Root^.Left);
        Dispose(Root^.Right);
        Root^.Left := nil;
        Root^.Right := nil;
        Root^.Data := 0;
      end;
  end;
end;

{��������� ��������� - ���������� a*1, 1*a, a/1}
procedure SimplifyMult1(var Root : PNode);
var
  P : PNode;
begin
  if (Root <> nil) then begin
    SimplifyMult1(Root^.Left);
    SimplifyMult1(Root^.Right);

    if (Root^.Data = -3) then begin
      if (Root^.Left^.Data = 1) then begin
        P := Root;
        Root := Root^.Right;
        Dispose(P);
      end else if (Root^.Right^.Data = 1) then begin
        P := Root;
        Root := Root^.Left;
        Dispose(P);
      end;
    end else if (Root^.Data = -4) then begin
      if (Root^.Right^.Data = 1) then begin
        P := Root;
        Root := Root^.Left;
        Dispose(P);
      end;
    end;
  end;
end;

{���������� �������� ���������, � ������������, ����� �� ������ ������� �� ����}
function Execute(Root : PNode; var DZero : boolean) : integer;
var
  L,R : integer;
begin
  if ((Root <> nil) and (not DZero)) then begin
    L := Execute(Root^.Left, DZero);
    R := Execute(Root^.Right, DZero);
    
    if (not DZero) then
      case Root^.Data of
        -1: Execute := L + R;
        -2: Execute := L - R;
        -3: Execute := L * R;
        -4: begin
              if (R = 0) then begin
                DZero := true;
                Execute := L;
              end else
                // ������ ������, ����� ������� 1 div 4 = ������������� ����
                Execute := L * R;
            end;
        else
          Execute := Root^.Data;
      end;
  end;
end;

{--- ���������� ---}
{���������� ������ � ������}
function CountN(Node : PNode) : integer;
begin
  if (Node = nil) then
    CountN := 0
  else
    CountN := CountN(Node^.Left) + CountN(Node^.Right) + 1;
end;

{���������� ������ �� ������ K}
function CountK(Node : PNode; K : integer) : integer;
begin
  if (Node <> nil) then begin
    if (K = 0) then
      CountK := 1
    else if (K > 0) then
      CountK := CountK(Node^.Left, K-1) + CountK(Node^.Right, K-1)
    else
      CountK := 0;
  end;
end;

{���������� ������� � ������}
function CountL(Node : PNode) : integer;
begin
  if (Node = nil) then
    CountL := 0
  else if (Node^.Left = Node^.Right) then
    CountL := 1
  else
    CountL := CountL(Node^.Left) + CountL(Node^.Right);
end;

{������ ������, ������ �� ������ ������}
function TreeH(Node : PNode) : integer;
begin
  if (Node = nil) then
    TreeH := 0
  else
    TreeH := Max(TreeH(Node^.Left), TreeH(Node^.Right)) + 1;
end;

{��������� ������ �� ������� (��. ������� TreeWork48)}
procedure FillTree(var Node : PNode; L : integer);
begin
  if (L > 0) then begin
    if (Node = nil) then begin
      New(Node);
      Node^.Data := -1;
    end;
    FillTree(Node^.Left, L-1);
    FillTree(Node^.Right, L-1);
  end;
end;


{������� �� ������ �������}
procedure CleanupSpaces(var S : String);
var
  i,j : integer;
begin
  i := 1;
  j := 1;
  while (i <= length(S)) do begin
    if (S[i] <> ' ') then begin
      S[j] := S[i];
      inc(j);
    end;
    inc(i);
  end;
  
  if (i <> j) then
    S := Copy(S, 1, j-1);
end;

end.