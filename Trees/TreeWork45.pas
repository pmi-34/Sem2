uses PT4;

procedure ConvertToRTree(Node, Prev : PNode);
begin
  if (Node <> nil) then begin
    Node^.Parent := Prev;
    ConvertToRTree(Node^.Left, Node);
    ConvertToRTree(Node^.Right, Node);
  end;
end;

var
  P : PNode;
begin
  Task('TreeWork45');
  read(P);
  ConvertToRTree(P, nil);
end.

