unit Avtor2;

interface

uses
  Forms, ShellAPI, Controls, Classes, Menus, StdCtrls;

type
  TfInfa = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Edit1: TEdit;
    PopupMenu1: TPopupMenu;
    Cop1: TMenuItem;
    Label1: TLabel;
    procedure Cop1Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
  end;

const
  SW_SHOW = 5;

var
  fInfa: TfInfa;

implementation

{$R *.dfm}

procedure TfInfa.Cop1Click(Sender: TObject);
begin
  Edit1.SelectAll;
  Edit1.CopyToClipboard;
end;

procedure TfInfa.Label5Click(Sender: TObject);
begin
  ShellExecute(Handle, nil, 'mailto:mansiper@e1.ru', nil, nil, SW_SHOW);
end;

end.
