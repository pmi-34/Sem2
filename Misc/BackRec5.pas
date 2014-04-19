{uses
  PT4;
}
const
  NMax = 30;

type
  TArray = array [1..NMax] of integer;
  //Flags = array [1..NMax] of boolean;
  Flags = set of 1..NMax;

procedure Debug(U : Flags);
begin
  writeln(U);
end;

function Go(var W, C : TArray; U : Flags; var M : Flags; i, N, Z : integer):integer;
var
  J, Max, Cur : integer;
begin
  U := U + [i];
  Max := C[i];
  writeln('----');
  Debug(U);
  Debug(M);
  for J := i+1 to N do begin
    Cur := Go(W, C, U, M, j, N, Z) + C[i];
    if (Cur > Max) then begin
      Max := Cur;
      M := U;
    end;
  end;
  Go := Max;
end;

var
  i, N, Z, E : integer;
  S : string;
  f : text;
  Weight, Cost : TArray;
  Used, Max : Flags;
begin
  //Task('BackRec5');
  //read(S);
  S := 'data.txt';
  assign(f, S);
  reset(f);
  read(f, N, Z);
  
  for i := 1 to N do
    read(f, Weight[i]);
  
  for i := 1 to N do
    read(f, Cost[i]);
    
  close(f);
  
  Used := [];
  Max := [];
  
  I := Go(Weight, Cost, Used, Max, 1, N, Z);
    
  for i := 1 to N do
    if (i in Max) then
      write(i);
     
  write(0, 0);
  
end.