uses
  PT4;

function Expression(var S : string; var i : integer) : integer; forward;
function Term(var S : string; var i : integer) : integer; forward;
function Element(var S : string; var i : integer) : integer; forward;

function Expression(var S : string; var i : integer) : integer;
var
  res : integer;
begin
  res := 0;
  
  if (i <= length(S)) then begin
    res := Term(s,i);
    while (i <= length(s)) and (s[i] <> ')') do begin
      case s[i] of
        '+':
          begin
            inc(i);
            res += Term(S,i);
          end;
        '-':
          begin
            inc(i);
            res -= Term(S, i);
          end;
      end;
    end;
    inc(i);
  end;
  Expression := res;
end;

function Term(var S : string; var i : integer) : integer;
var
  res : integer;
begin
  res := 0;
  
  if (i <= length(s)) then begin
    res := Element(S, i);
    while (i < length(s)) and (s[i] = '*') do begin
      inc(i);
      res *= Element(S, i);
    end;
  end;
  
  Term := res;
end;

function Element(var S : string; var i : integer) : integer;
var
  res : integer;
begin
  res := 0;
  if (i <= length(s)) then begin
    if (s[i] = '(') then begin
      inc(i);
      res := Expression(S, i);
    end else begin
      res := ord(s[i]) - ord('0');
      inc(i);
    end;
    
  end;
  Element := res;
end;

var
  S : string;
  i : integer;
begin
  Task('Recur16');
  readln(S);
  i := 1;
  WriteLn(Expression(s,i));
end.
