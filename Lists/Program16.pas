program P16;

type
  PList = ^TList;
  TList = record
    Next : PList;
    Data : integer;
    Used : boolean;
  end;

procedure AddToLL(var H : PList; N : integer);
var
  Q,P : PList;
begin
  New(Q);
  Q^.Data := N;
  Q^.Used := false;
  Q^.Next := H;
  
  if (H = nil) then begin
    H := Q;
    Q^.Next := Q;
  end else begin
    P := H;
    while (P^.next <> H) do
      P := P^.Next;
    P^.Next := Q;
  end;
end;

procedure ClearLL(H : PList);
var
  Q : PList;
begin
  Q := H;
  repeat
    Q^.Used := false;
    Q := Q^.Next;
  until Q = H;
end;

function NumWords(S : String) : integer;
var
  i,N : integer;
begin
  i := 1;
  N := 0;
  for i := 1 to length(S) do begin
    if (i = length(S)) or (S[i] = ' ') then
      inc(N);
  end;
  NumWords := N;
end;

var
  S : String;
  F, fout : text;
  i,K,N,M : integer;
  H,P : PList;
begin
  write('Введите N и K: ');
  readln(N, K);

  for i := 1 to N do
    AddToLL(H, i);
  
  P := H;
  
  assign(f, 'in16.txt');
  reset(f);
  
  assign(fout, 'out.txt');
  rewrite(fout);
  
  while not SeekEof(f) do begin
    readln(f, S);
    //writeln('#', S, ' ', NumWords(S));
    P := H;
    
    M := N;
    repeat
      i := 1;
      repeat
        if (not P^.Used) then
          inc(i);
        P := P^.Next;
      until (i >= NumWords(S)) and (not P^.Used);
      
      P^.Used := true;
      //writeln('Выбыл ', P^.Data);
      P := P^.Next;
      dec(M);
    until (M = 1);
    
    while P^.Data <> K do
      P := P^.Next;
      
    if (not P^.Used) then
      writeln(fout, S);
    ClearLL(H);
  end;
  
  close(f);
  close(fout);
end.
