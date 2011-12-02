program DLLLoader;

uses
  Vcl.Forms,
  uDLLLoader in 'uDLLLoader.pas' {frmDLLLoader},
  uMultiDLLLoader in 'uMultiDLLLoader.pas' {frmMultiDllLoader};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMultiDllLoader, frmMultiDllLoader);
  Application.CreateForm(TfrmDLLLoader, frmDLLLoader);
  Application.Run;
end.
