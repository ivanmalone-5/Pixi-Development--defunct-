unit ufraOptimizationStatus;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons;

type
  TfraOptimizationStatus = class(TFrame)
    lblTitle: TLabel;
    pnlLeft: TPanel;
    pnlRight: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ProgressBar: TProgressBar;
    ProgressBar1: TProgressBar;
    Label4: TLabel;
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfraOptimizationStatus.FrameResize(Sender: TObject);
begin
PnlLeft.Width := Width div 2;
pnlRight.Width := Width div 2;
end;

end.
