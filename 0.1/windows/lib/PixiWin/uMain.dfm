object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Welcome to Pixi Utilities for Windows'
  ClientHeight = 494
  ClientWidth = 835
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  GlassFrame.Enabled = True
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Ribbon1: TRibbon
    Left = 0
    Top = 0
    Width = 835
    Height = 143
    ActionManager = ActionManager
    Caption = 'Welcome to Pixi Utilities for Windows'
    Tabs = <
      item
        Caption = 'Welcome'
        Page = RibbonPage5
      end
      item
        Caption = 'My Account'
        Page = RibbonPage1
      end
      item
        Caption = 'Help'
        Page = RibbonPage2
      end>
    TabIndex = 2
    DesignSize = (
      835
      143)
    StyleName = 'Ribbon - Luna'
    object RibbonPage5: TRibbonPage
      Left = 0
      Top = 50
      Width = 834
      Height = 93
      Caption = 'Welcome'
      Index = 0
      object RibbonGroup1: TRibbonGroup
        Left = 4
        Top = 3
        Width = 158
        Height = 86
        ActionManager = ActionManager
        Caption = 'Get Started'
        GroupIndex = 0
        object Button1: TButton
          Left = 57
          Top = 2
          Width = 97
          Height = 25
          Caption = 'Button1'
          TabOrder = 0
        end
      end
      object RibbonGroup2: TRibbonGroup
        Left = 164
        Top = 3
        Width = 100
        Height = 86
        ActionManager = ActionManager
        Caption = 'What is Pixi?'
        GroupIndex = 1
      end
      object RibbonGroup3: TRibbonGroup
        Left = 266
        Top = 3
        Width = 112
        Height = 86
        ActionManager = ActionManager
        Caption = 'Pixi in Action'
        GroupIndex = 2
      end
      object RibbonGroup4: TRibbonGroup
        Left = 380
        Top = 3
        Width = 100
        Height = 86
        ActionManager = ActionManager
        Caption = 'Download Pixi'
        GroupIndex = 3
      end
    end
    object RibbonPage1: TRibbonPage
      Left = 0
      Top = 50
      Width = 834
      Height = 93
      Caption = 'My Account'
      Index = 1
      object RibbonGroup5: TRibbonGroup
        Left = 4
        Top = 3
        Width = 100
        Height = 86
        ActionManager = ActionManager
        Caption = 'Pixi Editions'
        GroupIndex = 0
      end
      object RibbonGroup6: TRibbonGroup
        Left = 106
        Top = 3
        Width = 100
        Height = 86
        ActionManager = ActionManager
        Caption = 'RibbonGroup6'
        GroupIndex = 1
      end
    end
    object RibbonPage2: TRibbonPage
      Left = 0
      Top = 50
      Width = 834
      Height = 93
      Caption = 'Help'
      Index = 2
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 376
    Width = 835
    Height = 118
    Align = alBottom
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Caption = '&Button1'
            CommandStyle = csControl
            CommandProperties.Width = 150
            CommandProperties.ContainedControl = Button1
          end>
        ActionBar = RibbonGroup1
      end>
    Left = 40
    Top = 168
    StyleName = 'Ribbon - Luna'
  end
end
