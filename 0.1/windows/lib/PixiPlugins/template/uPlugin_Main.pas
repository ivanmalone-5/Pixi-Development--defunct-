unit uPlugin_Main;

interface
uses classes, sysutils;


FUNCTION IsValidPlugin() : boolean; export; stdcall;


Type  TPluginClient           =         class(TComponent)
      Private
      FIsValidPlugin          :         boolean;
      Public
      CONSTRUCTOR Create(AOwner : TComponent); override;
      DESTRUCTOR Destroy(); override;
      Published
      PROPERTY IsValidPlugin : boolean read FIsValidPlugin write FIsValidPlugin;
      Protected
end;


  PROCEDURE OnDllInitilization();
  PROCEDURE OnDllFinilization();



implementation
Var
  PluginClient : TPluginClient;


FUNCTION IsValidPlugin() : boolean; export; stdcall;
Begin
  if assigned(PluginClient) then
    Begin
    // this should always report true if the plugin is to work at all
    Result := PluginClient.IsValidPlugin;
    End;
End;


CONSTRUCTOR TPluginClient.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  IsValidPlugin := True;
end;

DESTRUCTOR TPluginClient.Destroy;
begin
  Inherited Destroy();
end;


PROCEDURE OnDllInitilization();
Begin
if not Assigned(PluginClient) then
   Begin
     // Create plugin client
     PluginClient := TPluginClient.Create(nil);

   End;

End;


PROCEDURE OnDllFinilization();
Begin
if assigned(PluginClient) then
   Begin
     PluginClient.Free;
   End;

End;



INITIALIZATION
  Begin
  OnDllInitilization;
  End;

Finalization
  Begin
  OnDllFinilization;
  End;

end.