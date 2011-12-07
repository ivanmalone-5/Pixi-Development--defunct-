object fraListView: TfraListView
  Left = 0
  Top = 0
  Width = 563
  Height = 301
  TabOrder = 0
  object ListView: TListView
    Left = 0
    Top = 0
    Width = 563
    Height = 301
    Align = alClient
    Columns = <
      item
        AutoSize = True
        Caption = 'Filename'
      end
      item
        AutoSize = True
        Caption = 'Path'
      end
      item
        AutoSize = True
        Caption = 'Loaded'
      end
      item
        AutoSize = True
        Caption = 'Valid'
      end
      item
        AutoSize = True
        Caption = 'Handle'
      end>
    GroupView = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object ActionListListView: TActionList
    Left = 56
    Top = 72
    object actListviewReport: TAction
      Category = 'ListView'
      Caption = '&Detailed'
      Checked = True
      GroupIndex = 1
      OnExecute = actListviewReportExecute
    end
    object actListViewList: TAction
      Category = 'ListView'
      Caption = '&List'
      GroupIndex = 1
      OnExecute = actListViewListExecute
    end
    object actListViewSmall: TAction
      Category = 'ListView'
      Caption = '&Small'
      GroupIndex = 1
      OnExecute = actListViewSmallExecute
    end
    object actListViewIcon: TAction
      Category = 'ListView'
      Caption = 'Icon'
      GroupIndex = 1
      OnExecute = actListViewIconExecute
    end
    object actListviewGroups: TAction
      Category = 'ListView'
      Caption = 'Groups'
      Checked = True
      GroupIndex = 2
      OnExecute = actListviewGroupsExecute
    end
  end
end
