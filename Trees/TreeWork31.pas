uses PT4;

procedure CreateNLRTree(var Root : PNode; S : string; var I : integer);
begin
  if (I <= length(S)) and (S[i] <> ',') and (S[i] <> ')') then begin
    New(Root);
    Root^.Data := ord(S[I]) - $30;
    inc(I);
    if ((I < length(S)) and (S[i] = '(')) then begin
      // Пропустим скобку
      inc(i);
      CreateNLRTree(Root^.Left, S, I);
      if ((I < length(S)) and (S[i] = ',')) then begin
        // Пропустим запятую
        inc(i);
        CreateNLRTree(Root^.Right, S, I);
      end;
      // Пропустим закрывающую скобку
      inc(i);
    end;
  end;
end;

var
  S : string;
  P : PNode;
  I : integer;
begin
  Task('TreeWork31');
  read(S);
  I := 1;
  
  CreateNLRTree(P, S, I);
  write(P);
end.

