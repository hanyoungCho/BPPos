object BPScorePrintForm: TBPScorePrintForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 752
  ClientWidth = 630
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnClose = PluginModuleClose
  PluginGroup = 0
  InitHeight = 0
  InitWidth = 0
  EscCanClose = False
  OnMessage = PluginModuleMessage
  TextHeight = 18
  object panHeader: TPanel
    Left = 0
    Top = 0
    Width = 630
    Height = 38
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    Caption = #44172#51076' '#45236#50669' '#51312#54924
    Color = 5393480
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
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
      Left = 595
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
  object Panel1: TPanel
    Left = 0
    Top = 38
    Width = 630
    Height = 714
    Align = alClient
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object panMemberListHeader: TPanel
      Left = 0
      Top = 0
      Width = 630
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object lblSearchTitle: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 6
        Width = 70
        Height = 29
        Margins.Top = 6
        Margins.Right = 5
        Margins.Bottom = 6
        Align = alLeft
        Alignment = taCenter
        AutoSize = False
        Caption = #44160#49353' '#51312#44148
        Color = 5393480
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        StyleElements = []
      end
      object lblSaleDate: TLabel
        Left = 78
        Top = 0
        Width = 65
        Height = 41
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 1
        Margins.Bottom = 0
        Align = alLeft
        Alignment = taCenter
        AutoSize = False
        Caption = #44144#47000#51068#51088
        Layout = tlCenter
        ExplicitLeft = 8
      end
      object btnSearchAssign: TBitBtn
        AlignWithMargins = True
        Left = 480
        Top = 5
        Width = 150
        Height = 31
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Align = alRight
        Caption = #44172#51076#45236#50669' '#44160#49353
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ImageIndex = 33
        ImageName = 'Scorecard_32px'
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 0
        WordWrap = True
        OnClick = btnSearchAssignClick
      end
      object edtSearchDate: TDBDateTimeEditEh
        AlignWithMargins = True
        Left = 143
        Top = 9
        Width = 121
        Height = 23
        Margins.Left = 0
        Margins.Top = 9
        Margins.Right = 5
        Margins.Bottom = 9
        ControlLabel.Font.Charset = DEFAULT_CHARSET
        ControlLabel.Font.Color = clWindowText
        ControlLabel.Font.Height = -12
        ControlLabel.Font.Name = 'Pretendard Variable'
        ControlLabel.Font.Style = []
        ControlLabel.ParentFont = False
        Align = alLeft
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Kind = dtkDateEh
        ParentFont = False
        TabOrder = 1
        Visible = True
        ExplicitHeight = 26
      end
    end
    object G1: TcxGrid
      AlignWithMargins = True
      Left = 3
      Top = 41
      Width = 624
      Height = 244
      Margins.Top = 0
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      LookAndFeel.ScrollbarMode = sbmTouch
      LookAndFeel.ScrollMode = scmSmooth
      object V1: TcxGridDBBandedTableView
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <>
        OnFocusedRecordChanged = V1FocusedRecordChanged
        DataController.DataSource = dsrScorePrintList
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        DataController.Summary.Options = [soSelectedRecords]
        OptionsCustomize.ColumnFiltering = False
        OptionsCustomize.ColumnGrouping = False
        OptionsCustomize.ColumnHidingOnGrouping = False
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnVertSizing = False
        OptionsData.Deleting = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.CellSelect = False
        OptionsView.FocusRect = False
        OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'>'
        OptionsView.ScrollBars = ssVertical
        OptionsView.ColumnAutoWidth = True
        OptionsView.GridLines = glVertical
        OptionsView.GroupByBox = False
        OptionsView.BandHeaders = False
        Styles.Header = BPDM.StyleHeader1
        Styles.Inactive = BPDM.StyleSelection
        Styles.Indicator = BPDM.StyleHeader1
        Styles.Selection = BPDM.StyleSelection
        Styles.BandHeader = BPDM.StyleHeader1
        Bands = <
          item
          end>
        object V1assign_no: TcxGridDBBandedColumn
          Caption = #48176#51221#48264#54840
          DataBinding.FieldName = 'assign_no'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.Alignment.Vert = taVCenter
          Width = 120
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object V1lane_nm: TcxGridDBBandedColumn
          Caption = #47112#51064
          DataBinding.FieldName = 'lane_nm'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 60
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object V1start_datetime: TcxGridDBBandedColumn
          Caption = #49884#51089#51068#49884
          DataBinding.FieldName = 'start_datetime'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 100
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
        object V1end_datetime: TcxGridDBBandedColumn
          Caption = #51333#47308#51068#49884
          DataBinding.FieldName = 'end_datetime'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 100
          Position.BandIndex = 0
          Position.ColIndex = 3
          Position.RowIndex = 0
        end
      end
      object L1: TcxGridLevel
        GridView = V1
      end
    end
    object G2: TcxGrid
      AlignWithMargins = True
      Left = 3
      Top = 288
      Width = 624
      Height = 180
      Margins.Top = 0
      Align = alBottom
      BevelInner = bvNone
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      LookAndFeel.ScrollbarMode = sbmTouch
      LookAndFeel.ScrollMode = scmSmooth
      object V2: TcxGridDBBandedTableView
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <>
        DataController.DataSource = dsrScorePrintDetail
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        DataController.Summary.Options = [soSelectedRecords]
        OptionsCustomize.ColumnFiltering = False
        OptionsCustomize.ColumnGrouping = False
        OptionsCustomize.ColumnHidingOnGrouping = False
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnVertSizing = False
        OptionsData.Deleting = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.CellSelect = False
        OptionsView.FocusRect = False
        OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'>'
        OptionsView.ScrollBars = ssVertical
        OptionsView.ColumnAutoWidth = True
        OptionsView.GridLines = glVertical
        OptionsView.GroupByBox = False
        OptionsView.BandHeaders = False
        Styles.Header = BPDM.StyleHeader1
        Styles.Inactive = BPDM.StyleSelection
        Styles.Indicator = BPDM.StyleHeader1
        Styles.Selection = BPDM.StyleSelection
        Styles.BandHeader = BPDM.StyleHeader1
        Bands = <
          item
          end>
        object V2bowler_id: TcxGridDBBandedColumn
          Caption = #48380#47084'ID'
          DataBinding.FieldName = 'bowler_id'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Vert = taVCenter
          Width = 80
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object V2bowler_nm: TcxGridDBBandedColumn
          Caption = #48380#47084#47749
          DataBinding.FieldName = 'bowler_nm'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 150
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object V2member_no: TcxGridDBBandedColumn
          Caption = #54924#50896#48264#54840
          DataBinding.FieldName = 'member_no'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 90
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
        object V2total_score_sum: TcxGridDBBandedColumn
          Caption = #52509#51216#49688
          DataBinding.FieldName = 'total_score_sum'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 120
          Position.BandIndex = 0
          Position.ColIndex = 3
          Position.RowIndex = 0
        end
        object V2top_score: TcxGridDBBandedColumn
          Caption = #52572#44256#51216#49688
          DataBinding.FieldName = 'top_score'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 100
          Position.BandIndex = 0
          Position.ColIndex = 4
          Position.RowIndex = 0
        end
        object V2avg_score: TcxGridDBBandedColumn
          Caption = #54217#44512#51216#49688
          DataBinding.FieldName = 'avg_score'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 100
          Position.BandIndex = 0
          Position.ColIndex = 5
          Position.RowIndex = 0
        end
      end
      object L2: TcxGridLevel
        GridView = V2
      end
    end
    object panMemberListToolbar: TPanel
      Left = 0
      Top = 654
      Width = 630
      Height = 60
      Align = alBottom
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      object btnSelectMember: TBitBtn
        AlignWithMargins = True
        Left = 260
        Top = 5
        Width = 140
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Caption = #44172#51076' '#45236#50669' '#52636#47141
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ImageIndex = 59
        ImageName = 'done_32px'
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 0
        WordWrap = True
        OnClick = btnSelectMemberClick
      end
    end
    object G3: TcxGrid
      AlignWithMargins = True
      Left = 3
      Top = 471
      Width = 624
      Height = 180
      Margins.Top = 0
      Align = alBottom
      BevelInner = bvNone
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      LookAndFeel.ScrollbarMode = sbmTouch
      LookAndFeel.ScrollMode = scmSmooth
      object V3: TcxGridDBBandedTableView
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <>
        DataController.DataSource = dsrScorePrintGame
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        DataController.Summary.Options = [soSelectedRecords]
        OptionsCustomize.ColumnFiltering = False
        OptionsCustomize.ColumnGrouping = False
        OptionsCustomize.ColumnHidingOnGrouping = False
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnVertSizing = False
        OptionsData.Deleting = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.CellSelect = False
        OptionsView.FocusRect = False
        OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'>'
        OptionsView.ScrollBars = ssVertical
        OptionsView.ColumnAutoWidth = True
        OptionsView.GridLines = glVertical
        OptionsView.GroupByBox = False
        OptionsView.BandHeaders = False
        Styles.Header = BPDM.StyleHeader1
        Styles.Inactive = BPDM.StyleSelection
        Styles.Indicator = BPDM.StyleHeader1
        Styles.Selection = BPDM.StyleSelection
        Styles.BandHeader = BPDM.StyleHeader1
        Bands = <
          item
          end>
        object V3bowler_nm: TcxGridDBBandedColumn
          Caption = #48380#47084#47749
          DataBinding.FieldName = 'bowler_nm'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Vert = taVCenter
          Width = 150
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object V3game_seq_1: TcxGridDBBandedColumn
          Caption = '1'
          DataBinding.FieldName = 'game_seq_1'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 60
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object V3game_seq_2: TcxGridDBBandedColumn
          Caption = '2'
          DataBinding.FieldName = 'game_seq_2'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 60
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
        object V3game_seq_3: TcxGridDBBandedColumn
          Caption = '3'
          DataBinding.FieldName = 'game_seq_3'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 60
          Position.BandIndex = 0
          Position.ColIndex = 3
          Position.RowIndex = 0
        end
        object V3game_seq_4: TcxGridDBBandedColumn
          Caption = '4'
          DataBinding.FieldName = 'game_seq_4'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 60
          Position.BandIndex = 0
          Position.ColIndex = 4
          Position.RowIndex = 0
        end
        object V3game_seq_5: TcxGridDBBandedColumn
          Caption = '5'
          DataBinding.FieldName = 'game_seq_5'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 60
          Position.BandIndex = 0
          Position.ColIndex = 5
          Position.RowIndex = 0
        end
        object V3game_seq_6: TcxGridDBBandedColumn
          Caption = '6'
          DataBinding.FieldName = 'game_seq_6'
          DataBinding.IsNullValueType = True
          HeaderAlignmentHorz = taCenter
          MinWidth = 0
          Width = 60
          Position.BandIndex = 0
          Position.ColIndex = 6
          Position.RowIndex = 0
        end
        object V3game_seq_7: TcxGridDBBandedColumn
          Caption = '7'
          DataBinding.FieldName = 'game_seq_7'
          DataBinding.IsNullValueType = True
          HeaderAlignmentHorz = taCenter
          Width = 60
          Position.BandIndex = 0
          Position.ColIndex = 7
          Position.RowIndex = 0
        end
        object V3game_seq_8: TcxGridDBBandedColumn
          Caption = '8'
          DataBinding.FieldName = 'game_seq_8'
          DataBinding.IsNullValueType = True
          HeaderAlignmentHorz = taCenter
          Width = 60
          Position.BandIndex = 0
          Position.ColIndex = 8
          Position.RowIndex = 0
        end
        object V3game_seq_9: TcxGridDBBandedColumn
          Caption = '9'
          DataBinding.FieldName = 'game_seq_9'
          DataBinding.IsNullValueType = True
          HeaderAlignmentHorz = taCenter
          Width = 60
          Position.BandIndex = 0
          Position.ColIndex = 9
          Position.RowIndex = 0
        end
        object V3game_seq_10: TcxGridDBBandedColumn
          Caption = '10'
          DataBinding.FieldName = 'game_seq_10'
          DataBinding.IsNullValueType = True
          HeaderAlignmentHorz = taCenter
          Width = 60
          Position.BandIndex = 0
          Position.ColIndex = 10
          Position.RowIndex = 0
        end
      end
      object L3: TcxGridLevel
        GridView = V3
      end
    end
  end
  object dsrScorePrintList: TDataSource
    DataSet = BPDM.QRScorePrintList
    Left = 449
    Top = 225
  end
  object dsrScorePrintDetail: TDataSource
    DataSet = BPDM.QRScorePrintDetailList
    Left = 441
    Top = 409
  end
  object dsrScorePrintGame: TDataSource
    DataSet = BPDM.QRScorePrintGameList
    Left = 449
    Top = 593
  end
end
