unit uPapka;

interface

uses
  Forms, StdCtrls, Controls, FileCtrl, Classes;

type
  TfPapka = class(TForm)
    lTekst1: TLabel;
    dlb1: TDirectoryListBox;
    bGotovo: TButton;
    bOtmena: TButton;
    procedure FormShow(Sender: TObject);
  end;

var
  fPapka: TfPapka;

implementation

uses SozFail1;

{$R *.dfm}                

procedure TfPapka.FormShow(Sender: TObject);
begin
  Top:=fGlav.Height DIV 2 - Height DIV 2 + fGlav.Top;
  Left:=fGlav.Width DIV 2 - Width DIV 2 + fGlav.Left;
  dlb1.SetFocus;  
end;

end.
