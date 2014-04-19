program P16;

function S1(S : string) : integer;
const
  Hash : array [1..18] of byte = ($5, $3, $11, $2F, $0D, $3B, 
                   $17, $35, $7, $1F, $29, $25, $0B, $2B, $1D, $3D, $13, $43);
var
  i,res : integer;
begin
  res := 0;
  for i := 1 to 18 do
    res += (ord(S[i]) - ord('0'))*Hash[i];

  S1 := res;
end;

function CheckCode(S : string) : boolean;
var
  X,Y,Z : integer;
  R : string;
  res : boolean;
begin
  res := false;
  if (Length(S) = 22) then begin
    R := Copy(S, 1, 2);
    if (R = '00') or
       (R = '28') or
       (R = '38') or
       (R = '48') or
       (R = '68') or
       (R = '78') or
       (R = '98') then begin
      R := Copy(S, 19, 4);
      Z := StrToInt(R);
      X := Z - 8001; // + FFFFE0BF
      // writeformat('{0:d} ', x);
      
      R := Copy(S, 1, 18);
      Y := S1(R);
      
      if (X > 0) and (X < 1999) then begin // 7CF
        Y := Y mod 1999;
        
        if (Y = X) then
          res := true;
      end else begin
        Y := Y mod 200; // C8
        Z := Z mod 200;
              
        if (Y = Z) then
          res := true;
      end;
    end;
  end;
  CheckCode := res;
end;

// Mini - 00
// Pre-Elementary - 28
// Elementary - 38
// Intermediate - 48
// Pre-Advanced - 68
// Advanced - 78
// Complete - 98
function GenerateCode : string;
const
  Prefix : array [1..7] of array [1..2] of string = (
         ('00', 'Mini'),
         ('28', 'Pre-Elementary'), 
         ('38', 'Elementary'),
         ('48', 'Intermediate'), 
         ('68', 'Pre-Advanced'),
         ('78', 'Advanced'), 
         ('98', 'Complete'));
var
  S : string;
  X, Y, Z, i : integer;
begin
  writeln('Выберите вариант задачника: ');
  for i := 1 to 7 do
    writeln(i, ': ', Prefix[i][2]);
  write('Введите номер: ');
  readln(I);
  
  S := Prefix[I][1];
  
  for i := 1 to 16 do
    S += chr(Random(10)+$30);
    
  Y := S1(S);

  if (Random(2) = 0) then begin
    Y := Y mod 1999;
    X := Y + 8001;
  end else begin
    Y := Y mod 200;
    X := (Y + 200*(Random(39)+1));
  end;

  S += Format('{0:d4}', X);
  
  GenerateCode := S;
end;

var
  S : string;
  i, X,Y,Z : integer;
begin
  // writeln(CheckCode('9812345678909876543212'));
  
  S := GenerateCode;
  write('Ваш код: ', S, ', проверим работоспособность... ');
  writeln(CheckCode(S));
end.
