uses PT4;

{Нагло тырит исходные данные из задачника}

var
  f1,f2 : text;
  S : string;
begin
  // Номер задания можно менять
  Task('GraphWork13');
  read(S);
  assign(F1, S);
  reset(F1);
  
  // Имя выходного файла
  assign(F2, 'in25.txt');
  rewrite(F2);
  while (not EOF(F1)) do begin
    readln(F1,S);
    writeln(F2,S);
  end;
  close(F1);
  close(F2);
end.

