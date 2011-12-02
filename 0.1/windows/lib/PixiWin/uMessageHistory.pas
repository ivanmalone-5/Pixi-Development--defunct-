unit uMessageHistory;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, uComponents, uFormFader,
  Vcl.ActnList, Vcl.ToolWin;

type
  TfrmMessageHistory = class(TForm)
    ListView: TListView;
    ToolBar1: TToolBar;
    ActionList: TActionList;
    actClearHistory: TAction;
    btnClearHistory: TToolButton;
    SaveDialog: TFileSaveDialog;
    actSaveHistory: TAction;
    btnSep1: TToolButton;
    btnSaveToFile: TToolButton;
    procedure actClearHistoryExecute(Sender: TObject);
    procedure actSaveHistoryExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PROCEDURE AddMessage(Var aMessage : TNotificationItemEx);
  end;


  PROCEDURE ShowMessageHistory(AOwner : TComponent; Visible : Boolean);
  PROCEDURE AddMessage(Var aMessage : TNotificationItemEx);


var
  frmMessageHistory: TfrmMessageHistory;

implementation
uses uNotifications;
{$R *.dfm}

PROCEDURE ShowMessageHistory(AOwner : TComponent; Visible : Boolean);
Begin
   if NOT Assigned(frmMessageHistory) then
      Begin
      frmMessageHistory := TfrmMessageHistory.Create(AOwner);
      End;
if Visible then frmMessageHistory.Show;
end;

PROCEDURE AddMessage(Var aMessage : TNotificationItemEx);
Begin
  if Assigned(frmMessageHistory) then
     Begin
       frmMessageHistory.AddMessage(aMessage);
     End;
End;



procedure TfrmMessageHistory.actClearHistoryExecute(Sender: TObject);
begin
ListView.Clear;
if assigned(frmNotifications) then
   Begin
   frmNotifications.NotifyQue.ClearHistory;
   End;
end;

procedure TfrmMessageHistory.actSaveHistoryExecute(Sender: TObject);
begin
SaveDialog.Execute;
end;

PROCEDURE TfrmMessageHistory.AddMessage(var aMessage: TNotificationItemEx);
Var
  ListItem      :       TListItem;
begin
ListItem := ListView.Items.Add;
ListItem.Caption := aMessage.AMessage.Title;
ListItem.SubItems.Add(aMessage.AMessage.Header);
ListItem.SubItems.Add(aMessage.AMessage.AMessage);
ListItem.SubItems.Add(DateToStr(aMessage.Date));
ListItem.SubItems.Add(TimeToStr(aMessage.Time));

case aMessage.AMessage.NotificationType of
  ntTest: Begin
          ListItem.SubItems.Add('Test');
          End;

  end;

end;


Initialization
  Begin

  End;
Finalization
  Begin
 // if Assigned(frmMessageHistory) then frmMessageHistory.Free;

  End;

end.
