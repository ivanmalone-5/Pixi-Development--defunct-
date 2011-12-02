unit uDLLManager;

interface
uses System.SysUtils,  System.Classes, Windows, uFindFile;

Type        TLoadDLLErrorEvent      =       TNotifyEvent;
Type        TUnloadDLLErrorEvent    =       TNotifyEvent;
Type        TOnDllBeforeLoadEvent   =       TNotifyEvent;
Type        TOnDllAfterLoadEvent    =       TNotifyEvent;
Type        TOnDllBeforeUnloadEvent =       TNotifyEvent;
Type        TOnDllAfterUnloadEvent  =       TNotifyEvent;
Type        TOnStateChangedEvent    =       TNotifyEvent;

Type        TDLLLoader              =       class(TComponent)
            Private
            FOnLoadDllErrorEvent    :       TLoadDllErrorEvent;
            FOnUnloadDllErrorEvent  :       TUnloadDllErrorEvent;
            FOnDllBeforeLoadEvent   :       TOnDllBeforeLoadEvent;
            FOnDllAfterLoadEvent    :       TOnDllAfterLoadEvent;
            FOnDllBeforeUnloadEvent :       TOnDllBeforeUnloadEvent;
            FOnDllAfterUnloadEvent  :       TOnDllAfterUnloadEvent;
            FOnStateChangedEvent    :       TOnStateChangedEvent;
            PROCEDURE FSetFileName(aFileName : TFileName); virtual;
            FUNCTION FIsLoaded() : boolean;
            Public
            CONSTRUCTOR Create(AOwner : TComponent); override;
            DESTRUCTOR Destroy(); override;
            FUNCTION LoadDll() : integer; virtual;
            FUNCTION UnloadDll() : boolean; virtual;
            Protected
            FFilename               :       TFileName;
            FHandle                 :       THandle;
            Published
            PROPERTY Filename : TFilename read FFileName write FSetFileName;
            PROPERTY Handle : THandle read FHandle;
            PROPERTY IsLoaded : boolean read FIsLoaded;
            PROPERTY OnLoadDllErrorEvent : TLoadDllErrorEvent read FOnLoadDllErrorEvent write FOnLoadDllErrorEvent;
            PROPERTY OnUnloadDllErrorEvent : TUnloadDllErrorEvent read FOnUnloadDllErrorEvent write FOnUnloadDllErrorEvent;
            PROPERTY OnDllBeforeLoadEvent : TOnDllBeforeLoadEvent read FOnDllBeforeLoadEvent write FOnDllBeforeLoadEvent;
            PROPERTY OnDllAfterLoadEvent : TOnDllAfterLoadEvent read FOnDllAfterLoadEvent write FOnDllAfterLoadEvent;
            PROPERTY OnDllBeforeUnloadEVent : TOnDllBeforeUnloadEvent read FOnDllBeforeUnloadEvent write FOnDllBeforeUnloadEvent;
            PROPERTY OnDllAfterUnloadEvent : TOnDllAfterUnloadEvent read FOnDllAfterUnloadEvent write FOnDllAfterUnloadEvent;
            PROPERTY OnStateChangedEvent : TOnStateChangedEvent read FOnStateChangedEvent write FOnStateChangedEvent;
end;


Type        TOnBeforeloadAllEvent   =         TNotifyEvent;
Type        TOnAfterLoadAllEvent    =         TNotifyEvent;
Type        TOnBeforeUnloadAllEvent =         TNotifyEvent;
Type        TOnAfterUnloadAllEvent  =         TNotifyEvent;
Type        TOnClearEvent           =         TNotifyEvent;
Type        TOnNavigateEvent        =         TNotifyEvent;
Type        TOnArrayNotInSyncError  =         TNotifyEvent;
Type        TOnBeforeAddEvent       =         TNotifyEvent;
Type        TOnAfterAddEvent        =         TNotifyEvent;
Type        TOnProgressEvent        =         PROCEDURE(Sender : TComponent; Min, Max, Current : Integer) of object;

Type        TMultiDLLLoader         =         class(TDLLLoader)
            Private
            FDLLHandles             :         array of THandle;
            FFileNames              :         array of TFileName;
            FCurrentIndex           :         integer;
            FOnBeforeLoadAllEvent   :         TOnBeforeLoadAllEvent;
            FOnAfterLoadAllEvent    :         TOnAfterLoadAllEvent;
            FOnBeforeUnloadAllEvent :         TOnBeforeUnloadAllEvent;
            FOnAfterUnloadAllEvent  :         TOnAfterUnloadAllEvent;
            FOnClearEvent           :         TOnClearEvent;
            FOnNavigateEvent        :         TOnNavigateEvent;
            FOnArrayNotInSyncError  :         TOnArrayNotInSyncError;
            FOnBeforeAddEvent       :         TOnBeforeAddEvent;
            FOnAfterAddEvent        :         TOnAfterAddEvent;
            FOnProgressEvent        :         TOnProgressEvent;
            PROCEDURE FSetFileName(aFileName : TFileName); override;
            FUNCTION FGetDLLCount() : integer; virtual;
            Public
            CONSTRUCTOR Create(AOwner : TComponent); override;
            DESTRUCTOR Destroy(); override;
            FUNCTION LoadAll() : boolean; virtual;
            FUNCTION UnloadAll() : boolean; virtual;
            PROCEDURE Clear(); virtual;
            PROCEDURE First(); virtual;
            PROCEDURE Last(); virtual;
            PROCEDURE Next(); virtual;
            PROCEDURE Back(); virtual;
            PROCEDURE Remove(); virtual;
            PROCEDURE Select(aIndex : integer); virtual;
            PROCEDURE Add(aFileName : TFileName); virtual;
            Published
            PROPERTY Handle : THandle read FHandle write FHandle;
            PROPERTY CurrentIndex : integer read FCurrentIndex;
            PROPERTY Count : integer read FGetDLLCount;
            PROPERTY OnBeforeLoadAllEvent : TOnBeforeLoadAllEvent read FOnBeforeLoadAllEvent write FOnBeforeLoadAllEVent;
            PROPERTY OnAfterLoadAllEvent : TOnAfterLoadAllEvent read FOnAfterLoadAllEvent write FOnAfterLoadAllEvent;
            PROPERTY OnBeforeUnloadAllEvent : TOnBeforeUnloadAllEvent read FOnBeforeUnloadAllEvent write FOnBeforeUnloadAllEvent;
            PROPERTY OnAfterUnloadALllEvent : TOnAfterUnloadAllEvent read FOnAfterUnloadAllEvent write FOnAfterUnloadAllEvent;
            PROPERTY OnClearEvent : TOnClearEvent read FOnClearEvent write FOnClearEvent;
            PROPERTY OnNavigateEvent : TOnNavigateEvent read FOnNavigateEvent write FOnNavigateEvent;
            PROPERTY OnArrayNotInSyncError : TOnArrayNotInSyncError read FOnArrayNotInSyncError write FOnArrayNotInSyncError;
            PROPERTY OnBeforeAddEvent : TOnBeforeAddEvent read FOnBeforeAddEvent write FOnBeforeAddEvent;
            PROPERTY OnAfterAddEvent : TOnAfterAddEvent read FOnAfterAddEvent write FOnAfterAddEvent;
            PROPERTY OnProgressEvent : TOnProgressEvent read FOnProgressEvent write FOnProgressEvent;

            Protected

end;

procedure Register();

implementation

PROCEDURE Register();
Begin
  RegisterComponents('Pixi',[TDLLLoader, TMultiDLLLoader]);
End;

CONSTRUCTOR TMultiDLLLoader.Create(AOwner : TComponent);
Begin
Inherited Create(AOwner);
Self.FCurrentIndex := 0;

SetLength(Self.FDLLHandles,0);
SetLength(Self.FFilename,0);

End;

DESTRUCTOR TMultiDLLLoader.Destroy();
Begin
if (Length(FDLLHandles) > 0) OR
   (Length(FFileNames) > 0) then
   Begin
   Clear;
   Finalize(FDLLHandles);
   Finalize(FFileNames);
   End;

Inherited Destroy();
End;

PROCEDURE TMultiDllLoader.Add(aFileName : TFileName);
Begin
if FileExists(aFileName) then
   Begin
   if Assigned(Self.FOnBeforeAddEvent) then FOnBeforeAddEvent(Self);

   SetLength(Self.FDLLHandles, Length(FDLLHandles) + 1);
   SetLength(Self.FFileNames, Length(FFileNames) + 1);

//   Select(High(FFileNames));

   FFileNames[High(FFileNames)] := aFileName;
   FDLLHandleS[High(FDLLHandles)] := 0;
   FFileName := aFileName;
   FHandle := 0;
   FCurrentIndex := (High(FFileNames));

   //Select(High(FDLLHandles));

   if Assigned(Self.FOnAfterAddEvent) then FOnAfterAddEvent(Self);
   Select(FCurrentIndex);

   End;
End;


PROCEDURE TMultiDllLoader.FSetFileName(aFileName : TFileName);
Begin
Inherited FSetFileName(aFileName);
FFileNames[CurrentIndex] := aFileName;
FDLLHandles[CurrentIndex] := FHandle;
End;

PROCEDURE TMultiDllLoader.Remove();
Var
  TempArray1  : array of TFileName;
  TempArray2  : array of THandle;
  i           : integer;
  j           : integer;
Begin
if Count > 0 then
  Begin
  if Handle > 0 then UnloadDll;

  SetLength(TempArray1, Length(FFileNames) - 1);
  SetLength(TempArray2, Length(FDLLHandles) - 1);

  j := 0;
   for i := Low(FFileNames) to High(FFileNames) do
       Begin
       if i <> CurrentIndex then
           Begin
           TempArray1[j] := FFileNames[i];
           TempArray2[j] := FDLLHandles[i];
           End
       ELSE
          Begin
             Inc(j,1);
           End;
        Inc(j,1);
        End;

   SetLength(FFileNames,Length(TempArray1));
   SetLength(FDLLHandles,Length(TempArray2));

   for i := Low(FFileNames) to High(FFileNames) do
        Begin
        FFileNames[i] := TempArray1[i];
        FDLLHandles[i] := TempArray2[i];
        End;

   SetLength(TempArray1,0);
   SetLength(TempArray2,0);

   Finalize(TempArray1);
   Finalize(TempArray2);

   FCurrentIndex := 0;

   End;
End;

FUNCTION TMultiDLLLoader.LoadAll() : boolean;
Begin
Result := False;
if Count > 0 then
   Begin
   if Assigned(Self.FOnBeforeLoadAllEvent) then OnBeforeLoadAllEvent(Self);
   First;
   while CurrentIndex < (Count - 1) do
      Begin
      if Assigned(FOnProgressEvent) then OnProgressEvent(Self,0,Count - 1, CurrentIndex);
      LoadDll;
      Next;
      End;
   LoadDll;
   Result := True;
   if Assigned(Self.FOnAfterLoadAllEvent) then OnAfterLoadAllEvent(Self);
   End;
End;

FUNCTION TMultiDLLLoader.UnloadAll() : boolean;
Begin
Result := False;
if Count > 0 then
   Begin
   if Assigned(Self.FOnBeforeUnLoadAllEvent) then OnBeforeUnLoadAllEvent(Self);
   Last;
   while Self.CurrentIndex > 0 do
      Begin
      if Assigned(FOnProgressEvent) then OnProgressEvent(Self,0,Count - 1, CurrentIndex);
      UnloadDll;
      Back;
      End;
   UnloadDll;
   Result := True;
   if Assigned(Self.FOnAfterUnLoadAllEvent) then Self.OnAfterUnloadALllEvent(Self);
   End;
End;


PROCEDURE TMultiDllLoader.Select(aIndex : integer);
Begin
if (aIndex <= (Count - 1)) AND
   (aIndex >= 0) then
      Begin

      if CurrentIndex >= 0 then
         Begin
         FFileNames[CurrentIndex] := FFileName;
         FDLLHandles[CurrentIndex] := FHandle;
         End;

      FCurrentIndex := aIndex;
      FFileName := FFileNames[aIndex];
      FHandle := FDLLHandles[aIndex];
      if Assigned(Self.FOnNavigateEvent) then OnNavigateEvent(Self);
      if Assigned(Self.FOnStateChangedEvent) then OnStateChangedEvent(Self);
      End;
End;

FUNCTION TMultiDLLLoader.FGetDLLCount() : integer;
Begin
if Length(FDLLHandles) <> Length(FFileNames) then
   Begin
     // somehow, the two arrays got out of sync
   SetLength(FDLLHandles,0);
   SetLength(FFileNames, 0);
   Result := 0;
   if Assigned(Self.FOnArrayNotInSyncError) then OnArrayNotInSyncError(Self);
   End
ELSE
   Begin
     Result := Length(FFileNames);
   End;

End;

PROCEDURE TMultiDLLLoader.Clear();
Begin
UnloadAll;
SetLength(FDLLHandles,0);
SetLength(FFileNames,0);
if Assigned(FOnClearEvent) then OnClearEvent(Self);
if Assigned(Self.FOnStateChangedEvent) then OnStateChangedEvent(Self);
End;

PROCEDURE TMultiDLLLoader.First();
Begin
if Count > 0 then
   Begin
   Select(0);
   End;
End;

PROCEDURE TMultiDLLLoader.Last();
Begin
if Count > 0 then
   Begin
   Select(Count - 1);
   End;
End;

PROCEDURE TMultiDLLLoader.Next();
Begin
if Count > 0 then
   Begin
   Select(CurrentIndex + 1);
   End;
End;

PROCEDURE TMultiDLLLoader.Back();
Begin
if Count > 0 then
   Begin
   Select(CurrentIndex - 1);
   End;
End;



CONSTRUCTOR TDLLLoader.Create(AOwner : TComponent);
Begin
Inherited Create(AOwner);
FFileName := '';
FHandle := 0;

End;

DESTRUCTOR TDLLLoader.Destroy();
Begin
if Handle > 0 then UnloadDll;
Inherited Destroy();
End;

FUNCTION TDLLLoader.FIsLoaded() : boolean;
begin
if Self.Handle > 0 then result := true else result := false;
end;

PROCEDURE TDLLLoader.FSetFileName(aFileName : TFileName);
Begin
if FileExists(aFileName) then
   Begin
   if FHandle > 0 then UnloadDll;
   FFileName := aFileName;
   if Assigned(FOnStateChangedEvent) then OnStateChangedEvent(Self);
   End;
End;



FUNCTION TDLLLoader.LoadDll() : integer;
Begin
if Handle = 0 then
  Begin
  Try
        Begin
        if Assigned(FOnDllBeforeLoadEvent) then OnDllBeforeLoadEvent(Self);

        FHandle := LoadLibrary(PChar(FileName));
        Result := FHandle;

        if FHandle = 0 then
           Begin
             if Assigned(Self.FOnLoadDllErrorEvent) then
             Begin
             OnLoadDllErrorEvent(Self);
             if Assigned(FOnStateChangedEvent) then OnStateChangedEvent(Self);
             Exit;
             End;
           End;

        if Assigned(FOnDllAfterLoadEvent) then OnDllAfterLoadEvent(Self);
       End;
   Except
        Begin
        Result := 0;
        if Assigned(FOnLoadDllErrorEvent) then OnLoadDllErrorEvent(Self);
        End;
   End;
  End
ELSE
  Begin
    Result := FHandle;
  End;
if Assigned(FOnStateChangedEvent) then OnStateChangedEvent(Self);
End;


FUNCTION TDLLLoader.UnloadDll() : boolean;
Begin
Result := False;
if Handle > 0 then
   Begin
    Try
          Begin
          if Assigned(FOnDllBeforeUnLoadEvent) then OnDllBeforeUnLoadEvent(Self);
          FreeLibrary(FHandle);
          FHandle := 0;
          Result := True;
          if Assigned(FOnDllAfterUnLoadEvent) then OnDllAfterUnLoadEvent(Self);
          End;
      Except
          Begin
          FHandle := 0;
          Result := False;
          if Assigned(FOnUnloadDllErrorEvent) then FOnUnloadDllErrorEvent(Self);
          End;
      End;
   if Assigned(FOnStateChangedEvent) then OnStateChangedEvent(Self);
   End;
End;







end.