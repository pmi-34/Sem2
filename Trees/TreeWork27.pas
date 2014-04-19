uses PT4;

{������ ���� ((3)4)5(6))7(8(9)), ��� ������� ������}
function WalkLNRStr(Root : PNode) : string;
{�������� �����}
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

{����� ������������ ��������}
function FindMin(Node : PNode) : PNode;
begin
  while Node^.Left <> nil do
    Node := Node^.Left;
  FindMin := Node;
end;

{�������� � ������� ������}
{������������ ����������� ������� �� ������� ���������}
procedure Delete (var root : PNode; X : PNode);
var 
  Q : PNode;
  procedure Del(var r : PNode);
  begin
    if (r^.left <> nil) then 
      Del(r^.left)
    else begin
      Q^.Data := r^.Data;
      q := r;
      r := r^.Right;
    end
  end;
begin
  if (root = nil) then 
    write('����� ������� � ������ ���')
  else if (x^.Data < root^.Data) then 
    Delete(root^.left, x)
  else if (x^.Data > root^.Data) then 
    Delete(root^.right, x)
  else begin
    q := root;
    if (q^.right = nil) then 
      root := q^.left
    else if (q^.left = nil) then 
      root := q^.right
    else 
      del(q^.Right);
    dispose(q);
  end;
end;

var
  P : PNode;
begin
  Task('TreeWork27');
  read(P);
  Delete(P, P);
  Write(WalkLNRStr(P));
end.

