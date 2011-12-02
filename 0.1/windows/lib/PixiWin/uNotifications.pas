unit uNotifications;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ImgList,
  Vcl.Imaging.pngimage, uComponents, uFormFader, Vcl.Menus, Vcl.ActnList, uMiscFuncs;




type
  TfrmNotifications = class(TForm)
    pnlTop: TPanel;
    pnlMiddle: TPanel;
    pnlBottom: TPanel;
    imgIcon: TImage;
    lblTitle: TLabel;
    lblMessage: TLabel;
    lblHeader: TLabel;
    TrayIcon: TTrayIcon;
    lblFooter: TLabel;
    btnRight: TImage;
    btnLeft: TImage;
    UpdateTimer: TTimer;
    lblMessageCount: TLabel;
    FormFader: TFormFader;
    Button1: TButton;
    ProgressImages: TImageList;
    MessageChangeTimer: TTimer;
    PopupMenu: TPopupMenu;
    ActionList: TActionList;
    actShutdown: TAction;
    mnuShutdown: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    procedure lblFooterClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure FormFaderFinishedFadeOut(Sender: TObject);
    procedure MessageChangeTimerTimer(Sender: TObject);
    procedure FormFaderFinishedFadeIn(Sender: TObject);
    procedure actShutdownExecute(Sender: TObject);
  private
    { Private declarations }
    FirstShow : boolean;

  public
  NotifyQue               :       TNotifyQue;
  ActiveMessage           :       TNotificationItem;
  PROCEDURE ViewMessage(aIndex : integer);
    { Public declarations }
  end;

var
  frmNotifications: TfrmNotifications;

implementation
uses uMessageHistory;
{$R *.dfm}

procedure TfrmNotifications.MessageChangeTimerTimer(Sender: TObject);
begin
if Visible then
begin
if Self.NotifyQue.CurrentMessageIndex <= NotifyQue.CountMessages -1  then
   Begin
     Self.btnRight.OnClick(Self);
   End;
if NotifyQue.CurrentMessageIndex = NotifyQue.CountMessages - 1 then
   Begin
     MessageChangeTimer.Enabled := false;
   End;
end;
end;






procedure TfrmNotifications.actShutdownExecute(Sender: TObject);
begin
Application.Terminate;
end;

procedure TfrmNotifications.btnLeftClick(Sender: TObject);
begin
MessageChangeTimer.Enabled := False;
if NotifyQue.CountMessages > 0 then
   Begin
   NotifyQue.PreviousMessage;
   ViewMessage(NotifyQue.CurrentMessageIndex);
   End
ELSE
   Begin
   NotifyQue.FirstMessage;
   ViewMessage(NotifyQue.CurrentMessageIndex);
   End;
end;

procedure TfrmNotifications.btnRightClick(Sender: TObject);
begin
MessageChangeTimer.Enabled := False;
if NotifyQue.CountMessages > 0 then
   Begin
   NotifyQue.NextMessage;
   ViewMessage(NotifyQue.CurrentMessageIndex);
   End
ELSE
   Begin
   NotifyQue.FirstMessage;
   ViewMessage(NotifyQue.CurrentMessageIndex);
   End;
end;

procedure TfrmNotifications.Button1Click(Sender: TObject);
Var
  aMessage : TNotificationItem;
begin
aMessage.Title := 'Title: ' + TimeToStr(Time);
aMessage.Header := 'Header: ' + TimeToStr(Time);
aMessage.AMessage := 'Message: ' + TimeToStr(Time) + ' - ' + DateToStr(Date);
aMessage.NotificationType := ntTest;

NotifyQue.AddMessage(aMessage);
end;

procedure TfrmNotifications.FormCreate(Sender: TObject);
Var
  i : integer;
  aMessage : TNotificationItem;
begin
// Setup the form


BorderStyle := bsSizeToolWin;
BorderStyle := bsNone;
Color := clWhite;
FormStyle := fsStayOnTop;
Self.GlassFrame.Enabled := True;
Self.GlassFrame.SheetOfGlass := True;
Self.DoubleBuffered := True;
FirstShow := True;
// Loop through components and setup common layout and styles
for i := 0 to Self.ComponentCount - 1 do
     Begin
     // For each TPanel do
     if Self.Components[i] is TPanel then
        Begin
        with Self.Components[i] as TPanel do
           Begin
           BorderStyle := bsNone;
           BevelInner := bvNone;
           BevelOuter := bvNone;
           // Color := clWhite;
           Color := $00408000;

           End;
        End
     // For each TLabel do
     else if Self.Components[i] is TLabel then
          Begin
          With Self.Components[i] as TLabel do
             Begin
             Autosize := False;
             Wordwrap := True;
             Font.Name := 'Segoe UI';
             Font.Color := clWhite;
             End;
          End;
     End;

// Setup individual styles
pnlBottom.BevelOuter := bvNone;
//pnlBottom.Color := $00F5EFF0;
//pnlBottom.Color := $00408000  ;

// pnlTop.Color := $00408000;
//pnlTop.color := $00408000;

lblMessage.Font.Size := 10;
//lblMessage.Font.Color := clBlue;

lblTitle.Font.Size := 8;
lblTitle.Font.Style := [fsBold];

lblFooter.Font.Size := 8;
//lblFooter.Font.Color := clBlue;
lblFooter.Align := alBottom;

lblMessageCount.Font.Size := 8;
//lblMessageCount.Font.Color := clBlue;
lblMessageCount.Align := alBottom;


// Create Additional Components
NotifyQue := TNotifyQue.Create(Self);
ActiveMessage.Title := 'Title';
ActiveMessage.Header := 'Header';
ActiveMessage.AMessage := 'A Message';
ActiveMessage.ImageFilename := '';

aMessage.Title := 'Pixi is loading';
aMessage.Header := 'Please wait...';
aMessage.AMessage := 'Pixi is starting up...';
aMessage.NotificationType := ntTest;

NotifyQue.AddMessage(aMessage);
ActiveMessage.AMessage := 'Sometimes, the best solution, is not the simplest solution';
NotifyQue.AddMessage(aMessage);
ActiveMessage.AMessage := 'Welcome to the world of the election and the switch, the beauty of the baud';
NotifyQue.AddMessage(aMessage);

Self.ViewMessage(0);

FormFader.FadeMin := 0;
FormFader.FadeMax := 255;
FormFader.FadeStep := 15;
FormFader.CurrentFade := FormFader.FadeMin;
Self.AlphaBlend := True;
Self.AlphaBlendValue := FormFader.CurrentFade;

end;

procedure TfrmNotifications.FormDestroy(Sender: TObject);
begin
// Destroy Additional Components

NotifyQue.ClearMessages;
NotifyQue.Free;

end;


procedure TfrmNotifications.FormFaderFinishedFadeIn(Sender: TObject);
begin
MessageChangeTimer.Enabled := TRUE;
end;

procedure TfrmNotifications.FormFaderFinishedFadeOut(Sender: TObject);
begin
Visible := False;
end;

procedure TfrmNotifications.FormShow(Sender: TObject);
begin
Left := Screen.Width - Width;
Top := 0;

Height := Screen.Height - uMiscFuncs.FTaskBarHeight;
Width := 300;

Self.FormFader.Active := true;
sELF.FormFader.FadeOnMouseEnterOrLeave := True;
Self.MessageChangeTimer.Enabled := true;
end;

procedure TfrmNotifications.lblFooterClick(Sender: TObject);
Var
  i : integer;
  aMessagesEx : array of TNotificationItemEx;
begin
NotifyQue.ClearMessages;

SetLength(aMessagesEx, NotifyQue.CountHistory);
NotifyQue.GetHistory(aMessagesEx);

uMessageHistory.ShowMessageHistory(Self, false);

frmMessageHistory.ListView.Items.BeginUpdate;
frmMessageHistory.ListView.Items.Clear;

for i := Low(aMessagesEx) to High(aMessagesEx) do
   Begin
   uMessageHistory.AddMessage(aMessagesEx[i]);
   End;

frmMessageHistory.ListView.Items.EndUpdate;

SetLength(aMessagesEx,0);
Finalize(aMessagesEx,0);

uMessageHistory.ShowMessageHistory(Self,True);
end;

procedure TfrmNotifications.TrayIconClick(Sender: TObject);
begin
if Not Visible then
   Begin
    FirstShow := False;
    Visible := True;
    Show;
   End
else
   Begin
     Visible := false;
   End;
end;

procedure TfrmNotifications.UpdateTimerTimer(Sender: TObject);
begin
   if NotifyQue.CurrentMessageIndex >= 0 then
      Begin
      lblMessageCount.Caption := 'Message: ' +  IntToStr((1 +NotifyQue.CurrentMessageIndex)) +
                                 ' of: ' + IntToStr(NotifyQue.CountMessages);

      End
   ELSE
      Begin
      lblMessageCount.Caption := 'No messages';

      if NotifyQue.CountHistory > 0 then
         Begin
         lblMessageCount.Caption := lblMessageCount.Caption + ' (' + IntToStr(NotifyQue.CountHistory) + ')';
         End;
      End;


if FirstShow then
   Begin
     Visible := false;
     FirstShow := True;
   End;


end;

PROCEDURE TfrmNotifications.ViewMessage(aIndex : integer);
Begin
if aIndex <= NotifyQue.CountMessages - 1 then
   Begin
   ActiveMessage := NotifyQue.GetMessage(aIndex);
   Self.lblTitle.Caption := ActiveMessage.Title;
   Self.lblMessage.Caption := ActiveMessage.AMessage;
   Self.lblHeader.Caption := ActiveMessage.Header;
   End;


End;

end.
