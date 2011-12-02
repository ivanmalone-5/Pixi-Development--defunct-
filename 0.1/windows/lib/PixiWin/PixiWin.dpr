program PixiWin;

uses
  Vcl.Forms,
  uNotifications in 'uNotifications.pas' {frmNotifications},
  uMessageHistory in 'uMessageHistory.pas' {frmMessageHistory},
  uComponents in 'uComponents.pas',
  uMain in 'uMain.pas' {frmMain},
  ufraOptimizationStatus in 'ufraOptimizationStatus.pas' {fraOptimizationStatus: TFrame},
  uPluginlistView in 'uPluginlistView.pas' {fraPluginListView: TFrame},
  uConfiguration in 'uConfiguration.pas' {frmPixiConfiguration};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.