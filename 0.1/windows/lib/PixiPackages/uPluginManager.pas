Unit uPluginManager;

interface
uses System.SysUtils,  System.Classes, Windows, uDLLManager;

Const
      FUNC_IsValidPlugin        =   'IsValidPlugin';

TYPE  TFUNCBoolean              =   FUNCTION() : boolean; stdcall;


Type TPluginManager             =    class(TMultiDLLLoader)
      Private
      FUNCTION FIsValidPlugin() : boolean;
      Public
      CONSTRUCTOR Create(AOwner : TComponent); override;
      DESTRUCTOR Destroy(); override;
      Published
      PROPERTY IsValidPlugin : boolean read FIsValidPlugin;
      Protected
end;

implementation


FUNCTION TPluginManager.FIsValidPlugin() : boolean;
Var
   EIsValidPlugin          :       TFUNCBoolean;
begin
Result := False; // RESULT of True can only come from plugin
if Self.IsLoaded then // is dll loaded before we try
  Begin
  @EIsValidPlugin := GetProcAddress(Handle,PChar(FUNC_IsValidPlugin)); // get remote procedure
  if @EIsValidPlugin <> nil then // check to make sure it was found
     Begin
     // remote procedure is found, call it IsValidPlugin procedure
      if EIsValidPlugin then
         Begin
            // success, considered valid
            Result := True;
         End
      ELSE
         Begin
           // anything else, not valid
           Result := False;
         End;
      End;
     End
  ELSE
      Begin
      // remote procecudre was not found, report false;
        Result := False;
      End;

EIsValidPlugin := nil;
end;



CONSTRUCTOR TPluginManager.Create(AOwner : TComponent);
Begin
Inherited Create(AOwner);
End;

DESTRUCTOR TPluginManager.Destroy();
Begin
Inherited Destroy();
End;

end.
