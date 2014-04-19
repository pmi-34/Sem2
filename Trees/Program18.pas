program P18;

//{$DEFINE DEBUG}

{$IFDEF DEBUG}
uses Trees, PT4;
{$ELSE}
type
  PNode = ^TNode;
  TNode = record 
    Data : integer;
    Left, Right : PNode;
  end;
{$ENDIF}

{зеркально-симметричный обратный обход, RNL}
procedure WalkRNL(Node :PNode);
begin
  if (Node <> nil) then begin
    WalkRNL(Node^.Right);
    write(Node^.Data, ' ');
    WalkRNL(Node^.Left);
  end;
end;

{прямой обход, NLR}
procedure WalkS(Node : PNode; S : string);
begin
  if (Node <> nil) then begin
    writeln(S + IntToStr(Node^.Data));
    WalkS(Node^.Left, S + IntToStr(Node^.Data) + ' -> ');
    WalkS(Node^.Right, S + IntToStr(Node^.Data) + ' -> ');
  end;
end;

procedure InsertX(var R : PNode; X : integer);
var
  P,Q : PNode;
  F : boolean;
begin
  New(P);
  P^.Data := X;
  P^.Left := nil;
  P^.Right := nil;
  
  if (R = nil) then
    R := P
  else begin
    Q := R;
    F := false;
    repeat
      if (Q^.Data < X) then begin
        if (Q^.Left <> nil) then
          Q := Q^.Left
        else begin
          Q^.Left := P;
          F := true;
        end;          
      end else begin
        if (Q^.Right <> nil) then
          Q := Q^.Right
        else begin
          Q^.Right := P;
          F := true
        end;
      end;
    until F;
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
  I,X : integer;
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
    writeln(' ':L*4, P^.Data:2);
    DumpTree(P^.Left, L+1);
  end;
end;

var
  P : PNode;
begin
  CreateTree(P);
  {$IFDEF DEBUG}
  PrintTree(P);
  {$ENDIF}
  
  WalkRNL(P);
  
  writeln;

  DumpTree(P, 0);
  
  WalkS(P, '');
  
  FreeTree(P);
end.
