object frmPixiConfiguration: TfrmPixiConfiguration
  Left = 0
  Top = 0
  Caption = 'Pixi Utilities Configuration'
  ClientHeight = 395
  ClientWidth = 660
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 0
    Top = 354
    Width = 660
    Height = 41
    Align = alBottom
    TabOrder = 0
    ExplicitLeft = 248
    ExplicitTop = 200
    ExplicitWidth = 185
    object Button1: TButton
      Left = 576
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Apply'
      TabOrder = 0
    end
    object Button2: TButton
      Left = 495
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
    end
    object Button3: TButton
      Left = 414
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 2
    end
  end
  object ListBox: TListBox
    Left = 8
    Top = 8
    Width = 233
    Height = 340
    ItemHeight = 13
    TabOrder = 1
  end
  object ListView: TListView
    Left = 256
    Top = 8
    Width = 385
    Height = 340
    Columns = <>
    TabOrder = 2
    ViewStyle = vsReport
  end
end
