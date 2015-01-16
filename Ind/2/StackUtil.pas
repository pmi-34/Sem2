unit StackUtil;

interface

type
  RType = (Variable, Constant, Operation, Bracket);
  PNode = ^TNode;
  TNode = record
    Data : integer;
    T : RType;
    Left, Right, Next : PNode;
  end;

procedure Push(X : PNode);
function Pop : PNode;
function ReadTop : PNode;

procedure ResetStack;
function IsClear : boolean;
procedure Error(S1, S2 : string; var N : integer);

var
  IsError : boolean;

implementation

const NMax = 100;

var
  Stack : array [0..NMax] of int64;
  SP : integer;

// Процедура обработки ошибок
procedure Error(S1, S2 : string; var N : integer);
begin
  writeln('Ошибка: ', S1);
  writeln(S2);

  if (N <> 0) then
    writeln('^':N);

  // Остановим парсер
  N := length(S2) + 1;
  IsError := true;
end;

// Пуст ли стек?
function IsClear : boolean;
begin
  IsClear := SP = 1;
end;

// Сбрасывает стек
procedure ResetStack;
begin
  for SP := 0 to NMax do
    Stack[SP] := 0;
  SP := 1;
end;

// Положить в стек элемент
procedure _Push(X : int64);
begin
  if (SP <= NMax) then begin
    Stack[SP] := X;
    inc(SP);
  end else begin
    SP := 0;
    Error('Переполнение стека', '', SP);
  end;
end;

// Достать из стека элемент
function _Pop : int64;
begin
  if (SP > 1) then begin
    dec(SP);
    _Pop := Stack[SP];
  end else begin
    SP := 0;
    Error('Попытка чтения пустого стека, проверьте корректность выражения',
    '', SP);
    _Pop := 0;
  end;
end;

// Возвращает значение верхушки стека, не извлекая его
function _ReadTop : int64;
begin
  if (SP > 1) then begin
    _ReadTop := Stack[SP-1];
  end else begin
    writeln('Stack read underflow!');
    _ReadTop := 0;
  end;
end;

// Обертки
procedure Push(X : PNode);
begin
  _Push(Int64(X));
end;

function Pop : PNode;
begin
  Pop := Pointer(_Pop);
end;

function ReadTop : PNode;
begin
  ReadTop := Pointer(_ReadTop);
end;

// Инициализация стека
begin
  ResetStack;
end.

