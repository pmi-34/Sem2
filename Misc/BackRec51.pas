uses
  PT4;

const 
  NMax = 50;

type
  TArray = array [1..NMax] of integer;
  TUsed = set of 1..NMax;

procedure Print(var A : TUsed; N : integer);
var
  i : integer;
begin
  for i := 1 to N do
    if (i in A) then
      write(i);
end;

procedure Find(
               Weight, Vol : TArray; 
               D : TUsed; var Q : TUsed; 
               K, W, A, B, N, V : integer; 
               var MinV, MaxW : integer);
var 
  i : integer;
begin
  if ((W + Weight[K]) <= B)  then  begin
    D := D + [K];
    V := V + Vol[K];
    W := W + Weight[K];

    if (W >= A) AND (((V < MinV) AND (V <> 0)) OR (MinV = 0)) then begin
      Q := D;
      MinV := V;
      MaxW := W;
    end;
        
    for i := K+1 to N do 
      Find(Weight, Vol, D, Q, i, W, A, B, N, V, MinV, MaxW);
  end;
end;

var 
  S : string;
  f : text;
  i, A, B, N, MinV, MaxW : integer;
  Weight, Cost : TArray;
  Min : TUsed;
    
begin
  Task('BackRec4');
  read(S);
  
  assign(f, S);
  reset(f);
  read(f, N, A, B);

  for i := 1 to N do
    read(f, Weight[i]);

  for i := 1 to N do
    read(f, Cost[i]);
  
  close(f);
  
  Min := [];
  MinV := 0;
  MaxW := 0;
  
  for i := 1 to N do
    Find(Weight, Cost, [], Min, i, 0, A, B, N, 0, MinV, MaxW);
    
  Print(Min, N);
  write(MaxW, MinV);
end.
