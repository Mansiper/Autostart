unit Por3;

interface

uses
  Forms, StdCtrls, Controls, Classes, Buttons;

type
  TfPoryadok = class(TForm)
    ListBox1: TListBox;
    sbVverh: TSpeedButton;
    bOtmena: TButton;
    sbVniz: TSpeedButton;
    bGotovo: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure sbVverhClick(Sender: TObject);
    procedure bGotovoClick(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure sbVnizClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
  fPoryadok: TfPoryadok;

implementation

uses SozFail1;

{$R *.dfm}

procedure TfPoryadok.FormShow(Sender: TObject);
var
  i: Integer;
begin
  Top:=fGlav.Height DIV 2 - Height DIV 2 + fGlav.Top;
  Left:=fGlav.Width DIV 2 - Width DIV 2 + fGlav.Left;

  ListBox1.Clear;
  For i:=0 to High(Spisok) do
    if Spisok[i].Imya<>'' then
      ListBox1.Items.Add(Spisok[i].Imya);
  ListBox1.SetFocus;
end;

procedure TfPoryadok.BitBtn1Click(Sender: TObject);
begin
  ListBox1.SetFocus;
end;

procedure TfPoryadok.sbVverhClick(Sender: TObject);
var
  i: Integer;
begin
  i:=ListBox1.ItemIndex;
  if ListBox1.ItemIndex>0 then
  begin
    ListBox1.Items.Move(ListBox1.ItemIndex, ListBox1.ItemIndex-1);
    ListBox1.ItemIndex:=i-1;
  end;
  ListBox1.SetFocus;
end;

procedure TfPoryadok.sbVnizClick(Sender: TObject);
var
  i: Integer;
begin
  i:=ListBox1.ItemIndex;
  if (ListBox1.ItemIndex<ListBox1.Count-1)and(ListBox1.ItemIndex<>-1) then
  begin
    ListBox1.Items.Move(ListBox1.ItemIndex, ListBox1.ItemIndex+1);
    ListBox1.ItemIndex:=i+1;
  end;
  ListBox1.SetFocus;
end;

procedure TfPoryadok.bGotovoClick(Sender: TObject);
var
  i, j: Word;
  Sp: Array of TSpisok;
begin
  SetLength(Sp, ListBox1.Count);

  For i:=0 to ListBox1.Count-1 do
    for j:=0 to High(Spisok) do
      if ListBox1.Items.Strings[i]=Spisok[j].Imya then
      begin
        Sp[i]:=Spisok[j];
        Break;
      end;

  For i:=0 to High(Sp) do
    Spisok[i]:=Sp[i];
  Spisok:=Copy(Spisok, 0, High(Sp)+1);
  Sp:=nil;

  Zapis;
  ZagFail;
end;

procedure TfPoryadok.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
{  if Key=#4129#4115 then    //Key_Control+Key_Up
    if ListBox1.ItemIndex>0 then
      ListBox1.Items.Move(ListBox1.ItemIndex, ListBox1.ItemIndex-1);  }
end;

end.
