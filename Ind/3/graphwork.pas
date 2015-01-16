unit GraphWork;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;


type
  // Матрица смежности
  Graph = array of array of integer;
  IArray = array of integer;

procedure DumpTo(var M : Graph; N : integer; FName : string);
procedure BuildHorseMatrix2(var M : Graph; N : integer;
                            X1, Y1, X2, Y2 : integer);
procedure ReverseWave(var M : Graph; N : integer;
                      X1, Y1, X2, Y2 : integer;
                      var Path : IArray);

implementation

procedure Mark(var M : Graph; N,d : integer;
               x,y : integer;
               X1,Y1 : integer);
begin
  if (X >= 0) AND (X < N) AND
     (Y >= 0) AND (Y < N) AND
     (M[X][Y] > d) then begin

    M[x][y] := d;

    Mark(M, N, d+1, x+1, y+2, X1, Y1);
    Mark(M, N, d+1, x+1, y-2, X1, Y1);
    Mark(M, N, d+1, x-1, y+2, X1, Y1);
    Mark(M, N, d+1, x-1, y-2, X1, Y1);
    Mark(M, N, d+1, x+2, y+1, X1, Y1);
    Mark(M, N, d+1, x+2, y-1, X1, Y1);
    Mark(M, N, d+1, x-2, y+1, X1, Y1);
    Mark(M, N, d+1, x-2, y-1, X1, Y1);
  end;
end;

// Прямой ход алгоритма Ли - размечаем матрицу расстояний
procedure BuildHorseMatrix2(var M : Graph; N : integer;
                            X1, Y1, X2, Y2 : integer);
var
  i,j : integer;
begin
  SetLength(M, N, N);
  for i := 0 to N-1 do
    for j := 0 to N-1 do
      M[i][j] := N*N;
  Mark(M, N, 0, X1, Y1, X2, Y2);
end;

// Поиск соседней ячейки
// Ячейка считается соседней, если она доступна за один шаг
// и значение в ней меньше на единичку
function FindNear(var M : Graph; N : integer;
                  X, Y : integer) : integer;
var
  d : integer;
begin
  D := M[X][Y];

  if (X+1 < N) AND (Y+2 < N) AND (M[X+1][Y+2] < d) then
    FindNear := X+1 + (Y+2)*N
  else if (X+1 < N) AND (Y-2 >= 0) AND (M[X+1][Y-2] < d) then
    FindNear := X+1 + (Y-2)*N
  else if (X-1 >= 0) AND (Y+2 < N) AND (M[X-1][Y+2] < d) then
    FindNear := X-1 + (Y+2)*N
  else if (X-1 >= 0) AND (Y-2 >= 0) AND (M[X-1][Y-2] < d) then
    FindNear := X-1 + (Y-2)*N
  else if (X+2 < N) AND (Y+1 < N) AND (M[X+2][Y+1] < d) then
    FindNear := X+2 + (Y+1)*N
  else if (X+2 < N) AND (Y-1 >= 0) AND (M[X+2][Y-1] < d) then
    FindNear := X+2 + (Y-1)*N
  else if (X-2 >= 0) AND (Y+1 < N) AND (M[X-2][Y+1] < d) then
    FindNear := X-2 + (Y+1)*N
  else if (X-2 >= 0) AND (Y-1 >= 0) AND (M[X-2][Y-1] < d) then
    FindNear := X-2 + (Y-1)*N
  else begin
    raise Exception.Create('Something wrong!');
    FindNear := -1;
  end;
end;

// Обратный ход алгоритма Ли
procedure ReverseWave(var M : Graph; N : integer;
                      X1, Y1, X2, Y2 : integer;
                      var Path : IArray);
var
  i : integer;
begin
  SetLength(Path, N*N);
  i := 0;
  Path[0] := X2 + Y2*N;
  while ((X1 <> X2) or (Y1 <> Y2)) do begin
    inc(i);
    Path[i] := FindNear(M, N, X2, Y2);
    X2 := Path[i] mod N;
    Y2 := Path[i] div N;
  end;
  Path[i+1] := X1 + Y1*N;
end;

procedure DumpTo(var M : Graph; N : integer; FName : string);
var
  F : text;
  i,j : integer;
begin
  assignFile(f, fname);
  rewrite(f);

  for i := 0 to N-1 do begin
    for j := 0 to N-1 do
      write(f, M[i][j], ' ');
    writeln(f);
  end;

  closeFile(f);
end;

end.

