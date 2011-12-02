unit uMiscFuncs;

interface
uses Classes, Sysutils, Windows, Controls;

    FUNCTION FTaskBarHeight(): integer;
    FUNCTION MouseWithinBounds(Left,Top,Width,Height : Integer) : boolean;

implementation


FUNCTION FTaskBarHeight(): integer;
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

FUNCTION MouseWithinBounds(Left,Top,Width,Height : integer) : boolean;
Begin
         if (Mouse.CursorPos.X >= Left) AND
               (Mouse.CursorPos.X <= Left + Width) AND
               (Mouse.CursorPos.Y >= Top) AND
               (Mouse.CursorPos.Y <= Top + Height) then
               Begin
                 Result := True;
               End
            else
               Begin
                 Result := False;
               End;

End;


end.
