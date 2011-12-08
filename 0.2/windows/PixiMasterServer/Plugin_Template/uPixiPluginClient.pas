unit uPixiPluginClient;

interface



FUNCTION IsValidPlugin() : boolean; stdcall; export;

implementation

FUNCTION IsValidPlugin() : boolean; stdcall; export;
Begin
  Result := false;
End;

FUNCTION DoInit() : boolean; stdcall; export;
Begin
  Result := True;
End;

FUNCTION DoDeInit() : boolean; stdcall; export;
Begin
  Result := True;
End;



exports IsValidPlugin, DoInit, DoDeInit;

end.
