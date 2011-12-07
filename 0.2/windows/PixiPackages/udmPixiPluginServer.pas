unit udmPixiPluginServer;

interface

uses
  System.SysUtils, System.Classes, uDLLManager, uPluginManager, ComCtrls;

type
  TdmPixiPluginServer = class(TDataModule)
    PluginManager: TPluginManager;
    PixiPluginServer: TPixiPluginServer;
  private
    { Private declarations }
  public
    { Public declarations }
    CONSTRUCTOR Create(AOwner : TComponent); override;

  end;

var
  dmPixiPluginServer: TdmPixiPluginServer;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}


CONSTRUCTOR TdmPixiPluginServer.Create(AOwner : TComponent);
Begin
Inherited Create(AOwner);
End;


end.
