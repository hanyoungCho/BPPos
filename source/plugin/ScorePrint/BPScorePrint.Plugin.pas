(*******************************************************************************
  Project     : 볼링픽 POS 시스템
  Title       : 회원 조회/등록/수정 및 보유상품 조회 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.
  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.
*******************************************************************************)
unit BPScorePrint.Plugin;
interface
uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Data.DB, Vcl.Mask, Vcl.ComCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { EhLib }
  DBGridEh, DBLookupEh, DBCtrlsEh,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations,
  cxDBData, cxLabel, cxCurrencyEdit, cxCheckBox, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView, cxClasses, cxGridCustomView,
  cxGrid;
{$I ..\..\common\Common.BPCommon.inc}
type
  (*
  TPageControl = class(Vcl.ComCtrls.TPageControl)
  private
    procedure TCMAdjustRect(var AMsg: TMessage); message TCM_ADJUSTRECT;
  end;
  *)
  TBPScorePrintForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    lblPluginVersion: TLabel;
    panMemberListToolbar: TPanel;
    btnSelectMember: TBitBtn;
    dsrScorePrintList: TDataSource;
    dsrScorePrintDetail: TDataSource;
    G1: TcxGrid;
    V1: TcxGridDBBandedTableView;
    L1: TcxGridLevel;
    G2: TcxGrid;
    V2: TcxGridDBBandedTableView;
    L2: TcxGridLevel;
    V1assign_no: TcxGridDBBandedColumn;
    V1lane_nm: TcxGridDBBandedColumn;
    V1start_datetime: TcxGridDBBandedColumn;
    V1end_datetime: TcxGridDBBandedColumn;
    V2bowler_id: TcxGridDBBandedColumn;
    V2bowler_nm: TcxGridDBBandedColumn;
    V2member_no: TcxGridDBBandedColumn;
    V2total_score_sum: TcxGridDBBandedColumn;
    V2top_score: TcxGridDBBandedColumn;
    V2avg_score: TcxGridDBBandedColumn;
    Panel1: TPanel;
    panMemberListHeader: TPanel;
    lblSearchTitle: TLabel;
    lblSaleDate: TLabel;
    btnSearchAssign: TBitBtn;
    edtSearchDate: TDBDateTimeEditEh;
    G3: TcxGrid;
    V3: TcxGridDBBandedTableView;
    V3bowler_nm: TcxGridDBBandedColumn;
    V3game_seq_1: TcxGridDBBandedColumn;
    V3game_seq_2: TcxGridDBBandedColumn;
    V3game_seq_3: TcxGridDBBandedColumn;
    V3game_seq_4: TcxGridDBBandedColumn;
    V3game_seq_5: TcxGridDBBandedColumn;
    V3game_seq_6: TcxGridDBBandedColumn;
    L3: TcxGridLevel;
    dsrScorePrintGame: TDataSource;
    V3game_seq_7: TcxGridDBBandedColumn;
    V3game_seq_8: TcxGridDBBandedColumn;
    V3game_seq_9: TcxGridDBBandedColumn;
    V3game_seq_10: TcxGridDBBandedColumn;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSearchAssignClick(Sender: TObject);
    procedure V1FocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
    procedure btnSelectMemberClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FIndex: ShortInt;
    FWorking: Boolean;
    FAssignNo: string;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure SelectedMember(const AMemberNo, AMemberDiv: string); overload;
    procedure SelectedMember(const AMemberNo, ADCFeeDiv, AProdCode: string; const AMembershipSeq: Integer; const AShoesFree: Boolean); overload;
    procedure RefreshDataSet;
    function RefreshDataSetDetailList(const AAssignNo: string): Boolean;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;
implementation
uses
  { Native }
  Vcl.Graphics, Vcl.Dialogs, System.Variants, System.Math,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.LayeredForm, Common.BPMsgBox,
  Common.BPZipCode;
var
  LF: TLayeredForm;
{$R *.dfm}
{ TBPMemberForm }
constructor TBPScorePrintForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);
  LF := TLayeredForm.Create(nil);
  LF.Show;
  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
  FOwnerId := 0;
  FIndex := -1;
  FWorking := False;
  FAssignNo := '';
  lblPluginVersion.Caption := Format('Plugin v%s', [GetModuleVersion(GetModuleName(HInstance))]);
  edtSearchDate.Value := Now;
  //LSaleDate := FormatDateTime('yyyymmdd', edtSearchDate.Value);
  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;
destructor TBPScorePrintForm.Destroy;
begin
  LF.Release;
  inherited Destroy;
end;
procedure TBPScorePrintForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
procedure TBPScorePrintForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;
procedure TBPScorePrintForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
  end;
end;
procedure TBPScorePrintForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;
procedure TBPScorePrintForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;
procedure TBPScorePrintForm.btnSearchAssignClick(Sender: TObject);
begin
  RefreshDataSet;
end;
procedure TBPScorePrintForm.btnSelectMemberClick(Sender: TObject);
var
  LReceiptJson, LResMsg, sAssignNo, sLaneNm, sStartDate: string;
  rScorePrintDetail: TArray<TScorePrintDetail>;
  nIdx: Integer;
  I: Integer;
begin

  with V2.DataController.DataSet do
  begin

    try
      Screen.Cursor := crSQLWait;
      DisableControls;
      SetLength(rScorePrintDetail, RecordCount);
      nIdx := 0;
      First;
      while not Eof do
      begin
        rScorePrintDetail[nIdx].BowlerId := FieldByName('bowler_id').AsString;
        rScorePrintDetail[nIdx].BowlerNm := FieldByName('bowler_nm').AsString;
        rScorePrintDetail[nIdx].TotalScoreSum := FieldByName('total_score_sum').AsInteger;
        rScorePrintDetail[nIdx].TopScore := FieldByName('top_score').AsInteger;
        rScorePrintDetail[nIdx].AvgScore := FieldByName('avg_score').AsInteger;

        Inc(nIdx);
        Next;
      end;

    finally
      EnableControls;
      Screen.Cursor := crDefault;
    end;

  end;

  with V3.DataController.DataSet do
  begin

    try
      Screen.Cursor := crSQLWait;
      DisableControls;
      First;
      while not Eof do
      begin
        for I := 0 to Pred(Length(rScorePrintDetail)) do
        begin
          if rScorePrintDetail[I].BowlerId <> FieldByName('bowler_id').AsString then
            Continue;

          rScorePrintDetail[i].GameCount := FieldByName('game_count').AsInteger;
          rScorePrintDetail[i].GameSeq1 := FieldByName('game_seq_1').AsString;
          rScorePrintDetail[i].GameSeq2 := FieldByName('game_seq_2').AsString;
          rScorePrintDetail[i].GameSeq3 := FieldByName('game_seq_3').AsString;
          rScorePrintDetail[i].GameSeq4 := FieldByName('game_seq_4').AsString;
          rScorePrintDetail[i].GameSeq5 := FieldByName('game_seq_5').AsString;
          rScorePrintDetail[i].GameSeq6 := FieldByName('game_seq_6').AsString;
          rScorePrintDetail[i].GameSeq7 := FieldByName('game_seq_7').AsString;
          rScorePrintDetail[i].GameSeq8 := FieldByName('game_seq_8').AsString;
          rScorePrintDetail[i].GameSeq9 := FieldByName('game_seq_9').AsString;
          rScorePrintDetail[i].GameSeq10 := FieldByName('game_seq_10').AsString;
        end;
        Next;
      end;

    finally
      EnableControls;
      Screen.Cursor := crDefault;
    end;

  end;

  try
    sAssignNo := V1.DataController.DataSet.FieldByName('assign_no').AsString;
    sLaneNm := V1.DataController.DataSet.FieldByName('lane_nm').AsString;
    sStartDate := V1.DataController.DataSet.FieldByName('start_datetime').AsString;
    LReceiptJson := BPDM.MakeScorePrintJson(sAssignNo, sLaneNm, sStartDate, rScorePrintDetail, Global.DateTime.FormattedCurrentDate, Global.DateTime.FormattedCurrentTime.Substring(0, 5), LResMsg);
    if not LResMsg.IsEmpty then
      raise Exception.Create(LResMsg);

    Global.ReceiptPrint.IsRefund := False;
    if Global.ReceiptPrinter.Enabled then
      if not Global.ReceiptPrint.ScorePrint(LReceiptJson, False, LResMsg) then
        raise Exception.Create(LResMsg);

  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '게임내역 출력에 장애가 발생했습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPScorePrintForm.V1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  if G1.Enabled then
    //RefreshDataSet(False);
    RefreshDataSetDetailList(V1.DataController.DataSet.FieldByName('assign_no').AsString);
end;

procedure TBPScorePrintForm.SelectedMember(const AMemberNo, AMemberDiv: string);
begin
  //SelectedMember(AMemberNo, '', '', 0, False);
  SelectedMember(AMemberNo, AMemberDiv, '', 0, False);
end;
procedure TBPScorePrintForm.SelectedMember(const AMemberNo, ADCFeeDiv, AProdCode: string; const AMembershipSeq: Integer; const AShoesFree: Boolean);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_SELECT_MEMBER;
    PM.AddParams(CPP_MEMBER_NO, AMemberNo);
    PM.AddParams(CPP_DC_FEE_DIV, ADCFeeDiv);
    PM.AddParams(CPP_PROD_CD, AProdCode);
    PM.AddParams(CPP_MEMBERSHIP_SEQ, AMembershipSeq);
    PM.AddParams(CPP_SHOES_FREE_YN, AShoesFree);
    PM.PluginMessageToID(FOwnerId);
    Self.ModalResult := mrOK;
  finally
    FreeAndNil(PM);
  end;
end;
procedure TBPScorePrintForm.RefreshDataSet;
var
  LSaleDate, LResMsg: string;
begin
  if FWorking then
    Exit;
  FWorking := True;
  Screen.Cursor := crSQLWait;
  try
    LSaleDate := FormatDateTime('yyyy-mm-dd', edtSearchDate.Value);
    try
      if not BPDM.GetScorePrintList(LSaleDate, LResMsg) then
        raise Exception.Create(LResMsg);
      with V1.DataController.DataSet do
        if (RecordCount > 0) then
        begin
          //btnCancelReceipt.Enabled := (not FieldByName('cancel_yn').AsBoolean) and (FieldByName('approval_cnt').AsInteger = FieldByName('cancel_cnt').AsInteger);
          if not RefreshDataSetDetailList(V1.DataController.DataSet.FieldByName('assign_no').AsString) then
            Exit;
        end;
    finally
      Screen.Cursor := crDefault;
      FWorking := False;
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림', '게임 내역을 조회할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;
function TBPScorePrintForm.RefreshDataSetDetailList(const AAssignNo: string): Boolean;
var
  LResMsg: string;
begin
  if (AAssignNo = '') or (FAssignNo = AAssignNo) then
    Exit;

  FAssignNo := AAssignNo;

  Screen.Cursor := crSQLWait;
  Result := False;
  try
    try
      if not BPDM.GetScorePrintDetailList(AAssignNo, LResMsg) then
        raise Exception.Create(LResMsg);
      Result := True;
    finally
      Screen.Cursor := crDefault;
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림', '게임 상세 내역을 조회할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;
////////////////////////////////////////////////////////////////////////////////////////////////////
function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPScorePrintForm.Create(Application, AMsg);
end;
exports
  OpenPlugin;
end.
