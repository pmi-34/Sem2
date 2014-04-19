unit Trees;

{$DEFINE PT4}

interface

uses
{$IFDEF PT4}
  PT4,
{$ENDIF}
  GraphABC;

{$IFNDEF PT4}
type
  PNode = ^TNode;
  TNode = record
    Data : integer;
    Left,Right,Parent : PNode;
  end;
{$ENDIF}

procedure PrintTree(Head : PNode);

implementation

// Возвращает высоту дерева
function TreeHeight(Head : PNode) : integer;
begin
  if Head <> nil then
    TreeHeight := Max(TreeHeight(Head^.Left), 
                      TreeHeight(Head^.Right)) + 1
  else 
    TreeHeight := 0;
end;

// Возвращает ширину дерева
function TreeWidth(Head : PNode) : integer;
begin
  if Head <> nil then
    TreeWidth := TreeWidth(Head^.Left) +
                 TreeWidth(Head^.Right) +
      ord((Head^.Left = nil) and (Head^.Right = nil))
  else 
    TreeWidth := 0;
end;

procedure PrintNode(Head : PNode; L, R, Y, YST : integer);
var
  X,H : integer;
begin
  if (Head <> nil) then begin
    X := (L+R) div 2;
    H := Font.Size + 6;
    // Ссылка на левый элемент
    if (Head^.Left <> nil) then begin
      Line(X+(H div 2), Y+(H div 2), (L+X+H) div 2, Y+YST);
      // Двойные связи
      if (Head^.Left^.Parent <> nil) then
        Line(X+(H div 2)-3, Y+(H div 2), ((L+X+H) div 2)-3, Y+YST);
    end;
      
    // Ссылка на правый элемент
    if (Head^.Right <> nil) then begin
      Line(X+(H div 2), Y+(H div 2), (X+R+H) div 2, Y+YST);
      // Двойные связи
      if (Head^.Right^.Parent <> nil) then
        Line(X+(H div 2)-3, Y+(H div 2), ((X+R+H) div 2)-3, Y+YST);
    end;
    
    FillCircle(X+(H div 2), Y+(H div 2), H);
    DrawCircle(X+(H div 2), Y+(H div 2), H);
    TextOut(X, Y, Head^.Data.ToString);
    PrintNode(Head^.Left, L, X, Y+YST, YST);
    PrintNode(Head^.Right, X, R, Y+YST, YST);
  end;
end;

procedure PrintTree(Head : PNode);
var
  H : integer;
begin
  SetWindowCaption('Дерево');
  Window.IsFixedSize := true;
  ClearWindow;
  H := TreeHeight(Head);
  if (H = 0) then
    H := 1;
  PrintNode(Head, 10, Window.Width-10, 10, Window.Height div (H));
end;

begin
end.
