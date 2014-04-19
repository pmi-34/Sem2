uses PT4, Trees;

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

procedure CreatePostfixTree(var R : PNode; S : string);
var
  P, Stack : PNode;
  i : integer;
begin
  Stack := nil;
  i := 1;
  while (i <= length(S)) do begin
    New(P);
    // Считывание очередного элемента
    P^.Data := SignToCode(ord(S[i]));
    if (P^.Data < 0) then begin // Если это знак операции      
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

var
  P : PNode;
  S,S2 : string;
begin
  Task('Tree78');
  read(S, S2); // WTF????
  
  CleanupSpaces(S2);
//  Show(S2);
  
  CreatePostfixTree(P, S2);
  PrintTree(P);
  Write(P);
end.
