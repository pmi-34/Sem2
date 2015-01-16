program Ind2 (input, output);

{$DEFINE DEBUG}

uses
  StackUtil, SysUtils;

{Определяет, является ли аргумент числом}
function isdigit(X : char) : boolean;
begin
  isdigit := (X >= '0') AND (X <= '9');
end;

{Определяет, является ли аргумент символом}
function isalpha(X : char) : boolean;
begin
  isalpha := (upcase(X) >= 'A') AND (upcase(X) <= 'Z');
end;

{Переводит часть строки в число}
function GetN(S : string; var I : integer) : integer;
var
  R : integer;
begin
  R := 0;

  while ((I <= length(S)) AND isdigit(S[i])) do begin
    R := R*10 + ord(S[I]) - $30; // ord('0');
    inc(I);
  end;

  GetN := R;
end;

{Создание дерева из инфиксной записи}
procedure CreateInfixTree(var Root : PNode; S : string);
var
  Queue, {голова очереди}
  QEnd, {хвост очереди}
  Last {последний распознанный элемент}
  : PNode;

  {Добавление элемента в очередь}
  procedure AddToQueue(P : PNode);
  var
    Q : PNode;
  begin
    if (Queue = nil) then begin
      Queue := P;
      QEnd := P;
    end else begin
      QEnd^.Next := P;
      QEnd := P;
    end;
  end;

  {Создание узла дерева}
  function Build(Data : integer; T : RType) : PNode;
  var
    Q : PNode;
  begin
    New(Q);
    Q^.Next := nil;
    Q^.Left := nil;
    Q^.Right := nil;
    Q^.Data := Data;
    Q^.T := T;
    Last := Q;
    Build := Q;
  end;

var
  i : integer;
  Q : PNode;
begin
  i := 1;
  Queue := nil;
  QEnd := nil;
  Last := nil;

  ResetStack;

  {Преобразование выразения в обратную польскую запись}
  while ((i <= Length(S)) and not IsError) do begin
    {Пропустим пробелы}
    if (S[i] <> ' ') then begin
      {После символа переменной должен быть только знак или конец строки}
      if (Last <> nil) and (Last^.T = Variable) and (isdigit(S[i]) or
      isalpha(S[i]) or (S[i] = '(')) then
        Error('Неправильное задание переменной', S, i)
      {Добавим число в очередь}
      else if isdigit(S[i]) then begin
        AddToQueue(Build(GetN(S, I), Constant));
        dec(i);
      end
      {Добавим переменную в очередь}
      else if isalpha(S[i]) then
        AddToQueue(Build(ord(S[i]), Variable))
      {Кладем в стек скобку}
      else if (S[i] = '(') then
        Push(Build(0, Bracket))
      {Извлекаем из стека все до открывающей скобки}
      else if (S[i] = ')') then begin
        Q := Pop;
        while (Q <> nil) AND (Q^.T <> Bracket) do begin
          AddToQueue(Q);
          Q := Pop;
        end;
        if (Q = nil) then
          Error('В выражении несбалансированы скобки', S, I)
        else
          Dispose(Q); // Q^.T = Bracket
      end
      {Извлекаем все операции того же приоритета}
      else if ((S[i] = '*') or (S[i] = '/')) then begin
        while ((not IsClear) AND 
               ((ReadTop^.Data = ord('*')) OR (ReadTop^.Data = ord('/')))) do
          AddToQueue(Pop);
        Push(Build(ord(S[i]), Operation));
      end
      {Извлекаем все операции того же или более высокого приоритета}
      else if ((S[i] = '+') or (S[i] = '-')) then begin
        if ((S[i] = '-') and 
            ((Last = nil) or (Last^.T = Bracket) or (Last^.T = Operation))) then begin
           {Минус унарный, ничего не извлекаем - просто добавим 0 перед ним}
           AddToQueue(Build(0, Constant));
        end else while ((not IsClear) AND
           ((ReadTop^.Data = ord('*')) or
            (ReadTop^.Data = ord('+')) or
            (ReadTop^.Data = ord('-')) or
            (ReadTop^.Data = ord('/'))
           )) do
          AddToQueue(Pop);    
        Push(Build(ord(S[i]), Operation));
      end else {Нераспознанный символ}
        Error('Неизвестный символ', S, I);
    end;
    inc(i);
  end;

  I := 0;
  {Извлечем из стека оставшиеся элементы}
  while (not IsClear) do begin
    Q := Pop;
    if (Q <> nil) and (Q^.T = Bracket) then
      Error('В выражении не закрыты скобки', '', I)
    else
      AddToQueue(Q);
  end;

  {$IFDEF DEBUG}
  Q := Queue;
  while (Q <> nil) do begin
    if (Q^.T = Operation) OR (Q^.T = Variable) then
      write (chr(Q^.Data), ' ')
    else
      write(Q^.Data, ' ');

    Q := Q^.Next;
  end;
  writeln;
  {$ENDIF}
  
  {Если польская запись успешно составлена, строим дерево}
  if (not IsError) then begin
    {Строим дерево}
    Q := Queue;
    while (Q <> nil) do begin
      if (Q^.T = Operation) then begin
        Q^.Right := Pop;
        Q^.Left := Pop;
      end;

      Push(Q);
    
      Q := Q^.Next;
    end;

    Root := Pop;
  end else
    Root := nil;
end;

{Вывод дерева на боку, зеркально-симметричный обратный обход, RNL}
procedure DumpTree(P : PNode; L : integer);
begin
  if (P <> nil) then begin
    DumpTree(P^.Right, L+1);
    if (P^.T = Operation) OR (P^.T = Variable) then
      writeln(' ':L*4, chr(P^.Data) : 2)
    else
      writeln(' ':L*4, P^.Data : 2);
    DumpTree(P^.Left, L+1);
  end;
end;

{Освобождение памяти, концевой обход, LRN}
procedure FreeTree(var Root : PNode);
begin
  if (Root <> nil) then begin
    FreeTree(Root^.Left);
    FreeTree(Root^.Right);
    Dispose(Root);
    Root := nil;
  end;
end;

{Копирование дерева, прямой обход, NLR}
procedure CopyTree(Root : PNode; var NewRoot : PNode);
begin
  if (Root <> nil) then begin
    New(NewRoot);
    NewRoot^.Data := Root^.Data;
    NewRoot^.T := Root^.T;
    CopyTree(Root^.Left, NewRoot^.Left);
    CopyTree(Root^.Right, NewRoot^.Right);
  end;
end;

{Ради чего все и затевалось - упрощение выражения}
procedure Simplify(var Root : PNode);
var
  Q : PNode;
begin
  if (Root <> nil) then begin
    Simplify(Root^.Left);
    Simplify(Root^.Right);

    if ((Root^.T = Operation) and (Root^.Data = ord('*'))) then
      if ((Root^.Left <> nil) and (Root^.Left^.T = Operation) and
          ((Root^.Left^.Data = ord('+')) or (Root^.Left^.Data = ord('-'))))
          then begin
          {Мы в узле-операции умножения, левый потомок - сложение}
        New(Q);
        Q^.T := Operation;
        Q^.Data := ord('*');
        CopyTree(Root^.Right, Q^.Right);

        Q^.Left := Root^.Left^.Right;
        Root^.Left^.Right := Root^.Right;

        Root^.Data := Root^.Left^.Data;
        Root^.Left^.Data := ord('*');

        Root^.Right := Q;
      end else if ((Root^.Right <> nil) and (Root^.Right^.T = Operation) and
          ((Root^.Right^.Data = ord('+')) or (Root^.Right^.Data = ord('-'))))
          then begin
          {Правый потомок - сложение}
        New(Q);
        Q^.T := Operation;
        Q^.Data := ord('*');
        CopyTree(Root^.Left, Q^.Left);

        Q^.Right := Root^.Right^.Left;
        Root^.Right^.Left := Root^.Left;

        Root^.Data := Root^.Right^.Data;
        Root^.Right^.Data := ord('*');

        Root^.Left := Q;
      end;
  end;
end;

var
  {Значения переменных}
  Var_vals : array ['a'..'z'] of integer;
  {Определена ли переменная}
  Var_def : array ['a'..'z'] of boolean;

function DoCalculation(var Root : PNode) : real;
var
  c : char;
  r : real;
  i : integer;
begin
  if (Root <> nil) and (not IsError) then begin
    c := chr(Root^.Data);
    if (Root^.T = Constant) then
      DoCalculation := Root^.Data
    else if (Root^.T = Variable) then begin
      if (not Var_def[c]) then begin
        write('Введите значение переменной ', c, ':');
        readln(Var_vals[c]);
        Var_def[c] := true;
      end;
      DoCalculation := Var_vals[c];
    end else begin
      case c of
        '+': DoCalculation := DoCalculation(Root^.Left) +
                              DoCalculation(Root^.Right);
        '-': DoCalculation := DoCalculation(Root^.Left) -
                              DoCalculation(Root^.Right);
        '*': DoCalculation := DoCalculation(Root^.Left) *
                              DoCalculation(Root^.Right);
        '/': begin
               r := DoCalculation(Root^.Right);
               i := 0;
               if (r = 0) then
                 Error('Попытка деления на ноль!', '', i)
               else
                 DoCalculation := DoCalculation(Root^.Left) / r;
             end;
      end;
    end;
  end else
    DoCalculation := 0;
end;

function Calculate (var Root : PNode) : real;
var
  c : char;
begin
  for c := 'a' to 'z' do begin
    Var_vals[c] := 0;
    Var_def[c] := false;
  end;
  Calculate := DoCalculation(Root);
end;

{Обработка одной строки}
procedure Evaluate(S : string);
var
  R : PNode;
  Res : real;
begin
  R := nil;
  IsError := false;
  CreateInfixTree(R, S);
  if (not IsError) then begin
    Simplify(R);
    DumpTree(R, 0);
    Res := Calculate(R);
    if (not IsError) then
      writeln('Значение выражения ', Res:8:4)
  end;
  FreeTree(R);
end;

{Обработка файла}
procedure ReadFile(FName : string);
var
  F : text;
  S : string;
begin
  assign(F, FName);
  reset(F);
  while (not SeekEOF(F)) do begin
    readln(F, S);
    Evaluate(S);
  end;
end;

{Отображение справки}
procedure ShowHelp;
begin
  writeln(' ':4, 'Помощь:');
  writeln(' ':8, 'F', '    Указать файл с входными данными');
  writeln(' ':8, 'S', '    Ввести вычисляемую строку вручную');
  writeln(' ':8, 'H', '    Вывод данного сообщения');
  writeln(' ':8, 'Q', '    Возврат на предыдущий шаг, в главном меню - выход');
end;

{Запрос имени файла}
procedure RunFile;
var
  S : string;
begin
  S := '';
 
  repeat
    if (S <> '') then
      writeln('Файл с именем ', S, ' не существует!');
    write('Введите имя файла (пустое = имя по умолчанию): ');
    readln(S);
    if (S = '') then
      S := 'in.txt';
  until FileExists(S) OR (upcase(S[1]) = 'Q');

    if (upcase(S[1]) <> 'Q') then
      ReadFile(S);
end;

{Обработка одной, вручную введенной строки}
procedure RunString;
var
  S : string;
begin
  write('Введите выражение: ');
  readln(S);
  if (S = '') then
    writeln('Выражение не должно быть пустым!')
  else if (upcase(S[1]) <> 'Q') then
    Evaluate(S);
end;

{Диалог с пользователем}
procedure MainLoop;
var
  C : char;
begin
  writeln('Программа для упрощения алгебраических операций');
  repeat
    write('Введите команду (h для справки): ');
    readln(C);
    case upcase(C) of
      'H': ShowHelp;
      'F': RunFile;
      'S': RunString;
    end;
  until upcase(C) = 'Q';
end;

{Основная программа}
begin
  MainLoop;
end.

