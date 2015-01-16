program Ind1 (input, output);

uses
  SysUtils;

type
  PNode = ^TNode;
  TNode = record
    C,P : integer;
    X : char;
    N : PNode;
  end;

var
  IsError : boolean;

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

// Переводит число в строку со знаком
function IntToStrM(X : integer) : string;
begin
  if (X > 0) then
    IntToStrM := '+' + IntToStr(X)
  else
    IntToStrM := IntToStr(X);
end;

// Переводит часть строки в число
function GetN(S : string; var I : integer) : integer;
var
  R,J : integer;
begin
  R := 0;
  J := I;

  while ((I <= length(S)) AND (S[I] >= '0') AND (S[I] <= '9')) do begin
    R := R*10 + ord(S[I]) - $30; // ord('0');
    inc(I);
  end;
 
  if (J = I) then
    R := 1;

  GetN := R;
end;

// Формирует запись члена в многочлене
function FormP(P : PNode) : string;
var
  S : string;
begin
  S := '';
  // Если коэффициент перед членом не нулевой...
  if ((P <> nil) AND (P^.C <> 0)) then begin
    // Если степень нулевая, то это просто константа
    if (P^.P = 0) then
      S := IntToStrM(P^.C)
    else begin
      // Это не константа
      // Если коэффициент не равен плюс/минус единице, запишем полностью
      if (Abs(P^.C) <> 1) then
        S := IntToStrM(P^.C)
      else
        // Иначе возьмем только знак от него
        S := IntToStrM(P^.C)[1];
      S += P^.X;
      // Если степень не первая, допишем показатель степени
      if (P^.P <> 1) then
        S += '^' + IntToStr(P^.P);
    end;
  end;
  FormP := S;
end;

// Записать многочлен
procedure WriteP(var F : text; P : PNode);
var
  S : string;
begin
  S := '';
  while (P <> nil) do begin
    S += FormP(P);
    P := P^.N;
  end;
  if (S <> '') then begin
    if (S[1] = '+') then
      Delete(S, 1, 1);
    writeln(F, S);
  end;
end;

// Разбор многочлена
procedure ParseP(var P : PNode; S : string; I : integer);
var
  Sg : shortint;
begin
  if (I <= length(S)) then begin
    New(P);

    // Обрабатываем знак
    if ((I = length(S)) AND ((S[I] = '+') OR (S[I] = '-'))) then
      Error('Ошибка: знак должен стоять перед членом', S, I)
    else begin
      Sg := 1;
      if (S[I] = '-') then begin
        Sg := -1;
        inc(I);
      end else if (S[I] = '+') then
        inc(I);
 
      // Обработаем коэффициент
      P^.C := Sg*GetN(S, I);
    end;

    if (I <= length(S)) then
      if ((S[I] >= 'a') AND (S[I] <= 'z')) then begin
        P^.X := S[I];
        inc(I);

        if ((I <= length(S)) AND (S[I] = '^')) then begin
          if (I = length(S)) then
            Error('Ожидался показатель', S, I)
          else begin
            inc(I);
            if ((S[I] >= '0') AND (S[I] <= '9')) then
              P^.P := GetN(S, I)
            else
              Error('Неверный показатель', S, I);
          end;
        end else if ((I <= length(S)) AND (S[I] <> '+') 
                     AND (S[I] <> '-')) then
          Error('Ожидался знак операции', S, I)
        else
          P^.P := 1;

        ParseP(P^.N, S, I);
      end else
        Error('Ожидался идентификатор', S, I)
    else
      // Это просто константа
      P^.P := 0;
  end;
end;

// Удалить пробелы из строки
procedure Trim(var S : String);
var
  i, j : integer;
begin
  i := 1;
  j := 1;

  while (i <= Length(S)) do begin
    if (S[i] <> ' ') then begin
      S[j] := S[i];
      inc(j);
    end;
    inc(i);
  end;

  writeln(i , ' ', j);
  if (i <> j) then
    S := Copy(S, 1, j-1);
end;

// Прочитать многочлен
procedure ReadP(var F : text; var P : PNode);
var
  S : string;
  N : integer;
begin
  readln(F, S);
  Trim(S);
  N := 0;

  if (S <> '') then
    ParseP(P, S, 1)
  else
    Error('Файл содержит пустую строку', '', N);
end;

// Освободить память из-под многочлена
procedure FreeP(var P : PNode);
begin
  if (P <> nil) then begin
    FreeP(P^.N);
    Dispose(P);
    P := nil;
  end;
end;

// Копирование элемента
procedure CopyN(P1 : PNode; var P2 : PNode; Sg : integer);
begin
  if (P1 <> nil) then begin
    New(P2);
    P2^.C := P1^.C*Sg;
    P2^.P := P1^.P;
    P2^.X := P1^.X;
  end;
end;

// Копирование списка
procedure CopyP(P1 : PNode; var P2 : PNode; Sg : integer);
begin
  if (P1 <> nil) then begin
    CopyN(P1, P2, Sg);
    CopyP(P1^.N, P2^.N, Sg);
  end;
end;

// Слияние
procedure MergeP(P1, P2 : PNode; var P3 : PNode; Sg : integer);
begin
  // P1 = nil AND P2 = nil
  if (P1 <> P2) then begin
    if (P1 = nil) then
      CopyP(P2, P3, Sg)
    else if (P2 = nil) then
      CopyP(P1, P3, 1)
    else
    // Выберем член с наибольшей степенью
    if (P1^.P > P2^.P) then begin
      CopyN(P1, P3, 1);
      MergeP(P1^.N, P2, P3^.N, Sg)
    end else if (P1^.P < P2^.P) then begin
      CopyN(P2, P3, Sg);
      MergeP(P1, P2^.N, P3^.N, Sg)
    end else begin
      // Степени равны, складываем коэффициенты
      CopyN(P1, P3, 1);
      P3^.C += Sg*P2^.C;
      MergeP(P1^.N, P2^.N, P3^.N, Sg);
    end;
  
  end;
end;

// Сложение
procedure AddP(P1, P2 : PNode; var P3 : PNode);
begin
  MergeP(P1, P2, P3, 1);
end;

// Вычитание
procedure SubP(P1, P2 : PNode; var P3 : PNode);
begin
  MergeP(P1, P2, P3, -1);
end;

procedure Run(S : string);
var
  P1, P2, P3, P4 : PNode;
  F : text;
begin
  P1 := nil;
  P2 := nil;
  P3 := nil;
  P4 := nil;

  IsError := false;

  assign(F, S);
  reset(F);

  ReadP(F, P1);
  if (not IsError) then
    ReadP(F, P2);

  if (not IsError) then begin
    AddP(P1, P2, P3);
    SubP(P1, P2, P4);

    append(F);

    // WriteP(F, P1);
    // WriteP(F, P2);
    WriteP(F, P3);
    WriteP(F, P4);

    writeln('Задача успешно завершена');
  end else
    writeln('Выполнение задачи прервано из-за ошибки');

  close(F);

  FreeP(P1);
  FreeP(P2);
  FreeP(P3);
  FreeP(P4);
end;

function ToUp(var C : char) : char;
begin
  if ((C >= 'a') AND (C <= 'z')) then
    C := chr(ord(C) - ord('a') + ord('A'));
  ToUp := C;
end;

// Диалог с пользователем
procedure RunDialog;
var
  S : string;
begin
  S := '';

  repeat
    if (S <> '') then
      writeln('Файл с именем ', S, ' не существует!');
    write('Введите имя файла данных (N для возврата на верхний уровень): ');
    readln(S);
  until FileExists(S) OR (ToUp(S[1]) = 'N');

  if (S <> 'N') then
    Run(S);
end;

// Вывод справки
procedure Help;
begin
  writeln ('Помощь:');
  writeln (' ':4, 'R - запустить алгоритм');
  writeln (' ':4, 'N - выход из программы');
  writeln (' ':4, 'H - эта подсказка');
end;

var
  C : char;
begin
  repeat
    write('Введите команду (H для справки): ');
    readln(C);
    toup(C);
    case C of
      'H' : Help;
      'R' : RunDialog;
    end;
  until C = 'N';
end.

