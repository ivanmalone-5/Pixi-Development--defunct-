object fraOptimizationStatus: TfraOptimizationStatus
  Left = 0
  Top = 0
  Width = 580
  Height = 113
  DoubleBuffered = True
  Color = clWhite
  ParentBackground = False
  ParentColor = False
  ParentDoubleBuffered = False
  TabOrder = 0
  OnResize = FrameResize
  object lblTitle: TLabel
    Left = 0
    Top = 0
    Width = 580
    Height = 13
    Align = alTop
    Alignment = taCenter
    Caption = 'Optimization Status'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 112
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 13
    Width = 265
    Height = 100
    Align = alLeft
    TabOrder = 0
    ExplicitHeight = 85
    DesignSize = (
      265
      100)
    object SpeedButton1: TSpeedButton
      Left = 240
      Top = 6
      Width = 17
      Height = 19
      Anchors = [akTop, akRight]
      Caption = '>'
      ExplicitLeft = 184
    end
    object SpeedButton2: TSpeedButton
      Left = 224
      Top = 6
      Width = 17
      Height = 19
      Anchors = [akTop, akRight]
      Caption = '2'
      ExplicitLeft = 168
    end
    object SpeedButton3: TSpeedButton
      Left = 208
      Top = 6
      Width = 17
      Height = 19
      Anchors = [akTop, akRight]
      Caption = '1'
      ExplicitLeft = 152
    end
    object SpeedButton4: TSpeedButton
      Left = 192
      Top = 6
      Width = 17
      Height = 19
      Anchors = [akTop, akRight]
      Caption = '<'
      ExplicitLeft = 136
    end
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 178
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Completed Optimizations'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 138
    end
    object Label3: TLabel
      Left = 16
      Top = 31
      Width = 241
      Height = 34
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = False
      Caption = 'Live optimization is current enabled'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 201
    end
    object ProgressBar: TProgressBar
      Left = 1
      Top = 82
      Width = 263
      Height = 17
      Align = alBottom
      TabOrder = 0
      ExplicitLeft = 0
      ExplicitTop = 104
      ExplicitWidth = 460
    end
  end
  object pnlRight: TPanel
    Left = 271
    Top = 13
    Width = 309
    Height = 100
    Align = alRight
    TabOrder = 1
    DesignSize = (
      309
      100)
    object SpeedButton5: TSpeedButton
      Left = 286
      Top = 6
      Width = 17
      Height = 19
      Anchors = [akTop, akRight]
      Caption = '>'
      ExplicitLeft = 184
    end
    object SpeedButton6: TSpeedButton
      Left = 270
      Top = 6
      Width = 17
      Height = 19
      Anchors = [akTop, akRight]
      Caption = '2'
      ExplicitLeft = 168
    end
    object SpeedButton7: TSpeedButton
      Left = 254
      Top = 6
      Width = 17
      Height = 19
      Anchors = [akTop, akRight]
      Caption = '1'
      ExplicitLeft = 152
    end
    object SpeedButton8: TSpeedButton
      Left = 238
      Top = 6
      Width = 17
      Height = 19
      Anchors = [akTop, akRight]
      Caption = '<'
      ExplicitLeft = 136
    end
    object Label2: TLabel
      Left = 5
      Top = 6
      Width = 227
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Recommended Optimizations'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 16
      Top = 31
      Width = 273
      Height = 34
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = False
      Caption = 'There are no recommended optimizations, all is good'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 82
      Width = 307
      Height = 17
      Align = alBottom
      TabOrder = 0
      ExplicitLeft = 0
      ExplicitTop = 104
      ExplicitWidth = 460
    end
  end
end