program SozFail;

uses
  Forms,
  SozFail1 in 'SozFail1.pas' {fGlav},
  OProge2 in 'OProge2.pas' {fProga},
  Por3 in 'Por3.pas' {fPoryadok},
  uPapka in 'uPapka.pas' {fPapka};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Создание автозапуска';
  Application.CreateForm(TfGlav, fGlav);
  Application.CreateForm(TfProga, fProga);
  Application.CreateForm(TfPoryadok, fPoryadok);
  Application.CreateForm(TfPapka, fPapka);
  Application.Run;
end.
