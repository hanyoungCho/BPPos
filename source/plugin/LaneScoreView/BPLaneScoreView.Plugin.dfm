object BPLaneScoreViewForm: TBPLaneScoreViewForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 798
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnClose = PluginModuleClose
  OnKeyDown = PluginModuleKeyDown
  PluginGroup = 0
  InitHeight = 0
  InitWidth = 0
  EscCanClose = False
  OnMessage = PluginModuleMessage
  TextHeight = 18
  object panHeader: TPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 38
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    Caption = #51216#49688' '#49688#51221
    Color = 5393480
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    StyleElements = []
    OnMouseMove = panHeaderMouseMove
    object lblPluginVersion: TLabel
      AlignWithMargins = True
      Left = 43
      Top = 5
      Width = 95
      Height = 28
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'PLUGIN Ver.1.0.0.0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      StyleElements = []
      ExplicitHeight = 13
    end
    object panHeaderToolbar: TPanel
      AlignWithMargins = True
      Left = 965
      Top = 3
      Width = 32
      Height = 32
      Align = alRight
      AutoSize = True
      BevelOuter = bvNone
      ParentBackground = False
      ParentColor = True
      TabOrder = 0
      StyleElements = []
      object btnClose: TSpeedButton
        Left = 0
        Top = 0
        Width = 32
        Height = 32
        Align = alLeft
        ImageIndex = 3
        ImageName = 'Close_W_32px'
        Images = BPDM.imlIcon32
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -27
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        StyleElements = []
        OnClick = btnCloseClick
      end
    end
    object panHeaderMenuBar: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 32
      Height = 32
      Align = alLeft
      AutoSize = True
      BevelOuter = bvNone
      ParentBackground = False
      ParentColor = True
      TabOrder = 1
      StyleElements = []
      object btnMainMenu: TSpeedButton
        Left = 0
        Top = 0
        Width = 32
        Height = 32
        Align = alLeft
        ImageIndex = 1
        ImageName = 'Menu_W_32px'
        Images = BPDM.imlIcon32
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -24
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        StyleElements = []
        ExplicitTop = 2
      end
    end
  end
  object sbxScoreList: TScrollBox
    AlignWithMargins = True
    Left = 5
    Top = 43
    Width = 990
    Height = 675
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 1
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clBtnFace
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentBackground = True
    ParentColor = False
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    OnMouseWheel = sbxScoreListMouseWheel
    object TemplateScorePanel: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 41
      Width = 978
      Height = 100
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      Padding.Left = 5
      Padding.Top = 5
      Padding.Right = 5
      Padding.Bottom = 5
      TabOrder = 1
      Visible = False
      object TemplateLaneGroupBox1: TGroupBox
        AlignWithMargins = True
        Left = 129
        Top = 6
        Width = 70
        Height = 88
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = '1'
        Padding.Left = 5
        Padding.Right = 5
        TabOrder = 1
        object TemplateFrameScoreLabel1: TLabel
          Left = 6
          Top = 49
          Width = 58
          Height = 38
          Align = alBottom
          Alignment = taCenter
          AutoSize = False
          Caption = '100'
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 7
          ExplicitTop = 46
          ExplicitWidth = 56
        end
        object TemplateFrameScoreEdit11: TEdit
          Left = 6
          Top = 19
          Width = 28
          Height = 30
          Align = alLeft
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 0
          Text = '1'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
        object TemplateFrameScoreEdit12: TEdit
          Left = 34
          Top = 19
          Width = 30
          Height = 30
          Align = alClient
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 1
          Text = '1'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
      end
      object TemplateLaneGroupBox2: TGroupBox
        AlignWithMargins = True
        Left = 202
        Top = 6
        Width = 70
        Height = 88
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = '2'
        Padding.Left = 5
        Padding.Right = 5
        TabOrder = 2
        object TemplateFrameScoreLabel2: TLabel
          Tag = 1
          Left = 6
          Top = 49
          Width = 58
          Height = 38
          Align = alBottom
          Alignment = taCenter
          AutoSize = False
          Caption = '100'
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 7
          ExplicitTop = 46
          ExplicitWidth = 56
        end
        object TemplateFrameScoreEdit21: TEdit
          Tag = 1
          Left = 6
          Top = 19
          Width = 28
          Height = 30
          Align = alLeft
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 0
          Text = '2'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
        object TemplateFrameScoreEdit22: TEdit
          Tag = 1
          Left = 34
          Top = 19
          Width = 30
          Height = 30
          Align = alClient
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 1
          Text = '2'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
      end
      object TemplateLaneGroupBox10: TGroupBox
        AlignWithMargins = True
        Left = 786
        Top = 6
        Width = 97
        Height = 88
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = '10'
        Padding.Left = 5
        Padding.Right = 5
        TabOrder = 10
        object TemplateFrameScoreLabel10: TLabel
          Tag = 9
          Left = 6
          Top = 49
          Width = 85
          Height = 38
          Align = alBottom
          Alignment = taCenter
          AutoSize = False
          Caption = '100'
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 7
          ExplicitTop = 46
          ExplicitWidth = 83
        end
        object TemplateFrameScoreEdit102: TEdit
          Tag = 9
          Left = 34
          Top = 19
          Width = 28
          Height = 30
          Align = alLeft
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 1
          Text = '/'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
        object TemplateFrameScoreEdit103: TEdit
          Tag = 9
          Left = 62
          Top = 19
          Width = 29
          Height = 30
          Align = alClient
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 2
          Text = 'X'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
        object TemplateFrameScoreEdit101: TEdit
          Tag = 9
          Left = 6
          Top = 19
          Width = 28
          Height = 30
          Align = alLeft
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 0
          Text = '0'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
      end
      object TemplateLaneGroupBox4: TGroupBox
        AlignWithMargins = True
        Left = 348
        Top = 6
        Width = 70
        Height = 88
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = '4'
        Padding.Left = 5
        Padding.Right = 5
        TabOrder = 4
        object TemplateFrameScoreLabel4: TLabel
          Tag = 3
          Left = 6
          Top = 49
          Width = 58
          Height = 38
          Align = alBottom
          Alignment = taCenter
          AutoSize = False
          Caption = '100'
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 7
          ExplicitTop = 46
          ExplicitWidth = 56
        end
        object TemplateFrameScoreEdit41: TEdit
          Tag = 3
          Left = 6
          Top = 19
          Width = 28
          Height = 30
          Align = alLeft
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 0
          Text = '4'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
        object TemplateFrameScoreEdit42: TEdit
          Tag = 3
          Left = 34
          Top = 19
          Width = 30
          Height = 30
          Align = alClient
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 1
          Text = '4'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
      end
      object TemplateLaneGroupBox5: TGroupBox
        AlignWithMargins = True
        Left = 421
        Top = 6
        Width = 70
        Height = 88
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = '5'
        Padding.Left = 5
        Padding.Right = 5
        TabOrder = 5
        object TemplateFrameScoreLabel5: TLabel
          Tag = 4
          Left = 6
          Top = 49
          Width = 58
          Height = 38
          Align = alBottom
          Alignment = taCenter
          AutoSize = False
          Caption = '100'
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 7
          ExplicitTop = 46
          ExplicitWidth = 56
        end
        object TemplateFrameScoreEdit51: TEdit
          Tag = 4
          Left = 6
          Top = 19
          Width = 28
          Height = 30
          Align = alLeft
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 0
          Text = '5'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
        object TemplateFrameScoreEdit52: TEdit
          Tag = 4
          Left = 34
          Top = 19
          Width = 30
          Height = 30
          Align = alClient
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 1
          Text = '/'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
      end
      object TemplateLaneGroupBox6: TGroupBox
        AlignWithMargins = True
        Left = 494
        Top = 6
        Width = 70
        Height = 88
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = '6'
        Padding.Left = 5
        Padding.Right = 5
        TabOrder = 6
        object TemplateFrameScoreLabel6: TLabel
          Tag = 5
          Left = 6
          Top = 49
          Width = 58
          Height = 38
          Align = alBottom
          Alignment = taCenter
          AutoSize = False
          Caption = '100'
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 7
          ExplicitTop = 46
          ExplicitWidth = 56
        end
        object TemplateFrameScoreEdit61: TEdit
          Tag = 5
          Left = 6
          Top = 19
          Width = 28
          Height = 30
          Align = alLeft
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 0
          Text = '6'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
        object TemplateFrameScoreEdit62: TEdit
          Tag = 5
          Left = 34
          Top = 19
          Width = 30
          Height = 30
          Align = alClient
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 1
          Text = '3'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
      end
      object TemplateLaneGroupBox7: TGroupBox
        AlignWithMargins = True
        Left = 567
        Top = 6
        Width = 70
        Height = 88
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = '7'
        Padding.Left = 5
        Padding.Right = 5
        TabOrder = 7
        object TemplateFrameScoreLabel7: TLabel
          Tag = 6
          Left = 6
          Top = 49
          Width = 58
          Height = 38
          Align = alBottom
          Alignment = taCenter
          AutoSize = False
          Caption = '100'
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 7
          ExplicitTop = 46
          ExplicitWidth = 56
        end
        object TemplateFrameScoreEdit71: TEdit
          Tag = 6
          Left = 6
          Top = 19
          Width = 28
          Height = 30
          Align = alLeft
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 0
          Text = '7'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
        object TemplateFrameScoreEdit72: TEdit
          Tag = 6
          Left = 34
          Top = 19
          Width = 30
          Height = 30
          Align = alClient
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 1
          Text = '2'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
      end
      object TemplateLaneGroupBox8: TGroupBox
        AlignWithMargins = True
        Left = 640
        Top = 6
        Width = 70
        Height = 88
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = '8'
        Padding.Left = 5
        Padding.Right = 5
        TabOrder = 8
        object TemplateFrameScoreLabel8: TLabel
          Tag = 7
          Left = 6
          Top = 49
          Width = 58
          Height = 38
          Align = alBottom
          Alignment = taCenter
          AutoSize = False
          Caption = '100'
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 7
          ExplicitTop = 46
          ExplicitWidth = 56
        end
        object TemplateFrameScoreEdit81: TEdit
          Tag = 7
          Left = 6
          Top = 19
          Width = 28
          Height = 30
          Align = alLeft
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 0
          Text = '8'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
        object TemplateFrameScoreEdit82: TEdit
          Tag = 7
          Left = 34
          Top = 19
          Width = 30
          Height = 30
          Align = alClient
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 1
          Text = '1'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
      end
      object TemplateLaneGroupBox9: TGroupBox
        AlignWithMargins = True
        Left = 713
        Top = 6
        Width = 70
        Height = 88
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = '9'
        Padding.Left = 5
        Padding.Right = 5
        TabOrder = 9
        object TemplateFrameScoreLabel9: TLabel
          Tag = 8
          Left = 6
          Top = 49
          Width = 58
          Height = 38
          Align = alBottom
          Alignment = taCenter
          AutoSize = False
          Caption = '100'
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 7
          ExplicitTop = 46
          ExplicitWidth = 56
        end
        object TemplateFrameScoreEdit91: TEdit
          Tag = 8
          Left = 6
          Top = 19
          Width = 28
          Height = 30
          Align = alLeft
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 0
          Text = '9'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
        object TemplateFrameScoreEdit92: TEdit
          Tag = 8
          Left = 34
          Top = 19
          Width = 30
          Height = 30
          Align = alClient
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 1
          Text = '0'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
      end
      object TemplateLaneGroupBox3: TGroupBox
        AlignWithMargins = True
        Left = 275
        Top = 6
        Width = 70
        Height = 88
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = '3'
        Padding.Left = 5
        Padding.Right = 5
        TabOrder = 3
        object TemplateFrameScoreLabel3: TLabel
          Tag = 2
          Left = 6
          Top = 49
          Width = 58
          Height = 38
          Align = alBottom
          Alignment = taCenter
          AutoSize = False
          Caption = '100'
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 7
          ExplicitTop = 46
          ExplicitWidth = 56
        end
        object TemplateFrameScoreEdit31: TEdit
          Tag = 2
          Left = 6
          Top = 19
          Width = 28
          Height = 30
          Align = alLeft
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 0
          Text = '3'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
        object TemplateFrameScoreEdit32: TEdit
          Tag = 2
          Left = 34
          Top = 19
          Width = 30
          Height = 30
          Align = alClient
          Alignment = taCenter
          BevelInner = bvNone
          BevelOuter = bvNone
          CharCase = ecUpperCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          MaxLength = 1
          ParentFont = False
          TabOrder = 1
          Text = '3'
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 26
        end
      end
      object TemplateLaneScoreGroupBox: TGroupBox
        AlignWithMargins = True
        Left = 886
        Top = 6
        Width = 86
        Height = 88
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        Caption = #44172#51076' '#51216#49688
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Padding.Left = 5
        Padding.Top = 5
        Padding.Right = 5
        Padding.Bottom = 5
        ParentColor = False
        ParentFont = False
        TabOrder = 11
        object TemplateGameScoreLabel: TLabel
          Left = 6
          Top = 24
          Width = 74
          Height = 58
          Align = alClient
          Alignment = taCenter
          AutoSize = False
          Caption = '0'
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 16744448
          Font.Height = -27
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          ExplicitTop = 25
          ExplicitWidth = 79
          ExplicitHeight = 54
        end
      end
      object TemplateBowlerInfoGroupBox: TGroupBox
        Left = 6
        Top = 6
        Width = 120
        Height = 88
        Align = alLeft
        Caption = '01A'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        object TemplateBowlerNameLabel: TLabel
          AlignWithMargins = True
          Left = 6
          Top = 24
          Width = 108
          Height = 18
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          Alignment = taRightJustify
          Caption = #48380#47084#47749
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          ExplicitLeft = 75
          ExplicitWidth = 39
        end
      end
    end
    object panInputGuide: TPanel
      Left = 0
      Top = 0
      Width = 988
      Height = 36
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Color = 9857565
      ParentBackground = False
      TabOrder = 0
      StyleElements = [seFont, seBorder]
      object edtLegendScoree: TDBEditEh
        Left = 367
        Top = 6
        Width = 50
        Height = 24
        TabStop = False
        Alignment = taCenter
        ControlLabel.Width = 56
        ControlLabel.Height = 18
        ControlLabel.Caption = #51216#49688' '#51077#47141
        ControlLabel.Font.Charset = DEFAULT_CHARSET
        ControlLabel.Font.Color = clWhite
        ControlLabel.Font.Height = -15
        ControlLabel.Font.Name = 'Pretendard Variable'
        ControlLabel.Font.Style = []
        ControlLabel.ParentFont = False
        ControlLabel.StyleElements = [seClient, seBorder]
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        DynProps = <>
        EditButtons = <>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        Text = '0 ~ 9'
        Visible = True
      end
      object edtLegendSpare: TDBEditEh
        Left = 500
        Top = 6
        Width = 30
        Height = 24
        TabStop = False
        Alignment = taCenter
        ControlLabel.Width = 69
        ControlLabel.Height = 18
        ControlLabel.Caption = #49828#54168#50612' '#52376#47532
        ControlLabel.Font.Charset = DEFAULT_CHARSET
        ControlLabel.Font.Color = clWhite
        ControlLabel.Font.Height = -15
        ControlLabel.Font.Name = 'Pretendard Variable'
        ControlLabel.Font.Style = []
        ControlLabel.ParentFont = False
        ControlLabel.StyleElements = [seClient, seBorder]
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        DynProps = <>
        EditButtons = <>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        Text = '/'
        Visible = True
      end
      object edtLegendStrike: TDBEditEh
        Left = 606
        Top = 6
        Width = 30
        Height = 24
        TabStop = False
        Alignment = taCenter
        ControlLabel.Width = 65
        ControlLabel.Height = 18
        ControlLabel.Caption = #49828#53944#46972#51060#53356
        ControlLabel.Font.Charset = DEFAULT_CHARSET
        ControlLabel.Font.Color = clWhite
        ControlLabel.Font.Height = -15
        ControlLabel.Font.Name = 'Pretendard Variable'
        ControlLabel.Font.Style = []
        ControlLabel.ParentFont = False
        ControlLabel.StyleElements = [seClient, seBorder]
        ControlLabel.Visible = True
        ControlLabelLocation.Spacing = 5
        ControlLabelLocation.Position = lpLeftCenterEh
        DynProps = <>
        EditButtons = <>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        TabOrder = 2
        Text = 'X'
        Tooltips = True
        Visible = True
      end
    end
  end
  object panFooter: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 719
    Width = 990
    Height = 74
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alBottom
    TabOrder = 2
    object btnOK: TBitBtn
      Left = 440
      Top = 12
      Width = 150
      Height = 50
      Caption = #51201#50857
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ImageIndex = 59
      ImageName = 'done_32px'
      Images = BPDM.imlIcon32
      ParentFont = False
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TBitBtn
      Left = 596
      Top = 12
      Width = 150
      Height = 50
      Caption = #52712#49548
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ImageIndex = 49
      ImageName = 'cancel_32px'
      Images = BPDM.imlIcon32
      ParentFont = False
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnGameRestore: TBitBtn
      Left = 284
      Top = 12
      Width = 150
      Height = 50
      Caption = #51060#51204' '#44172#51076' '#48373#44396
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ImageIndex = 25
      ImageName = 'Restart_32px'
      Images = BPDM.imlIcon32
      ParentFont = False
      TabOrder = 2
      OnClick = btnGameRestoreClick
    end
    object panScoreNext: TPanel
      AlignWithMargins = True
      Left = 107
      Top = 6
      Width = 97
      Height = 62
      Cursor = crHandPoint
      Margins.Left = 4
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 5
      Align = alLeft
      Caption = #9654
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 3
      TabStop = True
      object lblScoreNext: TLabel
        Left = 1
        Top = 1
        Width = 95
        Height = 60
        Cursor = crHandPoint
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = #9654
        Color = 8020573
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -17
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Transparent = True
        Layout = tlCenter
        StyleElements = [seFont]
        OnClick = lblScoreNextClick
        OnMouseDown = lblScoreNextMouseDown
        OnMouseUp = lblScoreNextMouseUp
        ExplicitLeft = 0
        ExplicitWidth = 96
        ExplicitHeight = 47
      end
    end
    object panScorePrev: TPanel
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 97
      Height = 62
      Cursor = crHandPoint
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 5
      Align = alLeft
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 4
      TabStop = True
      object lblScorePrev: TLabel
        Left = 1
        Top = 1
        Width = 95
        Height = 60
        Cursor = crHandPoint
        Margins.Top = 0
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = #9664
        Color = 8020573
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -17
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Transparent = True
        Layout = tlCenter
        StyleElements = [seFont]
        OnClick = lblScorePrevClick
        OnMouseDown = lblScorePrevMouseDown
        OnMouseUp = lblScorePrevMouseUp
        ExplicitLeft = -1
        ExplicitTop = -1
        ExplicitWidth = 93
        ExplicitHeight = 50
      end
    end
  end
end
