object frmDLLLoader: TfrmDLLLoader
  Left = 0
  Top = 0
  Caption = 'DLL Loader'
  ClientHeight = 275
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  DesignSize = (
    460
    275)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 55
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Filename:'
  end
  object Label2: TLabel
    Left = 16
    Top = 38
    Width = 55
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Handle:'
  end
  object ebFilename: TEdit
    Left = 77
    Top = 13
    Width = 309
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object ebHandle: TEdit
    Left = 77
    Top = 35
    Width = 121
    Height = 21
    NumbersOnly = True
    ReadOnly = True
    TabOrder = 1
  end
  object btnLoad: TButton
    Left = 143
    Top = 62
    Width = 56
    Height = 25
    Caption = 'Load'
    TabOrder = 2
    OnClick = btnLoadClick
  end
  object btnUnload: TButton
    Left = 77
    Top = 62
    Width = 60
    Height = 25
    Caption = 'Unload'
    TabOrder = 3
    OnClick = btnUnloadClick
  end
  object btnFind: TButton
    Left = 392
    Top = 8
    Width = 60
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Find'
    TabOrder = 4
    OnClick = btnFindClick
  end
  object ListView: TListView
    Left = 0
    Top = 88
    Width = 460
    Height = 187
    Align = alBottom
    Columns = <
      item
        AutoSize = True
        Caption = 'Event Triggered'
      end>
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu
    TabOrder = 5
    ViewStyle = vsReport
  end
  object OpenDialog: TOpenDialog
    Filter = 'DLL Files|*.dll|All Files|*.*'
    Left = 216
    Top = 40
  end
  object DLLLoader: TDLLLoader
    OnLoadDllErrorEvent = DLLLoaderLoadDllErrorEvent
    OnUnloadDllErrorEvent = DLLLoaderUnloadDllErrorEvent
    OnDllBeforeLoadEvent = DLLLoaderDllBeforeLoadEvent
    OnDllAfterLoadEvent = DLLLoaderDllAfterLoadEvent
    OnDllBeforeUnloadEVent = DLLLoaderDllBeforeUnloadEVent
    OnDllAfterUnloadEvent = DLLLoaderDllAfterUnloadEvent
    OnStateChangedEvent = DLLLoaderStateChangedEvent
    Left = 16
    Top = 48
  end
  object PopupMenu: TPopupMenu
    Left = 32
    Top = 200
    object miClear: TMenuItem
      Caption = '&Clear'
      OnClick = miClearClick
    end
  end
end