unit AvtoZap1;

interface

uses
  Forms, ShellAPI, StdCtrls, Controls, Classes, SysUtils, Dialogs, Windows;

type
  TfGlav = class(TForm)
    ListBox1: TListBox;
    mKomment: TMemo;
    bStart: TButton;
    bInfa: TButton;
    bVyhod: TButton;
    procedure bVyhodClick(Sender: TObject);
    procedure bStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bInfaClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  end;

type
  TSpisok = packed record
    Imya: String[70];     //Название записи
    Put: String[255];     //Полный путь к файлу
    Komment: String[255]; //Комментарий к файлу
  end;

var
  OldIdx: Integer =-1;
  Disk: String;
  Spisok: Array of TSpisok;
  fGlav: TfGlav;

implementation

uses Avtor2, RTLConsts;

{$R *.dfm}

procedure TfGlav.FormCreate(Sender: TObject);
var
  i: Word;
  Buf: TSpisok;
  FS: TFileStream;
begin
  Disk:=Application.ExeName;
  Delete(Disk, 4, Length(Disk));

  If not FileExists(Disk+'AutoZap.daz') then     //Проверка наличия файла
  Begin
    MessageDlg('Нет файла данных!', mtError, [mbOK], 0);
    Exit;
  End;

  FS:=TFileStream.Create(Disk+'AutoZap.daz', fmOpenRead);

  SetLength(Spisok, 1);
  fGlav.ListBox1.Clear;
  i:=0;
  While FS.Position<FS.Size do
  Begin
    FS.ReadBuffer(Buf, SizeOf(Buf));
    Spisok[i]:=Buf;
    fGlav.ListBox1.Items.Add(Spisok[i].Imya);
    Inc(i);
    SetLength(Spisok, i+1);
  End;

  FS.Free;
end;

procedure TfGlav.bVyhodClick(Sender: TObject);
begin
  Close;
end;

procedure TfGlav.bStartClick(Sender: TObject);
var
  St: String;
begin
  ListBox1.SetFocus;
  
  If ListBox1.ItemIndex>=0 then
  Begin
    St:=Spisok[ListBox1.ItemIndex].Put;
    Delete(St, 1, 4);
    St:=Disk+St;

    if ShellExecute(Handle, nil, PChar(St), nil, nil, SW_SHOWNORMAL)<32 then
      MessageDlg('Не могу выполнить операцию!'{+#13+
        'Путь (файл): '''+St+''' не существует'},
        mtError, [mbOK], 0);
  End;
end;

procedure TfGlav.bInfaClick(Sender: TObject);
begin
  ListBox1.SetFocus;
  fInfa.ShowModal;
end;

procedure TfGlav.ListBox1DblClick(Sender: TObject);
begin
  bStart.Click;
end;

procedure TfGlav.ListBox1Click(Sender: TObject);
begin
  mKomment.Lines.Text:=Spisok[ListBox1.ItemIndex].Komment;
  If mKomment.Lines.Count>10 then
    mKomment.ScrollBars:=ssVertical
  Else if mKomment.Lines.Count<=10 then
    mKomment.ScrollBars:=ssNone;
end;

procedure TfGlav.ListBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Idx: Longint;
begin
  With Sender as TListBox do
  Begin
    Idx:=ItemAtPos(Point(x, y), True);
    if (Idx<0)or(Idx=OldIdx) then Exit;
    Application.ProcessMessages;
    Application.CancelHint;
    OldIdx:=Idx;
    Hint:='';
    if Canvas.TextWidth(Items[Idx])>((Sender as TListBox).Width-4) then
      Hint:=Items[Idx];
  End;
end;

end.
