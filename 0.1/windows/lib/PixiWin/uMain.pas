unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.RibbonLunaStyleActnCtrls, Vcl.Ribbon,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus,
  Vcl.StdCtrls, Vcl.OleCtrls, SHDocVw, ufraOptimizationStatus, Vcl.ColorGrd,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnList, uPluginlistView;

type
  TfrmMain = class(TForm)
    Ribbon1: TRibbon;
    RibbonPage5: TRibbonPage;
    Panel1: TPanel;
    RibbonGroup1: TRibbonGroup;
    ActionManager: TActionManager;
    RibbonGroup2: TRibbonGroup;
    RibbonGroup3: TRibbonGroup;
    RibbonGroup4: TRibbonGroup;
    RibbonPage1: TRibbonPage;
    RibbonGroup5: TRibbonGroup;
    RibbonPage2: TRibbonPage;
    RibbonGroup6: TRibbonGroup;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

end.
