program FileList;

uses
  Forms,
  main in 'main.pas' {fMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.

