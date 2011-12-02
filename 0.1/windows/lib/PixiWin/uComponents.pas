unit uComponents;

interface
uses System.SysUtils,  System.Classes, Vcl.Graphics,
   Vcl.Forms, Vcl.Dialogs;



Type TNotificationType          =         (ntTest, ntNone);

Type TNotificationItem          =         record
      Title                     :         string;
      Header                    :         string;
      AMessage                  :         string;
      ImageFilename             :         TFileName;
      NotificationType          :         TNotificationType;
end;


Type TNotificationItemEx        =         record
      AMessage                  :         TNotificationItem;
      Date                      :         TDate;
      Time                      :         TTime;
      Viewed                    :         Boolean;
end;

Type TNotifyQue                 =         class(TComponent)
      Private
      FNotifyQue                :         array of TNotificationItemEx;
      FNotifyHistory            :         array of TNotificationItemEx;
      FIsChanged                :         boolean;
      FCurrentIndex             :         integer;
      FUNCTION FAddMessage(aMessage : TNotificationItem) : integer;
      PROCEDURE FRemoveMessage(aIndex : integer);
      FUNCTION FCountMessages() : integer;
      FUNCTION FCountHistory() : integer;
      FUNCTION FGetMessage(aIndex : integer) : TNotificationItem;
      PROCEDURE FClearMessages();
      PROCEDURE FAddToHistory(aIndex : integer);
      Public
      CONSTRUCTOR Create(Aowner : TComponent); override;
      DESTRUCTOR Destroy(); override;
      FUNCTION AddMessage(aMessage : TNotificationItem) : integer;
      PROCEDURE RemoveMessage(aIndex : integer);
      FUNCTION GetMessage(aIndex : integer) : TNotificationItem;
      PROCEDURE ClearMessages();
      PROCEDURE GetHistory(Var aHistory : array of TNotificationItemEx);
      PROCEDURE ClearHistory();
      FUNCTION FirstMessage() : TNotificationItemEx;
      FUNCTION LastMessage() : TNotificationItemEx;
      FUNCTION NextMessage() : TNotificationItemEx;
      FUNCTION PreviousMessage() : TNotificationItemEx;
      FUNCTION CurrentMessageIndex() : integer;
      Published
      PROPERTY CountMessages : Integer read FCountMessages;
      PROPERTY CountHistory : integer read FCountHistory;
      PROPERTY IsChanged : boolean read FIsChanged;
      Protected
end;

implementation







CONSTRUCTOR TNotifyQue.Create(Aowner : TComponent);
Begin
  Inherited Create(AOwner);

  FCurrentIndex := 0;

  SetLength(FNotifyQue,0);
  SetLength(FNotifyHistory, 0);

  FIsChanged := False;
End;

DESTRUCTOR TNotifyQue.Destroy();
Begin
  SetLength(FNotifyHistory,0);
  SetLength(FNotifyQue,0);

  Finalize(FNotifyHistory);
  Finalize(FNotifyQue);
  Inherited Destroy();
End;

FUNCTION TNotifyQue.FCountHistory() : integer;
Begin
Result := Length(Self.FNotifyHistory);
End;

FUNCTION TNotifyQue.FAddMessage(aMessage : TNotificationItem) : integer;
Begin
SetLength(FNotifyQue, (Length(FNotifyQue) + 1));

FNotifyQue[High(FNotifyQue)].Viewed := False;
FNotifyQue[High(FNotifyQue)].Date := Date;
FNotifyQue[High(FNotifyQue)].Time := Time;
FNotifyQue[High(FNotifyQue)].AMessage := aMessage;

FIsChanged := True;

Result := High(FNotifyQue);
if FCurrentIndex < 0 then FCurrentIndex := 0;

End;

FUNCTION TNotifyQue.AddMessage(aMessage : TNotificationItem) : integer;
Begin
  Result := FAddMessage(aMessage);
End;

PROCEDURE TNotifyQue.FRemoveMessage(aIndex : integer);
Var
  TempArray     :       array of TNotificationItemEx;
  i             :       integer;
Begin
for i := Low(FNotifyQue) to High(FNotifyQue) do
   Begin
   if i <> aIndex then
      Begin
      SetLength(TempArray, (i+1));
      TempArray[High(TempArray)] := FNotifyQue[i];
      End;
   End;

SetLength(FNotifyQue,Length(TempArray));

for i := Low(TempArray) to High(TempArray) do
   Begin
   FNotifyQue[i] := TempArray[i];
   End;

SetLength(TempArray,0);
Finalize(TempArray);

FIsChanged := True;
End;

PROCEDURE TNotifyQue.RemoveMessage(aIndex : integer);
Begin
FRemoveMessage(aIndex);
End;

FUNCTION TNotifyQue.FCountMessages() : integer;
Begin
Result := Length(FNotifyQue);
End;

FUNCTION TNotifyQue.FGetMessage(aIndex : integer) : TNotificationItem;
Begin
if (aIndex >= 0) and (FCountMessages > 0) then
   Begin
   FNotifyQue[aIndex].Viewed  :=    True;
   FIsChanged                 :=    True;
   Result                     :=    FNotifyQue[aIndex].AMessage;
   End
else
   Begin
   Result.Title := '';
   Result.Header := '';
   Result.AMessage := '';
   Result.ImageFilename := '';
   Result.NotificationType := ntNone;
   End;
End;

FUNCTION TNotifyQue.GetMessage(aIndex : integer) : TNotificationItem;
Begin
  Result := FGetMessage(aIndex);
End;

PROCEDURE TNotifyQue.FClearMessages();
Var
  i   :   integer;
Begin
for i := Low(FNotifyQue) to High(FNotifyQue) do
   Begin
   Self.FAddToHistory(i);
   End;

SetLength(FNotifyQue,0);
Self.FCurrentIndex := -1;

FIsChanged := True;
End;

PROCEDURE TNotifyQue.ClearMessages();
Begin
FClearMessages;
End;


PROCEDURE TNotifyQue.FAddToHistory(aIndex : integer);
Begin
  SetLength(FNotifyHistory,(Length(FNotifyHistory) + 1));
  FNotifyHistory[High(FNotifyHistory)].AMessage := GetMessage(aIndex);
  FNotifyHistory[High(FNotifyHistory)].Date := Date;
  FNotifyHistory[High(FNotifyHistory)].Time := Time;
  FNotifyHistory[High(FNotifyHistory)].Viewed := True;
  FRemoveMessage(aIndex);
End;


PROCEDURE TNotifyQue.GetHistory(Var aHistory : array of TNotificationItemEx);
Var
  i : integer;
Begin
if Length(aHistory) = Length(FNotifyHistory) then
   Begin
   for i := Low(FNotifyHistory) to High(FNotifyHistory) do
      Begin
      aHistory[i] := FNotifyHistory[i];
     End;
   End;
End;


PROCEDURE TNotifyQue.ClearHistory();
Begin
SetLength(Self.FNotifyHistory,0);
End;


FUNCTION TNotifyQue.FirstMessage() : TNotificationItemEx;
Begin
if Self.CountMessages > 0 then
   Begin
   FCurrentIndex := 0;
   Result := Self.FNotifyQue[0];
   End;
End;

FUNCTION TNotifyQue.LastMessage() : TNotificationItemEx;
Begin
if Self.CountMessages > 0 then
   Begin
   FCurrentIndex := High(FNotifyQue);
   Result := Self.FNotifyQue[High(FNotifyQue)];
   End;
End;

FUNCTION TNotifyQue.NextMessage() : TNotificationItemEx;
Begin
if FCurrentIndex < High(FNotifyQue) then
   Begin
   Inc(FCurrentIndex,1);
   Result := FNotifyQue[FCurrentIndex];
   End;
End;

FUNCTION TNotifyQue.PreviousMessage() : TNotificationItemEx;
Begin
if FCurrentIndex > 0 then
   Begin
   Dec(FCurrentIndex,1);
   Result := FNotifyQue[FCurrentIndex];
   End;
End;

FUNCTION TNotifyQue.CurrentMessageIndex() : integer;
Begin
Result := FCurrentIndex;
End;


end.
