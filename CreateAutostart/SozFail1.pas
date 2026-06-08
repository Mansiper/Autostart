unit SozFail1;

interface

uses
  Forms, ShlObj, ExtCtrls, Dialogs, Controls, StdCtrls, Buttons, Classes,
  SysUtils, Windows;

type
  TfGlav = class(TForm)
    bGotovo: TButton;
    ePut: TEdit;
    bPutFail: TButton;
    eNazvanie: TEdit;
    mKomment: TMemo;
    Label1: TLabel;
    odFail: TOpenDialog;
    Label2: TLabel;
    sbSozd: TSpeedButton;
    sbIzm: TSpeedButton;
    cbSpisok: TComboBox;
    bUdal: TButton;
    od1: TOpenDialog;
    bPutPapka: TButton;
    sd1: TSaveDialog;
    lProga: TLabel;
    Timer1: TTimer;
    lPor: TLabel;
    procedure sbSozdClick(Sender: TObject);
    procedure sbIzmClick(Sender: TObject);
    procedure bPutFailClick(Sender: TObject);
    procedure bUdalClick(Sender: TObject);
    procedure bGotovoClick(Sender: TObject);
    procedure cbSpisokChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bPutPapkaClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure lProgaClick(Sender: TObject);
    procedure lPorClick(Sender: TObject);
  end;

type
  TSpisok = packed record
    Imya: String[70];     //Имя файла
    Put: String[255];     //Полный путь к файлу
    Komment: String[255]; //Комментарий к файлу
  end;

const
  clRed=$0000FF;
  clWhite=$FFFFFF;

var
  VybF: Boolean;      //True - выбран файл, False - выбрана папка
  ImF: String;        //Полный путь к рабочему файлу
  PP: String;         //Полный путь к программе (без имени)
  Spisok: Array of TSpisok; //Массив записей
  fGlav: TfGlav;

procedure ZagFail;
procedure Zapis;
function MyMessageDialog(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; Captions: array of string): Integer;

implementation

uses OProge2, Por3, uPapka;

{$R *.dfm}

procedure TfGlav.FormCreate(Sender: TObject);
var
  MDRez: Integer;
  F: TextFile;
begin
  VybF:=True;

  PP:=Application.ExeName;
  PP:=ExtractFilePath(PP);

  If not FileExists(PP+'AutoZap.daz') then     //Проверка наличия файла
  Begin
    MDRez:=MyMessageDialog('Файл ''AutoZap.dat'' не найден!'+#13+
      '''Открыть'' - открыть существующий файл'+#13+
      '''Создать'' - создать новый',
      mtInformation, mbYesNoCancel, ['Открыть', 'Создать', 'Отмена']);
    if MDRez=mrYes then                     //Открытие существующего файла
    begin
      od1.InitialDir:=PP;
      if od1.Execute then
      begin
        ImF:=od1.FileName;
        ZagFail;
      end
      else Application.Terminate;
    end
    else if MDRez=mrNo then                 //Создание нового файла
    begin
      sd1.InitialDir:=PP;
      sd1.Title:='Создание файла данных автозапуска';
      sd1.FileName:='AutoZap.daz';
      if sd1.Execute then
      begin
        ImF:=sd1.FileName;
        AssignFile(F, ImF);
        Rewrite(F);
        CloseFile(F);
        SetLength(Spisok, 1);
      end
      else Application.Terminate;
    end
    else                                    //Отмена
      Application.Terminate;
  End//If not FileExists(PP+'AutoZap.daz') then

  Else                                      //Файл существует.
  Begin
    ImF:=PP+'AutoZap.daz';
    ZagFail;
  End;
end;

procedure TfGlav.sbSozdClick(Sender: TObject);
begin
  ePut.Clear;
  eNazvanie.Clear;
  mKomment.Clear;

  If sbSozd.Down then               //Выбрали "Создание"
  begin
    cbSpisok.Hide;
    bUdal.Hide;
    bGotovo.Caption:='&Добавить';
  End
  Else if not sbSozd.Down then      //Выбрали "Изменение"
  Begin
    sbIzm.Down:=True;
    cbSpisok.Show;
    bUdal.Show;
    bGotovo.Caption:='&Изменить';
    cbSpisok.ItemIndex:=-1;
  End;
end;

procedure TfGlav.sbIzmClick(Sender: TObject);
begin
  ePut.Clear;
  eNazvanie.Clear;
  mKomment.Clear;

  If sbIzm.Down then                //Выбрали "Изменение"
  Begin
    cbSpisok.Show;
    bUdal.Show;
    bGotovo.Caption:='&Изменить';
    cbSpisok.ItemIndex:=-1;
  End
  Else if not sbIzm.Down then       //Выбрали "Создание"
  Begin
    cbSpisok.Hide;
    bUdal.Hide;
    sbSozd.Down:=True;
    bGotovo.Caption:='&Добавить';
  End;
end;

procedure TfGlav.bPutFailClick(Sender: TObject);
var
  Str: String;
begin
  odFail.InitialDir:=PP;
  If odFail.Execute then
  Begin
    Str:=odFail.FileName;
    Delete(Str, 1, Length(PP));
    Str:='Zz:\'+Str;
    ePut.Text:=Str;
    VybF:=True;
  End;
end;

procedure TfGlav.bPutPapkaClick(Sender: TObject);
var
  Str: String;
begin
  fPapka.ShowModal;
  If fPapka.ModalResult=mrOK then
  Begin
    Str:=fPapka.dlb1.Directory;
    Delete(Str, 1, Length(PP));
    Str:='Zz:\'+Str;
    ePut.Text:=Str;
    VybF:=False;
  End;
  fGlav.Enabled:=True;
end;

procedure TfGlav.bUdalClick(Sender: TObject);
var
  i: Word;
begin
  If cbSpisok.Text<>'' then
  Begin
    if MyMessageDialog('Вы действительно желаете удалить текущую запись?',
      mtConfirmation, mbOKCancel, ['Да', 'Отмена'])=mrOK then
    begin
      for i:=cbSpisok.ItemIndex+1 to High(Spisok) do
        Spisok[i-1]:=Spisok[i];
      if High(Spisok)>1 then
        Spisok:=Copy(Spisok, 0, High(Spisok)-1);

      Zapis;
      ZagFail;
      eNazvanie.Text:='';
      ePut.Text:='';
      mKomment.Lines.Text:='';
      cbSpisok.Text:='';
      lProga.Caption:='Удалено';
      lProga.Font.Color:=clRed;
      lProga.Cursor:=crDefault;
      Timer1.Enabled:=True;

    end;//else if MMD=mrYes then
  End;//If ComboBox1.Text<>'' then
end;

procedure TfGlav.bGotovoClick(Sender: TObject);
var
  i, Osh: Integer;
  St, Ras: String;
begin
  If cbSpisok.Visible and (cbSpisok.Text='') then
  Begin
    ShowMessage('Выберите запись для изменения.');
    Exit;
  End;

  If ePut.Text<>'' then     //Настройка пути - отложить переделку (слишком много)
  Begin
    if Pos('Zz:\', ePut.Text)<>1 then
    begin
      ShowMessage('Неверный путь к файлу/папке!'+#13#10+'Прочтите справку.');
      Exit;
    end;
  End
  Else
  Begin
    ShowMessage('Укажите путь к файлу/папке.');
    Exit;
  End;

  If eNazvanie.Text='' then //Назначение названия записи при его отсутствии
  Begin
    St:=ExtractFileName(ePut.Text); //Получение имени и расширения у файла
    Ras:=ExtractFileExt(St);
    Delete(Ras, 1, 1);
    i:=Pos(Ras, St);
    Delete(St, i-1, Length(St));
    if (Length(Ras)<=5) and VybF then
    begin
      if (Ras='rar')or(Ras='zip')or(Ras='7z') then
        eNazvanie.Text:=St+' (архив '+Ras+')'
      else if (Ras='iso')or(Ras='mdf') then
        eNazvanie.Text:=St+' (образ '+Ras+')'
      else if (Ras='key')or(Ras='reg') then
        eNazvanie.Text:=St+' (ключ реестра '+Ras+')'
      else if (Ras='avi')or(Ras='mpg')or(Ras='wmv')or(Ras='mpg')or(Ras='mpeg')or
        (Ras='flv')or(Ras='mp4')or(Ras='mov')or(Ras='3gp')or(Ras='vob') then
        eNazvanie.Text:=St+' (видео '+Ras+')'
      else if (Ras='mp3')or(Ras='wav')or(Ras='ogg')or(Ras='wma')or(Ras='mp2')or
        (Ras='ac3')or(Ras='aac')or(Ras='ra') then
        eNazvanie.Text:=St+' (аудио '+Ras+')'
      else if (Ras='html')or(Ras='htm')or(Ras='mht') then
        eNazvanie.Text:=St+' (страница '+Ras+')'
  		else if (Ras='exe')or(Ras='com')or(Ras='cmd')or(Ras='bat') then
        eNazvanie.Text:=St+' (приложение '+Ras+')'
      else
        eNazvanie.Text:=St+' (файл '+Ras+')';
    end
    else if not VybF then eNazvanie.Text:=St+' (папка)'
    else if Length(Ras)>5 then eNazvanie.Text:=St;

    if ePut.Text='Zz:\' then
      eNazvanie.Text:='Корневой каталог';
  End;//if eNazvanie.Text='' then

  If ( sbSozd.Down and (eNazvanie.Text<>'') and (ePut.Text<>'') ) OR
    ( sbIzm.Down and (cbSpisok.Text<>'') and (eNazvanie.Text<>'') and
    (ePut.Text<>'') ) then
  Begin
    Osh:=0;
    for i:=0 to High(Spisok) do   //Проверка совпадений имён и путей
    begin
      if cbSpisok.Visible and (i=cbSpisok.ItemIndex) then Continue;

      //Проверка по имени
      if ( not cbSpisok.Visible and (eNazvanie.Text=Spisok[i].Imya) ) OR
      ( cbSpisok.Visible and (eNazvanie.Text=Spisok[i].Imya) and
      (eNazvanie.Text<>cbSpisok.Text) ) then
        Osh:=1;

      //Проверка по пути
      if ePut.Text=Spisok[i].Put then
        Inc(Osh, 2);

      if Osh<>0 then Break;
    end;//for i:=0 to High(Spisok) do

    if not cbSpisok.Visible and (Osh<>0) then
    begin
      case Osh of
        1:  St:='Данные с таким названием уже записаны.'+#13+'Переписать их?';
        2:  St:='Данные с таким адресом уже записаны.'+#13+'Переписать их?';
        3:  begin
              MyMessageDialog('Данные с таким названием и адресом уже записаны.',
                mtConfirmation, [mbOK], ['Добро']);
              Exit;
            end;
      end;

      if MyMessageDialog(St, mtConfirmation, mbOkCancel,
        ['Да', 'Отмена'])=mrOk then
      begin
        Spisok[i].Imya:=eNazvanie.Text;
        Spisok[i].Put:=ePut.Text;
        Spisok[i].Komment:=mKomment.Lines.Text;
      end
      else Exit;    
    end//if not ComboBox1.Visible and (Osh<>0) then
    else if cbSpisok.Visible and (Osh<>0) then
    begin
      case Osh of
        1:  MyMessageDialog('Данные с таким названием уже записаны.',
              mtConfirmation, [mbOK], ['Добро']);
        2:  MyMessageDialog('Данные с таким адресом уже записаны.',
              mtConfirmation, [mbOK], ['Добро']);
        3:  MyMessageDialog('Данные с таким названием и адресом уже записаны.',
              mtConfirmation, [mbOK], ['Добро']);
      end;
      Exit;
    end//else if ComboBox1.Visible and (Osh<>0) then

    else if  sbSozd.Down and (Osh=0) then
    begin
      if Spisok[i].Imya<>'' then
        SetLength(Spisok, High(Spisok)+1); 
      i:=High(Spisok);
      Spisok[i].Imya:=eNazvanie.Text;
      Spisok[i].Put:=ePut.Text;
      Spisok[i].Komment:=mKomment.Lines.Text;
    end
    else if sbIzm.Down and (Osh=0) then
    begin
      i:=cbSpisok.ItemIndex;
      Spisok[i].Imya:=eNazvanie.Text;
      Spisok[i].Put:=ePut.Text;
      Spisok[i].Komment:=mKomment.Lines.Text;
    end;

    i:=cbSpisok.ItemIndex;
    Zapis;
    ZagFail;
    cbSpisok.ItemIndex:=i;
    cbSpisok.Text:=eNazvanie.Text;
    lProga.Font.Color:=clRed;
    lProga.Cursor:=crDefault;
    if sbSozd.Down=True then
      lProga.Caption:='Сохранено'
    else if sbSozd.Down=False then
      lProga.Caption:='Изменено';
    lProga.Visible:=True;
    Timer1.Enabled:=True;
  End;
end;

procedure TfGlav.cbSpisokChange(Sender: TObject);
begin
  If cbSpisok.ItemIndex>=0 then
  Begin
    eNazvanie.Text:=Spisok[cbSpisok.ItemIndex].Imya;
    ePut.Text:=Spisok[cbSpisok.ItemIndex].Put;
    mKomment.Text:=Spisok[cbSpisok.ItemIndex].Komment;
  End;
end;

function MyMessageDialog(Const Msg: String; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; Captions: Array of String): Integer;
var
  aMsgDlg: TForm;
  i: Integer;
  dlgButton: TButton;
  CaptionIndex: Integer;
begin
  { Создаем диалог }
  aMsgDlg:=CreateMessageDialog(Msg, DlgType, Buttons);
  captionIndex:=0;
  { Цикл через объекты диалогового окна }
  for i:=0 to aMsgDlg.ComponentCount-1 do
  begin
   { Если объект типа TButton, тогда }
    if (aMsgDlg.Components[i] is TButton) then
    begin
      dlgButton:=TButton(aMsgDlg.Components[i]);
      if CaptionIndex>High(Captions) then Break;
      { Даем новый заголовок из массива Captions}
      dlgButton.Caption:=Captions[CaptionIndex];
      Inc(CaptionIndex);
    end;
  end;
  Result:=aMsgDlg.ShowModal;
end;

procedure TfGlav.Timer1Timer(Sender: TObject);
begin
  lProga.Caption:='О проге...';
  lProga.Font.Color:=clWhite;
  lProga.Cursor:=crHandPoint;
end;

procedure TfGlav.lProgaClick(Sender: TObject);
begin
  If lProga.Caption='О проге...' then
    fProga.ShowModal;
end;

procedure TfGlav.lPorClick(Sender: TObject);
begin
  fPoryadok.ShowModal;
end;

procedure ZagFail;
var
  i: Word;
  Buf: TSpisok;
  FS: TFileStream;
begin
  FS:=TFileStream.Create(ImF, fmOpenRead);

  Spisok:=nil;
  SetLength(Spisok, 1);
  fGlav.cbSpisok.Clear;
  i:=0;
  While FS.Position<FS.Size do
  Begin
    FS.ReadBuffer(Buf, SizeOf(Buf));
    Spisok[i]:=Buf;
    fGlav.cbSpisok.Items.Add(Spisok[i].Imya);
    Inc(i);
    SetLength(Spisok, i+1);
  End;

  FS.Free;
end;

procedure Zapis;
var
  i: Word;
  Buf: TSpisok;
  FS: TFileStream;
begin
  FS:=TFileStream.Create(ImF, fmCreate);

  For i:=0 to High(Spisok) do
  Begin
    Buf:=Spisok[i];
    if Buf.Imya<>'' then
      FS.WriteBuffer(Buf, SizeOf(Buf));
  End;

  FS.Free;
end;

end.
