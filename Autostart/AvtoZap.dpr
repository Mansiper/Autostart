program AvtoZap;

uses
  Forms,
  AvtoZap1 in 'AvtoZap1.pas' {fGlav},
  Avtor2 in 'Avtor2.pas' {fInfa};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Автозапуск';
  Application.CreateForm(TfGlav, fGlav);
  Application.CreateForm(TfInfa, fInfa);
  Application.Run;
end.
