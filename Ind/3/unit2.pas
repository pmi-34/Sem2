unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, LCLType, ExtCtrls;

type

  { TAboutBox }

  TAboutBox = class(TForm)
    AboutBoxLabel: TLabel;
    Button1: TButton;
    Image1: TImage;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AboutBox: TAboutBox;

procedure ShowError(E : PChar);

implementation

{$R *.lfm}

procedure ShowError(E : PChar);
begin
  Application.MessageBox(E,
                 'Произошла ошибка',
                 MB_OK OR MB_ICONERROR)
end;

{ TAboutBox }

procedure TAboutBox.Button1Click(Sender: TObject);
begin
  Close;
end;

end.

