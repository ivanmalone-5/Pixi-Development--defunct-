unit uFormFader;

interface
uses System.SysUtils,  System.Classes, Windows, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
     VCL.Controls;
{ TODO
      FORM Fader Dim capability [done]
      other form effects [wip]
}



Type TFormFader                 =         class(TComponent)
      Private
      FFadeMin                  :         integer;
      FFadeMax                  :         integer;
      FCurrentFade              :         integer;
      FAccountForTaskBarSize    :         boolean;
      FFadeStep                 :         integer;
      FOwner                    :         TComponent;
      FTimer                    :         TTimer;
      FFadeOnMouseEnterLeave    :         boolean;
      FActive                   :         boolean;
      FOnFinishedFadeOut        :         TNotifyEvent;
      FOnFinishedFadeIn         :         TNotifyEvent;
      PROCEDURE FOnTimerEvent(Sender : TObject);
      PROCEDURE FSetActive(aBool : Boolean);
      PROCEDURE FSetTimerInterval(aInterval : integer);
      FUNCTION FGetTimerInterval() : integer;
      FUNCTION FTaskBarHeight(): integer;
      Public
      CONSTRUCTOR Create(AOwner : TComponent); override;
      DESTRUCTOR Destroy(); override;
      PROCEDURE DoFadeOutStep();
      PROCEDURE DoFadeInStep();
      Published
      PROPERTY FadeMin : integer read FFadeMin write FFadeMin;
      PROPERTY FadeMax : integer read FFadeMax write FFadeMax;
      PROPERTY CurrentFade : integer read FCurrentFade write FCurrentFade;
      PROPERTY FadeStep : integer read FFadeStep write FFadeStep;
      PROPERTY Active : boolean read FActive write FSetActive;
      PROPERTY TimerInterval : integer read FGetTimerInterval write FSetTimerInterval;
      PROPERTY FadeOnMouseEnterOrLeave : boolean read FFadeOnMouseEnterLeave write FFadeOnMouseEnterLeave;
      PROPERTY OnFinishedFadeOut : TNotifyEvent read FOnFinishedFadeOut write FOnFinishedFadeOut;
      PROPERTY OnFinishedFadeIn : TNotifyEvent read FOnFinishedFadeIn write FOnFinishedFadeIn;
      PROPERTY AccountForTaskbarSize : boolean read FAccountForTaskbarSize write FAccountForTaskbarSize;
      Protected
end;

Type TFormScroller              =         class(TComponent)
      Private
      FScrollOffset             :         integer;
      FOwner                    :         TComponent;
      FTimer                    :         TTimer;
      FScrollOnMouseEnterLeave  :         boolean;
      FActive                   :         boolean;
      FOnFinishedScrollOut      :         TNotifyEvent;
      FOnFinishedScrollIn       :         TNotifyEvent;
      PROCEDURE FOnTimerEvent(Sender : TObject);
      PROCEDURE FSetActive(aBool : Boolean);
      PROCEDURE FSetTimerInterval(aInterval : integer);
      FUNCTION FGetTimerInterval() : integer;
      Public
      CONSTRUCTOR Create(AOwner : TComponent); override;
      DESTRUCTOR Destroy(); override;
      PROCEDURE DoScrollOutStep();
      PROCEDURE DoScrollInStep();
      Published
      PROPERTY ScrollOffset : integer read FScrollOffset write FScrollOffset;
      PROPERTY Active : boolean read FActive write FSetActive;
      PROPERTY TimerInterval : integer read FGetTimerInterval write FSetTimerInterval;
      PROPERTY ScrollOnMouseEnterOrLeave : boolean read FScrollOnMouseEnterLeave write FScrollOnMouseEnterLeave;
      PROPERTY OnFinishedScrollOut : TNotifyEvent read FOnFinishedScrollOut write FOnFinishedScrollOut;
      PROPERTY OnFinishedScrollIn : TNotifyEvent read FOnFinishedScrollIn write FOnFinishedScrollIn;
      Protected
end;



procedure Register();

implementation


procedure Register();
Begin
  RegisterComponents('Pixi',[TFormFader, TFormScroller]);
End;


// =============================================================================
CONSTRUCTOR TFormFader.Create(AOwner : TComponent);
Begin
Inherited Create(Aowner);
FAccountForTaskbarSize := False;
FTimer := TTimer.Create(Self);
FTimer.Enabled := False;
FTimer.Interval := 25;

Self.FActive := False;
Self.FadeOnMouseEnterOrLeave := True;

FTimer.OnTimer := FOnTimerEvent;
if NOT (AOwner is TForm) then
    Begin
    ShowMessage('The fader must be used on TForm');
    Free;
    End;

Self.FFadeMin := 0;
Self.FFadeMax := 255;
Self.FFadeStep := 17;

Self.FCurrentFade := 250;

with AOwner as TForm do
   Begin
   AlphaBlendValue := FCurrentFade;
   AlphaBlend := True;
   End;

FOwner := AOwner;
End;
// -----------------------------------------------------------------------------
DESTRUCTOR TFormFader.Destroy();
Begin
FTimer.Free;
FOwner := nil;
Inherited Destroy();
End;
// -----------------------------------------------------------------------------
PROCEDURE TFormFader.FSetActive(aBool : Boolean);
Begin
FActive := aBool;
FTimer.Enabled := aBool;
End;
// -----------------------------------------------------------------------------
PROCEDURE TFormFader.FSetTimerInterval(aInterval : integer);
Begin
FTimer.Interval := aInterval;
End;
// -----------------------------------------------------------------------------
FUNCTION TFormFader.FGetTimerInterval() : integer;
Begin
Result := FTimer.Interval;
End;
// -----------------------------------------------------------------------------
PROCEDURE TFormFader.FOnTimerEvent(Sender : TObject);
Begin
if Active = False then
   Begin
     FTimer.Enabled := false;
   End
ELSE
   Begin
   if Self.FFadeOnMouseEnterLeave then
      Begin
      With Self.Owner as TForm do
         Begin
         if Self.AccountForTaskBarSize then
            Begin
             if (Mouse.CursorPos.X >= Left) AND
                   (Mouse.CursorPos.X <= Left + Width) AND
                   (Mouse.CursorPos.Y >= Top) AND
                   (Mouse.CursorPos.Y <= Top + Height + FTaskBarHeight) then
                   Begin
                     DoFadeInStep;
                   End
                else
                   Begin
                     DoFadeOutStep;
                   End;
            End
         ELSE
            Begin
             if (Mouse.CursorPos.X >= Left) AND
                   (Mouse.CursorPos.X <= Left + Width) AND
                   (Mouse.CursorPos.Y >= Top) AND
                   (Mouse.CursorPos.Y <= Top + Height) then
                   Begin
                     DoFadeInStep;
                   End
                else
                   Begin
                     DoFadeOutStep;
                   End;

            End;
         End;
      End;
   End;
End;
// -----------------------------------------------------------------------------
PROCEDURE TFormFader.DoFadeOutStep();
Begin
if CurrentFade > FadeMax then FCurrentFade := FadeMax;
if CurrentFade < FadeMin then FCurrentFade := FadeMin;

if (Self.CurrentFade > Self.FadeMin) then
   Begin
   Dec(FCurrentFade,FadeStep);
   if CurrentFade < FadeMin then FCurrentFade := FadeMin;

   with FOwner as TForm do
      Begin
        AlphaBlendValue := FCurrentFade;
      End;
   if CurrentFade <= FadeMin then
     Begin
       if Assigned(Self.FOnFinishedFadeOut) then OnFinishedFadeOut(Self);
     End;
   End;
End;
// -----------------------------------------------------------------------------
PROCEDURE TFormFader.DoFadeInStep();
Begin
if CurrentFade > FadeMax then FCurrentFade := FadeMax;
if CurrentFade < FadeMin then FCurrentFade := FadeMin;

if (Self.CurrentFade < Self.FadeMax) then
   Begin
   Inc(FCurrentFade,FadeStep);
   if CurrentFade > FadeMax then FCurrentFade := FadeMax;
   with FOwner as TForm do
      Begin
        AlphaBlendValue := FCurrentFade;
      End;
   if CurrentFade <= FadeMin then
     Begin
       if Assigned(Self.FOnFinishedFadeOut) then OnFinishedFadeOut(Self);
     End;
   End;
End;
// -----------------------------------------------------------------------------
FUNCTION TFormFader.FTaskBarHeight(): integer;
var
  hTB: HWND; // taskbar handle
  TBRect: TRect; // taskbar rectangle
begin
  hTB:= FindWindow('Shell_TrayWnd', '');
  if hTB = 0 then
    Result := 0
  else begin
    GetWindowRect(hTB, TBRect);
    Result := TBRect.Bottom - TBRect.Top;
  end;
end;
// =============================================================================








// =============================================================================
CONSTRUCTOR TFormScroller.Create(AOwner : TComponent);
Begin
Inherited Create(Aowner);

FTimer := TTimer.Create(Self);
FTimer.Enabled := False;
FTimer.Interval := 25;

Self.FActive := False;
//Self.ScrollOnMouseEnterOrLeave := True;

FTimer.OnTimer := FOnTimerEvent;
if NOT (AOwner is TForm) then
    Begin
    ShowMessage('The Scroller must be used on TForm');
    Free;
    End;


Self.FScrollOffset := 5;
with AOwner as TForm do
   Begin
    // Setup Parent form
    //AlphaBlendValue := FCurrentScroll;
    //AlphaBlend := True;
   Top := 0;
   Left := Screen.Width - Width;
   Height := Screen.Height;
   End;

FOwner := AOwner;
End;
// -----------------------------------------------------------------------------
DESTRUCTOR TFormScroller.Destroy();
Begin
FTimer.Free;
FOwner := nil;
Inherited Destroy();
End;
// -----------------------------------------------------------------------------
PROCEDURE TFormScroller.FSetActive(aBool : Boolean);
Begin
FActive := aBool;
FTimer.Enabled := aBool;
End;
// -----------------------------------------------------------------------------
PROCEDURE TFormScroller.FSetTimerInterval(aInterval : integer);
Begin
FTimer.Interval := aInterval;
End;
// -----------------------------------------------------------------------------
FUNCTION TFormScroller.FGetTimerInterval() : integer;
Begin
Result := FTimer.Interval;
End;
// -----------------------------------------------------------------------------
PROCEDURE TFormScroller.FOnTimerEvent(Sender : TObject);
Begin
if Active = False then
   Begin
     FTimer.Enabled := false;
   End
ELSE
   Begin
   if Self.FScrollOnMouseEnterLeave then
      Begin
      With Self.Owner as TForm do
         Begin
         if (Mouse.CursorPos.X >= Left) AND
               (Mouse.CursorPos.X <= Left + Width) AND
               (Mouse.CursorPos.Y >= Top) AND
               (Mouse.CursorPos.Y <= Top + Height) then
               Begin
                 DoScrollInStep;
               End
            else
               Begin
                 DoScrollOutStep;
               End;
         End;
      End;
   End;
End;
// -----------------------------------------------------------------------------
PROCEDURE TFormScroller.DoScrollOutStep();
Begin
with FOwner as TForm do
      Begin
      if Left <= 0 then Left := Left - Self.ScrollOffset;
      End;
End;
// -----------------------------------------------------------------------------
PROCEDURE TFormScroller.DoScrollInStep();
Begin
 with FOwner as TForm do
    Begin
    if (Left <= 0) AND (Left >= (0 - Width)) then Left := Left + Self.ScrollOffset;
    End;
End;
// =============================================================================

end.
