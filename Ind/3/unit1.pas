unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Spin,
  StdCtrls, ExtCtrls, LCLIntf, Menus, GraphWork, unit2;

type

  { TMainForm }

  TMainForm = class(TForm)
    ApplySizeButton: TButton;
    GrassCoordLabel: TLabel;
    Label2: TLabel;
    HorseCoordLabel: TLabel;
    MainMenu1: TMainMenu;
    ExitItem: TMenuItem;
    AboutItem: TMenuItem;
    ParamItem: TMenuItem;
    TimeLabel: TLabel;
    MovesLabel: TLabel;
    ShowDistCheckBox: TCheckBox;
    Label1: TLabel;
    FieldPaintBox: TPaintBox;
    SizeSpinEdit: TSpinEdit;
    procedure AboutItemClick(Sender: TObject);
    procedure ApplySizeButtonClick(Sender: TObject);
    procedure ExitItemClick(Sender: TObject);
    procedure FieldPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure CalcPath;
    procedure ShowDistCheckBoxChange(Sender: TObject);
  private
    { private declarations }
    // Размер поля в клетках
    ChessSize : integer;
    Horse, Grass, Check : TPicture;
    HX, HY : integer;
    GX, GY : integer;
    M : Graph;
    Path : IArray;
    AboutBox : TAboutBox;
  public
    { public declarations }
  end;

// Размер клетки поля в пикселях
const
  CellSize = 40;
  INFILE = 'input.txt';
  OUTFILE = 'output.txt';

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  f : text;
begin
  FieldPaintBox.Width := SizeSpinEdit.MaxValue*CellSize;
  FieldPaintBox.Height := SizeSpinEdit.MaxValue*CellSize;

  Horse := TPicture.Create;
  Horse.LoadFromFile('kon2.png');

  Grass := TPicture.Create;
  Grass.LoadFromFile('gra2.png');

  Check := TPicture.Create;
  Check.LoadFromFile('che2.png');

  try
    // Считываем данные из файла
    AssignFile(f, INFILE);
    Reset(F);
    Readln(F, ChessSize);
    if (ChessSize < 5) or (ChessSize > 20) then
      ChessSize := 5;
    SizeSpinEdit.Value := ChessSize;
    Readln(F, HX, HY);
    if (HX < 1) or (HX > ChessSize) then
      HX := 0
    else
      dec(HX);
    if (HY < 1) or (HY > ChessSize) then
      HY := 0
    else
      dec(HY);
    Readln(F, GX, GY);
    if (GX < 1) or (GX > ChessSize) then
      GX := 0
    else
      dec(GX);
    if (GY < 1) or (GY > ChessSize) then
      GY := 0
    else
      dec(GY);
    CloseFile(F);
  except
    ChessSize := SizeSpinEdit.MinValue;
    HX := 0;
    HY := 0;

    GX := ChessSize - 1;
    GY := ChessSize - 1;
  end;

  CalcPath;
  AboutBox := TAboutBox.Create(self);
end;

procedure TMainForm.FormPaint(Sender: TObject);
var
  i, j : integer;
  ColorT : TColor;
  N : integer;
begin
  FieldPaintBox.Width:=CellSize*ChessSize;
  FieldPaintBox.Height:=CellSize*ChessSize;

  Width:=200+CellSize*ChessSize;
  Height:=CellSize*ChessSize;

  // Рисуем поле
  for i := 0 to ChessSize-1 do
    for j := 0 to ChessSize-1 do
      with FieldPaintBox.Canvas do begin
        // Выберем цвет клетки
        if ((ChessSize - i) + j) mod 2 = 1 then
          ColorT := RGB(70,35,0) // Темно-коричневый
        else
          ColorT := RGB(240, 240, 220); // Слоновая кость
        Pen.Color := ColorT;
        Brush.Color := ColorT;
        FillRect(i*CellSize, j*CellSize, (i+1)*CellSize, (j+1)*CellSize);
      end;

  with FieldPaintBox.Canvas do begin
    // Рамочка вокруг поля
    Pen.Color := clWhite;
    Brush.Color := clBlack;
    FrameRect(0,0,CellSize*ChessSize,CellSize*ChessSize);
    // Рисуем коня
    Draw(HX*CellSize+(CellSize-Horse.Bitmap.Width) div 2,
                      HY*CellSize,Horse.Bitmap);
    // Рисуем траву
    Draw(GX*CellSize+(CellSize-Grass.Bitmap.Width) div 2,
                      GY*CellSize,Grass.Bitmap);

    // Отображение пути
    N := HX + HY*ChessSize;
    i := -1;
    repeat
      inc(i);
      Draw((Path[i] mod ChessSize)*CellSize,
           (Path[i] div ChessSize)*CellSize,
            Check.Bitmap);
    until Path[i] = N;

    // Прорисуем доступные для прыжка клетки
    // Нужно же как-то проверить алгоритм генерации
    if (ShowDistCheckBox.Checked) then begin
      Pen.Color := clBlack;
      Brush.Color:=clWhite;
      for i := 0 to ChessSize-1 do
        for j := 0 to ChessSize-1 do
          TextOut(i*CellSize, j*CellSize, IntToStr(M[i][j]));
    end;
  end;
  HorseCoordLabel.Caption := 'Координаты коня: ' + IntToStr(HX+1)
                                                 + ',' + IntToStr(HY+1);
  GrassCoordLabel.Caption := 'Координаты травы: ' + IntToStr(GX+1)
                                                  + ',' + IntToStr(GY+1);
end;

procedure TMainForm.ApplySizeButtonClick(Sender: TObject);
begin
  // Изменим размеры поля
  ChessSize := SizeSpinEdit.Value;
  // Подвинем коня и траву
  if (HX >= ChessSize) or (HY >= ChessSize) then begin
    HX := 0;
    HY := 0;
  end;
  if (GX >= ChessSize) or (GY >= ChessSize) then begin
    GX := ChessSize-1;
    GY := ChessSize-1;
  end;
  CalcPath;
  Repaint;
end;

procedure TMainForm.AboutItemClick(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TMainForm.ExitItemClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.CalcPath;
var
  N : integer;
begin
  N := GetTickCount;
  // Рассчет пути коня
  BuildHorseMatrix2(M, ChessSize, HX, HY, GX, GY);
  ReverseWave(M, ChessSize, HX, HY, GX, GY, Path);
  //DumpTo(Path, ChessSize, 'Path.txt');
  N := GetTickCount - N;
  MovesLabel.Caption := 'Ходов коня: ' + IntToStr(M[GX][GY]);
  TimeLabel.Caption := IntToStr(N) + ' миллисекунд';
end;

procedure TMainForm.ShowDistCheckBoxChange(Sender: TObject);
begin
  Repaint;
end;

procedure TMainForm.FieldPaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NX, NY : integer;
begin
  if (ssLeft in Shift) then begin
    NX := X div CellSize;
    NY := Y div CellSize;
    if ((NX < ChessSize) and (NY < ChessSize)) then begin
      HX := NX;
      HY := NY;
    end;
  end else if (ssRight in Shift) then begin
    NX := X div CellSize;
    NY := Y div CellSize;
    if ((NX < ChessSize) and (NY < ChessSize)) then begin
      GX := NX;
      GY := NY;
    end;
  end;
  CalcPath;
  Repaint;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  f : text;
  i,N : integer;
begin
  Horse.Free;
  Grass.Free;
  Check.Free;
  assignFile(f, OUTFILE);
  rewrite(f);
  writeln(F, M[GX][GY]);
  N := -1;
  repeat
    inc(N);
  until (Path[N] = HX + HY*ChessSize);

  for i := N downto 0 do
    writeln(f, (Path[i] mod ChessSize) + 1, ' ', (Path[i] div ChessSize) + 1);

  closeFile(f);
end;

end.

