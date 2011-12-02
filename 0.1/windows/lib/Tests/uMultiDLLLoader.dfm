inherited frmMultiDllLoader: TfrmMultiDllLoader
  Caption = 'frmMultiDllLoader'
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnFind: TButton
    Caption = 'Add'
  end
  inherited PopupMenu: TPopupMenu
    Left = 24
    Top = 152
    object N1: TMenuItem
      Caption = '-'
    end
    object miFirst: TMenuItem
      Caption = 'First'
      OnClick = miFirstClick
    end
    object miBack: TMenuItem
      Caption = 'Back'
      OnClick = miBackClick
    end
    object miNext: TMenuItem
      Caption = 'Next'
      OnClick = miNextClick
    end
    object miLast: TMenuItem
      Caption = 'Last'
      OnClick = miLastClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object miLoadAll: TMenuItem
      Caption = 'Load All'
      OnClick = miLoadAllClick
    end
    object miUnloadAll: TMenuItem
      Caption = 'Unload All'
      OnClick = miUnloadAllClick
    end
  end
  object MultiDLLLoader: TMultiDLLLoader
    Handle = 0
    OnLoadDllErrorEvent = DLLLoaderLoadDllErrorEvent
    OnUnloadDllErrorEvent = DLLLoaderUnloadDllErrorEvent
    OnDllBeforeLoadEvent = DLLLoaderDllBeforeLoadEvent
    OnDllAfterLoadEvent = DLLLoaderDllAfterLoadEvent
    OnDllBeforeUnloadEVent = DLLLoaderDllBeforeUnloadEVent
    OnDllAfterUnloadEvent = DLLLoaderDllAfterUnloadEvent
    OnStateChangedEvent = MultiDLLLoaderStateChangedEvent
    OnBeforeLoadAllEvent = MultiDLLLoaderBeforeLoadAllEvent
    OnAfterLoadAllEvent = MultiDLLLoaderAfterLoadAllEvent
    OnBeforeUnloadAllEvent = MultiDLLLoaderBeforeUnloadAllEvent
    OnAfterUnloadALllEvent = MultiDLLLoaderAfterUnloadALllEvent
    OnClearEvent = MultiDLLLoaderClearEvent
    OnNavigateEvent = MultiDLLLoaderNavigateEvent
    OnArrayNotInSyncError = MultiDLLLoaderArrayNotInSyncError
    OnBeforeAddEvent = MultiDLLLoaderBeforeAddEvent
    OnAfterAddEvent = MultiDLLLoaderAfterAddEvent
    Left = 24
    Top = 208
  end
end