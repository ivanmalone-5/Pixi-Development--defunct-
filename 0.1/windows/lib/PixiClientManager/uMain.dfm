object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Pixi Client Manager'
  ClientHeight = 373
  ClientWidth = 619
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 121
    Top = 0
    Height = 354
    ExplicitLeft = 216
    ExplicitTop = 96
    ExplicitHeight = 100
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 354
    Width = 619
    Height = 19
    Panels = <>
    ExplicitLeft = 216
    ExplicitTop = 128
    ExplicitWidth = 0
  end
  object TreeView: TTreeView
    Left = 0
    Top = 0
    Width = 121
    Height = 354
    Align = alLeft
    Indent = 19
    TabOrder = 1
    ExplicitLeft = 152
    ExplicitTop = 96
    ExplicitHeight = 97
  end
  object ListView: TListView
    Left = 124
    Top = 0
    Width = 495
    Height = 354
    Align = alClient
    Columns = <>
    ReadOnly = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
    ExplicitLeft = 88
    ExplicitTop = 72
    ExplicitWidth = 250
    ExplicitHeight = 150
  end
  object MainMenu1: TMainMenu
    Left = 232
    Top = 104
    object File1: TMenuItem
      Caption = '&File'
    end
  end
end
