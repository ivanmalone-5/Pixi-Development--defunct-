object fraPluginListView: TfraPluginListView
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object ListView: TListView
    Left = 0
    Top = 21
    Width = 320
    Height = 219
    Align = alClient
    Columns = <
      item
        AutoSize = True
        Caption = 'Plugin'
      end
      item
        AutoSize = True
        Caption = 'Status'
      end
      item
        AutoSize = True
        Caption = 'Is Valid'
      end>
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    ViewStyle = vsReport
    ExplicitLeft = -515
    ExplicitTop = 7
    ExplicitWidth = 835
    ExplicitHeight = 233
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 320
    Height = 21
    AutoSize = True
    ButtonHeight = 21
    ButtonWidth = 65
    Caption = 'ToolBar'
    ShowCaptions = True
    TabOrder = 1
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Caption = 'Add Plugin'
      ImageIndex = 0
    end
    object ToolButton2: TToolButton
      Left = 65
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object ToolButton3: TToolButton
      Left = 73
      Top = 0
      Caption = 'ToolButton3'
      ImageIndex = 1
    end
    object ToolButton4: TToolButton
      Left = 138
      Top = 0
      Caption = 'ToolButton4'
      ImageIndex = 2
    end
    object ToolButton5: TToolButton
      Left = 203
      Top = 0
      Width = 8
      Caption = 'ToolButton5'
      ImageIndex = 3
      Style = tbsSeparator
    end
  end
  object ActionList1: TActionList
    Left = 32
    Top = 136
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'dll'
    Filter = 'DLL Files|*.dll|All Files|*.*'
    Left = 32
    Top = 72
  end
end