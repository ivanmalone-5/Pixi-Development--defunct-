program FFTest;

uses
  Forms,
  Main in 'C:\Users\morbidchimp\Desktop\Demo\Main.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
