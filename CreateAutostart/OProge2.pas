unit OProge2;

interface

uses
  Forms, Menus, StdCtrls, Controls, ComCtrls, Classes, ShellAPI;

type
  TfProga = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Edit1: TEdit;
    PopupMenu1: TPopupMenu;
    Cop1: TMenuItem;
    Label6: TLabel;
    procedure Label5Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Cop1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

const
  SW_SHOW=5;

var
  fProga: TfProga;

implementation

uses SozFail1;

{$R *.dfm}

procedure TfProga.PageControl1Change(Sender: TObject);
begin
  If PageControl1.ActivePageIndex=1 then
  Begin
    if Edit1.Visible then
      Edit1.SetFocus;
  End
  Else if PageControl1.ActivePageIndex=2 then
    Close;
end;

procedure TfProga.Label5Click(Sender: TObject);
begin
  ShellExecute(Handle, nil, 'mailto:mansiper@e1.ru', nil, nil, SW_SHOW);
end;

procedure TfProga.Cop1Click(Sender: TObject);
begin
  Edit1.SelectAll;
  Edit1.CopyToClipboard;
end;

procedure TfProga.FormShow(Sender: TObject);
begin
  Top:=fGlav.Height DIV 2 - Height DIV 2 + fGlav.Top;
  Left:=fGlav.Width DIV 2 - Width DIV 2 + fGlav.Left;
  PageControl1.Pages[0].Show;
end;

end.                             
