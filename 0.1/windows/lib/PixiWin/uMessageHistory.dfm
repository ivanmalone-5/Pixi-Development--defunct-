object frmMessageHistory: TfrmMessageHistory
  Left = 0
  Top = 0
  AlphaBlend = True
  AlphaBlendValue = 250
  BorderStyle = bsSizeToolWin
  Caption = 'Message History'
  ClientHeight = 244
  ClientWidth = 451
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ListView: TListView
    Left = 0
    Top = 21
    Width = 451
    Height = 223
    Align = alClient
    Columns = <
      item
        AutoSize = True
        Caption = 'Title'
      end
      item
        AutoSize = True
        Caption = 'Header'
      end
      item
        AutoSize = True
        Caption = 'Message'
      end
      item
        AutoSize = True
        Caption = 'Date'
      end
      item
        AutoSize = True
        Caption = 'Time'
      end
      item
        AutoSize = True
        Caption = 'Message Type'
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 451
    Height = 21
    AutoSize = True
    ButtonHeight = 21
    ButtonWidth = 69
    Caption = 'ToolBar'
    ShowCaptions = True
    TabOrder = 1
    object btnClearHistory: TToolButton
      Left = 0
      Top = 0
      Action = actClearHistory
    end
    object btnSep1: TToolButton
      Left = 69
      Top = 0
      Width = 8
      ImageIndex = 0
      Style = tbsSeparator
    end
    object btnSaveToFile: TToolButton
      Left = 77
      Top = 0
      Action = actSaveHistory
    end
  end
  object ActionList: TActionList
    Left = 40
    Top = 112
    object actClearHistory: TAction
      Category = 'History'
      Caption = 'Clear History'
      OnExecute = actClearHistoryExecute
    end
    object actSaveHistory: TAction
      Category = 'History'
      Caption = 'Save to File'
      OnExecute = actSaveHistoryExecute
    end
  end
  object SaveDialog: TFileSaveDialog
    DefaultExtension = 'log'
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 40
    Top = 168
  end
end
