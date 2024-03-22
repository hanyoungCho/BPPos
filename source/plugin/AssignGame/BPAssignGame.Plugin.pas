(*******************************************************************************
  Project     : ������ POS �ý���
  Title       : ���� ���� �÷�����
  Author      : �̼���
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.
  Copyright��SolbiPOS Co., Ltd. 2008-2023 All rights reserved.
*******************************************************************************)
unit BPAssignGame.Plugin;
interface
uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Mask, Vcl.NumberBox, Data.DB,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { EhLib }
  DBCtrlsEh,
  { Project }
  Common.BPGlobal;
{$I ..\..\common\Common.BPCommon.inc}
const
  LWM_BASE_LANE_NO    = CO_WM_USER + 100;
  LWM_BOWLER_COUNT    = CO_WM_USER + 101;
  LWM_RESET_BOWLER_ID = CO_WM_USER + 102;
  LWM_RESET_PROD_CD   = CO_WM_USER + 103;
  LWM_REMOVE_BOWLER   = CO_WM_USER + 104;
  LWM_REFRESH_LANES   = CO_WM_USER + 105;
  LWM_TOTAL_COUNT     = CO_WM_USER + 106;
  LWM_TOTAL_MIN       = CO_WM_USER + 107;
  LWM_TOTAL_AMT       = CO_WM_USER + 108;
  LC_LIMIT_BOWLER     = 6;
  LC_LIMIT_GAME_COUNT = 10;
  LC_LIMIT_GAME_MIN   = 600;
  LC_ID_DRAG_DROP = 'DragDrop';
type
  TLaneNoPanel = class(TPanel)
    StatusPanel: TPanel;
  private
    FLaneNo: ShortInt;
    FLaneStatus: Shortint;
    procedure SetLaneStatus(const AValue: Shortint);
  public
    constructor Create(AOwner: TComponent; const AIndex: ShortInt; AParent: TWinControl); reintroduce;
    destructor Destroy; override;
    property LaneNo: Shortint read FLaneNo write FLaneNo default 0;
    property LaneStatus: Shortint read FLaneStatus write SetLaneStatus default 0;
  end;
  TAssignControl = class(TPanel)
    AssignedPanel: TPanel;
    DragReorderImage: TImage;
    LabelBowlerId: TLabel;
    EditBowlerName: TDBEditEh;
    EditMembershipName: TDBEditEh;
    ButtonMemberPopup: TBitBtn;
    ButtonMemberClear: TBitBtn;
    EditProdName: TDBEditEh;
    ButtonProdPopup: TBitBtn;
    ButtonProdClear: TBitBtn;
    EditGameCount: TNumberBox;
    ButtonGameCountDec: TButton;
    ButtonGameCountInc: TButton;
    LabelGameProgress: TLabel;
    EditGameMin: TDBNumberEditEh;
    CheckBoxShoesRent: TCheckBox;
    CheckBoxShoesFree: TCheckBox;
    EditChargeAmt: TDBNumberEditEh;
    ButtonRemoveBowler: TBitBtn;
    procedure OnAssignMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnAssignDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure OnAssignDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure OnButtonMemberPopupClick(Sender: TObject);
    procedure OnButtonMemberClearClick(Sender: TObject);
    procedure OnButtonProdPopupClick(Sender: TObject);
    procedure OnButtonProdClearClick(Sender: TObject);
    procedure OnGameCountDecClick(Sender: TObject);
    procedure OnGameCountIncClick(Sender: TObject);
    procedure OnCheckBoxShoesRentClick(Sender: TObject);
    procedure OnButtonRemoveBowlerClick(Sender: TObject);
    procedure OnControlEnter(Sender: TObject);
  private
    FItemIndex: ShortInt;
    FAssignedGame: Boolean;
    FLaneNo: ShortInt;
    FAssignLaneNo: ShortInt;
    FAssignNo: string;
    FReceiptNo: string;
    FEntrySeq: Integer;
    FBowlerId: string;
    FMemberNo: string;
    FMemberName: string;
    FGameDiv: ShortInt;
    FGameCount: Integer;
    FGameMin: Integer;
    FBuyGameCount: Integer;
    FBuyGameMin: Integer;
    FGameProgress: Integer;
    FGameToCnt: Integer;
    FFeeDiv: string;
    FProdDiv: string;
    FProdDetailDiv: string;
    FProdCode: string;
    FProdName: string;
    FProdAmt: Integer;
    FDCAmt: Integer;
    FMembershipProdDiv: string;
    FMembershipProdDetailDiv: string;
    FMembershipProdCode: string;
    FMembershipSeq: Integer;
    FMembershipUseCount: Integer;
    FMembershipUseMin: Integer;
    FMembershipRemainCount: Integer;
    FMembershipRemainMin: Integer;
    FMembershipName: string;
    FShoesRent: Boolean;
    FShoesFree: Boolean;
    FChargeAmt: Integer;
    FEnableBuy: Boolean;
    procedure SetItemIndex(const AValue: ShortInt);
    procedure SetAssignedGame(const AValue: Boolean);
    procedure SetLaneNo(const AValue: ShortInt);
    procedure SetBowlerId(const AValue: string);
    function GetBowlerName: string;
    procedure SetBowlerName(const AValue: string);
    procedure SetGameCount(const AValue: Integer);
    procedure SetGameMin(const AValue: Integer);
    procedure SetGameProgress(const AValue: Integer);
    procedure SetGameToCnt(const AValue: Integer);
    procedure SetBuyGameCount(const AValue: Integer);
    procedure SetBuyGameMin(const AValue: Integer);
    procedure SetGameDiv(const AValue: ShortInt);
    procedure SetProdCode(const AValue: string);
    procedure SetProdName(const AValue: string);
    procedure SetProdAmt(const AValue: Integer);
    procedure SetChargeAmt(const AValue: Integer);
    procedure SetMembershipName(const AValue: string);
    procedure SetMembershipUseCount(const AValue: Integer);
    procedure SetMembershipUseMin(const AValue: Integer);
    procedure SetShoesRent(const AValue: Boolean);
    procedure SetShoesFree(const AValue: Boolean);
    procedure SetEnableBuy(const AValue: Boolean);
  public
    constructor Create(AOwner: TComponent; const AItemIndex: ShortInt; const AParent: TWinControl); reintroduce;
    destructor Destroy; override;
    property ItemIndex: ShortInt read FItemIndex write SetItemIndex default 0;
    property AssignedGame: Boolean read FAssignedGame write SetAssignedGame default False;
    property LaneNo: ShortInt read FLaneNo write SetLaneNo default 0;
    property AssignLaneNo: ShortInt read FAssignLaneNo write FAssignLaneNo default 0;
    property AssignNo: string read FAssignNo write FAssignNo;
    property ReceiptNo: string read FReceiptNo write FReceiptNo;
    property EntrySeq: Integer read FEntrySeq write FEntrySeq default 0;
    property BowlerId: string read FBowlerId write SetBowlerId;
    property BowlerName: string read GetBowlerName write SetBowlerName;
    property MemberNo: string read FMemberNo write FMemberNo;
    property MemberName: string read FMemberName write FMemberName;
    property GameDiv: ShortInt read FGameDiv write SetGameDiv default CO_RATEPLAN_GAME;
    property GameCount: Integer read FGameCount write SetGameCount default 1;
    property GameMin: Integer read FGameMin write SetGameMin default 0;
    property BuyGameCount: Integer read FBuyGameCount write SetBuyGameCount default 0;
    property BuyGameMin: Integer read FBuyGameMin write SetBuyGameMin default 0;
    property GameProgress: Integer read FGameProgress write SetGameProgress default 0;
    property GameToCnt: Integer read FGameToCnt write SetGameToCnt default 0;
    property FeeDiv: string read FFeeDiv write FFeeDiv;
    property ProdDiv: string read FProdDiv write FProdDiv;
    property ProdDetailDiv: string read FProdDetailDiv write FProdDetailDiv;
    property ProdCode: string read FProdCode write SetProdCode;
    property ProdName: string read FProdName write SetProdName;
    property ProdAmt: Integer read FProdAmt write SetProdAmt default 0;
    property DCAmt: Integer read FDCAmt write FDCAmt default 0;
    property MembershipProdDiv: string read FMembershipProdDiv write FMembershipProdDiv;
    property MembershipProdDetailDiv: string read FMembershipProdDetailDiv write FMembershipProdDetailDiv;
    property MembershipProdCode: string read FMembershipProdCode write FMembershipProdCode;
    property MembershipSeq: Integer read FMembershipSeq write FMembershipSeq default 0;
    property MembershipUseCount: Integer read FMembershipUseCount write SetMembershipUseCount default 0;
    property MembershipUseMin: Integer read FMembershipUseMin write SetMembershipUseMin default 0;
    property MembershipRemainCount: Integer read FMembershipRemainCount write FMembershipRemainCount default 0;
    property MembershipRemainMin: Integer read FMembershipRemainMin write FMembershipRemainMin default 0;
    property MembershipName: string read FMembershipName write SetMembershipName;
    property ShoesRent: Boolean read FShoesRent write SetShoesRent default True;
    property ShoesFree: Boolean read FShoesFree write SetShoesFree default False;
    property ChargeAmt: Integer read FChargeAmt write SetChargeAmt default 0;
    property EnableBuy: Boolean read FEnableBuy write SetEnableBuy default False;
  end;
  TBPAssignGameForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    lblPluginVersion: TLabel;
    panMinimap: TPanel;
    panMain: TPanel;
    panAssignInfo: TPanel;
    rdgBaseGameDiv: TRadioGroup;
    btnBaseGameCountInc: TBitBtn;
    btnBaseGameCountDec: TBitBtn;
    btnBowlerCountDec: TBitBtn;
    btnBowlerCountInc: TBitBtn;
    btnBaseProdPopup: TBitBtn;
    edtBaseProdName: TDBEditEh;
    edtBowlerCount: TNumberBox;
    edtBaseGameCount: TNumberBox;
    lblBowlerCount: TLabel;
    lblBaseGameCount: TLabel;
    panAssignList: TPanel;
    panAssignListHeader: TPanel;
    lblBowerNameTitle: TLabel;
    lblGameCountTitle: TLabel;
    lblShoesRentTitle: TLabel;
    lblChargeAmtTitle: TLabel;
    lblProdNameTitle: TLabel;
    sbxAssignList: TScrollBox;
    TemplateAssignPanel: TPanel;
    _EditBowlerName: TDBEditEh;
    _CheckboxShoesRent: TCheckBox;
    _EditChargeAmt: TDBNumberEditEh;
    _ButtonMemberPopup: TBitBtn;
    _ButtonGameCountDec: TButton;
    _ButtonGameCountInc: TButton;
    _EditProdName: TDBEditEh;
    _ButtonProdPopup: TBitBtn;
    _EditGameCount: TNumberBox;
    panAssignListFooter: TPanel;
    edtChargeAmtTotal: TDBNumberEditEh;
    edtBaseProdAmt: TDBNumberEditEh;
    btnBaseProdClear: TBitBtn;
    _ButtonProdClear: TBitBtn;
    _LabelBowlerId: TLabel;
    btnClearAssignList: TBitBtn;
    lblGameMinTitle: TLabel;
    btnDoAssign: TBitBtn;
    _ButtonMemberClear: TBitBtn;
    lblRemoveBowlerTitle: TLabel;
    _ButtonRemoveBolwer: TButton;
    lblBowlerIdTitle: TLabel;
    _DragReorderImage: TImage;
    btnDoReserve: TBitBtn;
    TemplateAssignedPanel: TPanel;
    lblGameProgressTitle: TLabel;
    _LabelGameProgress: TLabel;
    _CheckboxShoesFree: TCheckBox;
    edtUseGameMinTotal: TDBNumberEditEh;
    _EditGameMin: TDBNumberEditEh;
    lblBaseGameMin: TLabel;
    btnBaseGameMinDec: TBitBtn;
    edtBaseGameMin: TNumberBox;
    btnBaseGameMinInc: TBitBtn;
    _EditMembershipName: TDBEditEh;
    edtUseGameCountTotal: TDBNumberEditEh;
    btnCheckOut: TBitBtn;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnClearAssignListClick(Sender: TObject);
    procedure btnBowlerCountDecClick(Sender: TObject);
    procedure btnBowlerCountIncClick(Sender: TObject);
    procedure btnBaseGameCountDecClick(Sender: TObject);
    procedure btnBaseGameCountIncClick(Sender: TObject);
    procedure btnBaseProdPopupClick(Sender: TObject);
    procedure btnBaseProdClearClick(Sender: TObject);
    procedure rdgBaseGameDivClick(Sender: TObject);
    procedure btnDoReserveClick(Sender: TObject);
    procedure btnDoAssignClick(Sender: TObject);
    procedure edtBaseProdNameClick(Sender: TObject);
    procedure sbxAssignListMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure OnLaneNoPanelClick(Sender: TObject);
    procedure btnBaseGameMinDecClick(Sender: TObject);
    procedure btnBaseGameMinIncClick(Sender: TObject);
    procedure btnCheckOutClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FWorking: Boolean;
    FTitle: string;
    FBaseLaneNo: ShortInt;
    FBaseAssignNo: string;
    FBaseLaneStatus: Integer;
    FEditMode: Boolean;
    FCanReserve: Boolean;
    FRallyMode: Boolean;
    FBowlerCount: ShortInt;
    FBaseGameCount: Integer;
    FBaseGameMin: Integer;
    FBaseFeeDiv: string;
    FBaseProdDiv: string;
    FBaseProdDetailDiv: string;
    FBaseProdCode: string;
    FBaseProdName: string;
    FBaseProdAmt: Integer;
    FBaseProdGameCnt: Integer;
    FBaseProdGameMin: Integer;
    FBaseProdShoesFree: Boolean;
    FBaseGameDiv: ShortInt;
    FBasePaymentType: Integer;
    FDataSet: TDataSet;
    FEditRecceiptNo: string;
    FGameMinTotal: Integer;
    FChargeAmtTotal: Integer;
    FNormalClosing: Boolean;
    FLaneNoPanels: TArray<TLaneNoPanel>;
    FGameCountTotal: integer;
    FReserveMode: Boolean;
    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure LoadAssignList(const ALaneNo: ShortInt);
    procedure ClearAssignList;
    procedure GetDefaultProdInfo(const AGameDiv: ShortInt);
    procedure UpdateMemberInfo(const AIndex: ShortInt; const AMemberNo: string; const AMembershipSeq: Integer);
    procedure UpdateProdInfo(const AIndex: ShortInt; const AFeeDiv, AProdDiv, AProdDetailDiv, AProdCode, AProdName: string; const AProdAmt, AMembershipSeq, AUseGameCnt, AUseGameMin: Integer; const AShoesFree: Boolean);
    function CheckAssignInfo: Boolean;
    procedure ResetAssignList(const ADelete: Boolean; const ALaneNo: ShortInt);
    procedure ResetBowlerId;
    function SelectGameProd(var AResMsg: string): Boolean;
    procedure DoEditGame;
    procedure DoAssignGame;
    procedure DoRemoveBowler(const AItemIndex: ShortInt);
    procedure DoResetProdInfo(const AItemIndex: ShortInt);
    procedure SetTitle(const AValue: string);
    procedure SetBaseLaneNo(const AValue: ShortInt);
    procedure SetBowlerCount(const AValue: ShortInt);
    procedure SetBaseGameCount(const AValue: Integer);
    procedure SetBaseGameMin(const AValue: Integer);
    procedure SetBaseGameDiv(const AValue: ShortInt);
    procedure SetBaseProdCode(const AValue: string);
    procedure SetBaseProdAmt(const AValue: Integer);
    procedure SetBaseProdName(const AValue: string);
    procedure SetGameMinTotal(const AValue: integer);
    procedure SetGameCountTotal(const AValue: integer);
    procedure SetChargeAmtTotal(const AValue: Integer);
    procedure SetCanReserve(const AValue: Boolean);
  protected
    procedure WndProc(var AMessage: TMessage); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
    property Title: string read FTitle write SetTitle;
    property EditMode: Boolean read FEditMode write FEditMode default False;
    property CanReserve: Boolean read FCanReserve write SetCanReserve default False;
    property RallyMode: Boolean read FRallyMode write FRallyMode default False;
    property BaseLaneNo: ShortInt read FBaseLaneNo write SetBaseLaneNo default 0;
    property BaseAssignNo: string read FBaseAssignNo write FBaseAssignNo;
    property BaseLaneStatus: Integer read FBaseLaneStatus write FBaseLaneStatus;
    property BowlerCount: ShortInt read FBowlerCount write SetBowlerCount default 0;
    property BaseGameCount: Integer read FBaseGameCount write SetBaseGameCount default 0;
    property BaseGameMin: Integer read FBaseGameMin write SetBaseGameMin default 0;
    property BaseGameDiv: ShortInt read FBaseGameDiv write SetBaseGameDiv default CO_RATEPLAN_GAME;
    property BaseFeeDiv: string read FBaseFeeDiv write FBaseFeeDiv;
    property BaseProdDiv: string read FBaseProdDiv write FBaseProdDiv;
    property BaseProdDetailDiv: string read FBaseProdDetailDiv write FBaseProdDetailDiv;
    property BaseProdCode: string read FBaseProdCode write SetBaseProdCode;
    property BaseProdName: string read FBaseProdName write SetBaseProdName;
    property BaseProdAmt: Integer read FBaseProdAmt write SetBaseProdAmt default 0;
    property BaseProdGameCnt: Integer read FBaseProdGameCnt write FBaseProdGameCnt default 0;
    property BaseProdGameMin: Integer read FBaseProdGameMin write FBaseProdGameMin default 0;
    property BaseProdShoesFree: Boolean read FBaseProdShoesFree write FBaseProdShoesFree default False;
    property BasePaymentType: Integer read FBasePaymentType write FBasePaymentType default 0;
    property GameMinTotal: integer read FGameMinTotal write SetGameMinTotal default 0;
    property GameCountTotal: integer read FGameCountTotal write SetGameCountTotal default 0;
    property ChargeAmtTotal: Integer read FChargeAmtTotal write SetChargeAmtTotal default 0;
  end;
var
  BPAssignGameForm: TBPAssignGameForm;
implementation
uses
  { Native }
  Vcl.Graphics, Vcl.Dialogs, Vcl.ImgList, System.Generics.Defaults, System.Variants, System.Math,
  System.StrUtils,
  { Project }
  Common.BPDM, Common.BPCommonLib, Common.BPMsgBox, Common.LayeredForm;
var
  LF: TLayeredForm;
  FAssignList: TStringList;
  FAssignIndex: ShortInt;
{$R *.dfm}
{ TBPAssignGameForm }
(*
procedure HexToBinTest;
var
  LHexStr, LValue: AnsiString;
  LLength: ShortInt;
begin
  LHexStr := '0D416E696D6174696F6E4473700D0A02000000930D';
  LLength := Length(LHexStr) div 2;
  SetLength(LValue, LLength + 1);
  HexToBin(PAnsiChar(LHexStr), LValue[1], Length(LValue));
  LValue := StringReplace(StringReplace(StringReplace(LValue, #$0D, '@', [rfReplaceAll]), #$0A, '#', [rfReplaceAll]), #$00, '_', [rfReplaceAll]);
  UpdateLog(Format('HexToBin.Result = Hex: %s, Bin: %s', [LHexStr, LValue]));
end;
*)
constructor TBPAssignGameForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);
  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
  LF := TLayeredForm.Create(nil);
  LF.Show;
  Global.Plugin.AssignGamePluginId := Self.PluginID;
  FOwnerId := 0;
  FTitle := panHeader.Caption;
  FEditMode := False;
  FCanReserve := False;
  FRallyMode :=  False;
  FWorking := False;
  FBowlerCount := 0;
  FBaseLaneNo := 0;
  FBaseAssignNo := '';
  FBaseFeeDiv := '';
  FBaseProdDiv := '';
  FBaseProdDetailDiv := '';
  FBaseProdCode := '';
  FBaseProdName := '';
  FBaseProdAmt := 0;
  FBaseGameCount := 1;
  FBaseGameMin := 0;
  FBaseGameDiv := CO_RATEPLAN_GAME;
  FGameMinTotal := 0;
  FChargeAmtTotal := 0;
  FNormalClosing := False;
  FAssignIndex := -1;
  FReserveMode := False;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  panAssignInfo.Visible := False;
  panAssignList.Visible := False;
  lblBowlerCount.Caption := Format('%s (�ִ� %d ��)', [lblBowlerCount.Caption, LC_LIMIT_BOWLER]);
  edtBowlerCount.MinValue := 1;
  edtBowlerCount.MaxValue := LC_LIMIT_BOWLER;
  edtBowlerCount.MaxLength := 2;
  edtBaseGameCount.MinValue := 1;
  edtBaseGameCount.MaxValue := LC_LIMIT_GAME_COUNT;
  edtBaseGameCount.MaxLength := 2;
  btnDoReserve.Enabled := False;
  btnDoAssign.Enabled := False;
  btnCheckOut.Enabled := False;
  FAssignList := TStringList.Create;
  SetLength(FLaneNoPanels, Global.LaneInfo.LaneCount);
  for var I: ShortInt := 0 to Pred(Global.LaneInfo.LaneCount) do
  begin
    FLaneNoPanels[I] := TLaneNoPanel.Create(nil, I, panMinimap);
    FLaneNoPanels[I].LaneNo := Global.LaneInfo.Lanes[I].LaneNo;
    FLaneNoPanels[I].LaneStatus := Global.LaneInfo.Lanes[I].LaneStatus;
    FLaneNoPanels[I].OnClick := OnLaneNoPanelClick;
  end;

  GetDefaultProdInfo(BaseGameDiv);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

end;
destructor TBPAssignGameForm.Destroy;
begin
  Global.Plugin.AssignGamePluginId := 0;
  LF.Release;
  inherited Destroy;
end;
procedure TBPAssignGameForm.WndProc(var AMessage: TMessage);
var
  LValue: Integer;
begin
  case AMessage.Msg of
    LWM_TOTAL_COUNT:
      begin
        LValue := 0;
        if (BaseGameDiv = CO_RATEPLAN_GAME) then
        begin
          for var I: ShortInt := 0 to Pred(FAssignList.Count) do
            LValue := (LValue + TAssignControl(FAssignList.Objects[I]).GameCount);
        end
        //chy test
        else if (BaseGameDiv = CO_RATEPLAN_TIME) then
        begin
          LValue := BaseGameCount;
        end;
        GameCountTotal := LValue;
      end;
    LWM_TOTAL_MIN:
      begin
        LValue := 0;
        if (BaseGameDiv = CO_RATEPLAN_GAME) then
        begin
          for var I: ShortInt := 0 to Pred(FAssignList.Count) do
            LValue := (LValue + TAssignControl(FAssignList.Objects[I]).GameMin);
        end
        else if (BaseGameDiv = CO_RATEPLAN_TIME) then
        begin
          LValue := (BaseGameCount * BaseGameMin);
        end;
        GameMinTotal := LValue;
      end;
    LWM_TOTAL_AMT:
      begin
        LValue := 0;
        for var I: ShortInt := 0 to Pred(FAssignList.Count) do
          LValue := (LValue + TAssignControl(FAssignList.Objects[I]).ChargeAmt);
        //chy test
        if (BaseGameDiv = CO_RATEPLAN_TIME) then
        begin
          LValue := (LValue + (BaseGameCount* BaseProdAmt));
        end;
        ChargeAmtTotal := LValue;
      end;
    LWM_RESET_BOWLER_ID:
      ResetBowlerId;
    LWM_RESET_PROD_CD:
      DoResetProdInfo(AMessage.WParam);
    LWM_BOWLER_COUNT:
      BowlerCount := AMessage.WParam;
    LWM_REMOVE_BOWLER:
      DoRemoveBowler(AMessage.WParam);
    LWM_REFRESH_LANES:
      ResetAssignList((AMessage.WParam = 1), AMessage.LParam);
  end;
  inherited WndProc(AMessage);
end;
procedure TBPAssignGameForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  panMinimap.Visible := False;
  for var I: ShortInt := 0 to High(FLaneNoPanels) do
    FLaneNoPanels[I].Free;
  Action := caFree;
end;
procedure TBPAssignGameForm.PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FNormalClosing or
    (FAssignList.Count = 0) or
    (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��', '���� ���� ȭ���� �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) = mrOK);
end;
procedure TBPAssignGameForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;
procedure TBPAssignGameForm.ProcessMessages(AMsg: TPluginMessage);
var
  LIndex, LLaneNo, LStatus: ShortInt;
  LAssignNo, LFeeDiv, LProdDiv, LProdDetailDiv, LMemberNo, LProdCode, LProdName, LDCFeeDiv: string;
  LProdAmt, LMembershipSeq, LGameCnt, LGameMin: Integer;
  LShoesFree: Boolean;
  LDataSet: TDataSet;
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    LLaneNo := AMsg.ParamByInteger(CPP_LANE_NO);
    LAssignNo := AMsg.ParamByString(CPP_ASSIGN_NO);
    FReserveMode := (not LAssignNo.IsEmpty);
    if FReserveMode then
    begin
      btnDoReserve.Enabled := False;
      FDataSet := BPDM.QRReserveList;
      if BPDM.QRReserveList.Active then
        BPDM.QRReserveList.Close;
      BPDM.QRReserveList.Params.ParamByName('p_assign_no').AsString := LAssignNo;
      BPDM.QRReserveList.Open;
    end
    else
      FDataSet := Global.LaneInfo.Lanes[Global.LaneInfo.LaneIndex(LLaneNo)].Container.GameDataSet;
    BaseLaneNo := LLaneNo;
    if (BaseLaneNo > 0) then
    begin
      //CanReserve := (Global.LaneInfo.Lanes[Global.LaneInfo.LaneIndex(BaseLaneNo)].LaneStatus in [CO_LANE_RESERVED..CO_LANE_END]);
      if FReserveMode then
        CanReserve := True
      else
        CanReserve := (FDataSet.FieldByName('assign_no').AsString <> EmptyStr);

      if CanReserve then
        LoadAssignList(BaseLaneNo)
      else
      begin
        BowlerCount := 1;
      end;
    end;
    if FReserveMode then
      Title := '���� ���� ����'
    else
      Title := '���� ���� ����';
  end
  else if (AMsg.Command = CPC_LANE_STATUS) then
  begin
    LIndex := AMsg.ParamByInteger(CPP_INDEX);
    LStatus := AMsg.ParamByInteger(CPP_VALUE);
    if (LIndex <> -1) then
      with FLaneNoPanels[LIndex].StatusPanel do
      begin
        Color := GetLaneStatusColor(LStatus);
        Visible := (LStatus <> CO_LANE_READY);
      end;
  end
  else if (AMsg.Command = CPC_SEL_PROD_GAME) then
  begin
    LIndex := AMsg.ParamByInteger(CPP_INDEX);
    LFeeDiv := AMsg.ParamByString(CPP_FEE_DIV);
    LProdDiv := AMsg.ParamByString(CPP_PROD_DIV);
    LProdDetailDiv := AMsg.ParamByString(CPP_PROD_DETAIL_DIV);
    LProdCode := AMsg.ParamByString(CPP_PROD_CD);
    LProdName := AMsg.ParamByString(CPP_PROD_NM);
    LProdAmt := AMsg.ParamByInteger(CPP_VALUE);
    LMembershipSeq := AMsg.ParamByInteger(CPP_MEMBERSHIP_SEQ);
    LGameCnt := AMsg.ParamByInteger(CPP_GAME_CNT);
    LGameMin := AMsg.ParamByInteger(CPP_GAME_MIN);
    UpdateProdInfo(LIndex, LFeeDiv, LProdDiv, LProdDetailDiv, LProdCode, LProdName, LProdAmt, LMembershipSeq, LGameCnt, LGameMin, False);
  end
  else if (AMsg.Command = CPC_SEL_PROD_GAME_DEFAULT) then
  begin
    LIndex := AMsg.ParamByInteger(CPP_INDEX);
    {
    LFeeDiv := AMsg.ParamByString(CPP_FEE_DIV);
    LProdDiv := AMsg.ParamByString(CPP_PROD_DIV);
    LProdDetailDiv := AMsg.ParamByString(CPP_PROD_DETAIL_DIV);
    LProdCode := AMsg.ParamByString(CPP_PROD_CD);
    LProdName := AMsg.ParamByString(CPP_PROD_NM);
    LProdAmt := AMsg.ParamByInteger(CPP_VALUE);
    LMembershipSeq := AMsg.ParamByInteger(CPP_MEMBERSHIP_SEQ);
    LGameMin := AMsg.ParamByInteger(CPP_GAME_MIN);
    UpdateProdInfo(LIndex, LFeeDiv, LProdDiv, LProdDetailDiv, LProdCode, LProdName, LProdAmt, LMembershipSeq, LGameMin, False);
    }
    UpdateProdInfo(LIndex, BaseFeeDiv, BaseProdDiv, BaseProdDetailDiv, BaseProdCode, BaseProdName, BaseProdAmt, 0, FBaseProdGameCnt, FBaseProdGameMin, FBaseProdShoesFree);
  end
  else if (AMsg.Command = CPC_SELECT_MEMBER) then
  begin
    LMemberNo := AMsg.ParamByString(CPP_MEMBER_NO);
    LDCFeeDiv := AMsg.ParamByString(CPP_DC_FEE_DIV);
    LProdCode := AMsg.ParamByString(CPP_PROD_CD);
    LMembershipSeq := AMsg.ParamByInteger(CPP_MEMBERSHIP_SEQ);
    LShoesFree := AMsg.ParamByBoolean(CPP_SHOES_FREE_YN);
    try
      if not BPDM.FindMemberInfo(LMemberNo) then
        raise Exception.Create(Format('ȸ���ڵ� [%s]�� ȸ�������� ã�� ���� �����ϴ�.', [LMemberNo]));
      if (FAssignIndex >= 0) then
      begin
        //ȸ�� �ߺ� üũ
        for var I: ShortInt := 0 to Pred(FAssignList.Count) do
          with TAssignControl(FAssignList.Objects[I]) do
            if (I <> FAssignIndex) and
               (not LMemberNo.IsEmpty) and
               (MemberNo = LMemberNo) then
            begin
              raise Exception.Create(Format('%s ȸ���� ���� ��Ͽ� �̹� ��ϵǾ� �ֽ��ϴ�.', [Global.MemberInfo.MemberName]));
              Break;
            end;
        if not LDCFeeDiv.IsEmpty then
        begin
          LDataSet := BPDM.GetABSDataSet('SELECT * FROM MEMORY MTProdGame WHERE membership_yn = False');
          with LDataSet do
          try
            if not Locate('fee_div', LDCFeeDiv, []) then
              raise Exception.Create(Format('���ȸ���� ���α��� [%s]�� ����� ��ǰ�� �������� �ʽ��ϴ�.', [LDCFeeDiv]));
            LIndex := FAssignIndex;
            LFeeDiv := FieldByName('fee_div').AsString;
            LProdDiv := CO_PROD_GAME;
            LProdDetailDiv := FieldByName('prod_detail_div').AsString;
            LProdCode := FieldByName('prod_cd').AsString;
            LProdName := FieldByName('prod_nm').AsString;
            LProdAmt := FieldByName('prod_amt').AsInteger;
            LGameCnt := FieldByName('use_game_cnt').AsInteger;
            LGameMin := FieldByName('use_game_min').AsInteger;
            UpdateProdInfo(LIndex, LFeeDiv, LProdDiv, LProdDetailDiv, LProdCode, LProdName, LProdAmt, LMembershipSeq, LGameCnt, LGameMin, LShoesFree);
          finally
            Close;
            Free;
          end;
        end;
        if not LMemberNo.IsEmpty then
          UpdateMemberInfo(FAssignIndex, LMemberNo, LMembershipSeq);
      end;
    except
      on E: Exception do
        BPMsgBox(Self.Handle, mtWarning, '�˸�', 'ȸ�� ������ǰ ���ÿ� �����Ͽ����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5)
    end;
  end;
end;
procedure TBPAssignGameForm.rdgBaseGameDivClick(Sender: TObject);
begin
  BaseGameDiv := (TRadioGroup(Sender).ItemIndex + 1);
  GetDefaultProdInfo(BaseGameDiv);
end;
procedure TBPAssignGameForm.sbxAssignListMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  SendMessage(TScrollBox(Sender).Handle, WM_VSCROLL, IfThen(WheelDelta >= 0, SB_LINELEFT, SB_LINERIGHT), 0);
  Handled := True;
end;
procedure TBPAssignGameForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    Self.Close;
end;
procedure TBPAssignGameForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;
procedure TBPAssignGameForm.OnLaneNoPanelClick(Sender: TObject);
begin
  if FReserveMode then
    Exit;
  with Global.LaneInfo.Lanes[TPanel(Sender).Tag] do
  begin
    CanReserve := False;
    if (LaneStatus = CO_LANE_HOLD) then
    begin
      BPMsgBox(Self.Handle, mtWarning, '�˸�',
        ErrorString(LaneNo.ToString) + ' ������ �ٸ� �̿��ڿ� ���� ������ ���� ���Դϴ�.' + _BR + '��� �� �ٽ� �õ��Ͽ� �ֽʽÿ�.', ['Ȯ��'], 5);
      Exit;
    end
    else if (LaneStatus in [CO_LANE_RESERVED..CO_LANE_END]) then
    begin
      CanReserve := True;
      LoadAssignList(LaneNo);
      Title := '���� ���';
    end
    else
    begin
      EditMode := False;
      BaseLaneNo := 0;
      ClearAssignList;
    end;
    if (FAssignList.Count = 0) then
      BowlerCount := 1;
    BaseLaneNo := LaneNo;
  end;
end;
procedure TBPAssignGameForm.btnCheckOutClick(Sender: TObject);
var
  LJobName, LResMsg: string;
  BI: TArray<TBowlerRec>;
  LItemCount: Integer;
  LReceiptNo: String;
begin
  LJobName := 'üũ �ƿ�';

  if (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��', Format('<B>%d</B> ���ο� <B>', [BaseLaneNo]) + ErrorString(LJobName) + '</B> ����� �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOk) then
    Exit;

  try
    {
    LSQL := Format('SELECT seq FROM TBPayment WHERE receipt_no = %s;', [ReceiptNo.QuotedString]);
    LCount := BPDM.GetABSRecordCount(LSQL, LResMsg);
    if not LResMsg.IsEmpty then
      raise Exception.Create('������ ������ Ȯ���� �� �����ϴ�.' + _BR + LResMsg);
    if (LCount > 0) then
    begin
      BPMsgBox(Self.Handle, mtWarning, '�˸�', '����� ����/������ ���� ������ �����մϴ�.' + _BR + '�ش� ���� ������ ���� ����Ͽ��� �մϴ�.', ['Ȯ��'], 5);
      Exit;
    end;
    }

    LItemCount := FAssignList.Count;
    SetLength(BI, LItemCount);

    for var I: ShortInt := 0 to Pred(LItemCount) do
    begin
      with TAssignControl(FAssignList.Objects[I]) do
      begin
        LReceiptNo := ReceiptNo;
        BI[I].EntrySeq := EntrySeq;
        BI[I].BowlerId := BowlerId;
        BI[I].BowlerName := IfThen(BowlerName.IsEmpty, BowlerId, BowlerName);
        BI[I].MemberNo := MemberNo;
        BI[I].FeeDiv := FeeDiv;
        BI[I].GameCount := GameCount;
        BI[I].GameMin := IfThen(GameDiv = CO_RATEPLAN_TIME, GameMin, 0);
        BI[I].MembershipSeq := MembershipSeq;
        BI[I].MembershipUseCount := MembershipUseCount;
        BI[I].MembershipUseMin := MembershipUseMin;
        BI[I].ShoesRent := ShoesRent;
        BI[I].ShoesFree := ShoesFree;
        BI[I].PaymentType := CO_PAYTYPE_DEFERRED;
        BI[I].ProdInfo.AssignLaneNo := AssignLaneNo;
        BI[I].ProdInfo.AssignNo := AssignNo;
        BI[I].ProdInfo.BowlerId := BowlerId;
        BI[I].ProdInfo.ProdDiv := ProdDiv;
        BI[I].ProdInfo.ProdDetailDiv := ProdDetailDiv;
        BI[I].ProdInfo.ProdCode := ProdCode;
        BI[I].ProdInfo.ProdName := ProdName;
        BI[I].ProdInfo.ProdAmt := ProdAmt;
        BI[I].ProdInfo.OrderQty := GameCount;
      end;
    end;

    if not BPDM.CheckOut(BaseLaneNo, BaseAssignNo, LReceiptNo, BI, LResMsg) then
      raise Exception.Create(LResMsg);
    //SendToMainForm(CPC_GAME_REFRESH_DELAY);
    //BPMsgBox(Self.Handle, mtInformation, '�˸�', Format('%s ��� ������ �Ϸ��Ͽ����ϴ�.', [LJobName]), ['Ȯ��'], 5);

    FNormalClosing := True;
    Self.ModalResult := mrOK;

  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '�˸�',
        Format('%s ��� ���ۿ� �����Ͽ����ϴ�.', [LJobName]) + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;

procedure TBPAssignGameForm.btnClearAssignListClick(Sender: TObject);
begin
  EditMode := False;
  if not CanReserve then
    BaseLaneNo := 0;
  ClearAssignList;
end;
procedure TBPAssignGameForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;
procedure TBPAssignGameForm.btnBaseProdPopupClick(Sender: TObject);
var
  LResMsg: string;
begin
  try
    if not SelectGameProd(LResMsg) then
      raise Exception.Create(LResMsg);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '�˸�', '��ǰ ����� �ҷ��� �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;
procedure TBPAssignGameForm.btnBaseProdClearClick(Sender: TObject);
begin
  BaseFeeDiv := '';
  BaseProdDiv := '';
  BaseProdDetailDiv := '';
  BaseProdCode := '';
  BaseProdName := '';
  BaseProdAmt := 0;
  for var I := 0 to Pred(FAssignList.Count) do
    with TAssignControl(FAssignList.Objects[I]) do
    begin
      FeeDiv := BaseFeeDiv;
      ProdDiv := BaseProdDiv;
      ProdDetailDiv := BaseProdDetailDiv;
      ProdCode := BaseProdCode;
      ProdName := BaseProdName;
      ProdAmt := BaseProdAmt;
    end;
end;
procedure TBPAssignGameForm.btnDoReserveClick(Sender: TObject);
begin
  if (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��', '�̹� ��� ���� �����Դϴ�.' + _BR + '������ ���·� �߰� �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
    Exit;
  TBitBtn(Sender).Enabled := False;
  CanReserve := False;
  EditMode := False;
  Title := '���� ���';
  ClearAssignList;
  BowlerCount := 1;

  btnBowlerCountDec.Enabled := True;
  btnBowlerCountInc.Enabled := True;
  rdgBaseGameDiv.Enabled := True;
  btnBaseGameCountDec.Enabled := True;
  btnBaseGameCountInc.Enabled := True;
  btnBaseGameMinDec.Enabled := True;
  btnBaseGameMinInc.Enabled := True;
  edtBaseProdName.Enabled := True;
  btnBaseProdPopup.Enabled := True;
  btnBaseProdClear.Enabled := True;

end;
procedure TBPAssignGameForm.btnDoAssignClick(Sender: TObject);
begin
  try
    if (BaseLaneNo = 0) then
      raise Exception.Create('������ ������ ���õ��� �ʾҽ��ϴ�.');
    if (BaseGameDiv = CO_RATEPLAN_TIME) and
       (GameMinTotal = 0) then
      raise Exception.Create('�ð��� ��� ��ǰ�� ���õ��� �ʾҽ��ϴ�.');
    if EditMode then
      DoEditGame
    else
      DoAssignGame;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '�˸�', '���� ��� �۾��� ������ �߻��߽��ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;
procedure TBPAssignGameForm.btnBowlerCountDecClick(Sender: TObject);
begin
  if (BowlerCount > edtBowlerCount.MinValue) then
    BowlerCount := Pred(BowlerCount);
end;
procedure TBPAssignGameForm.btnBowlerCountIncClick(Sender: TObject);
begin
  if (BowlerCount < edtBowlerCount.MaxValue) then
    BowlerCount := Succ(BowlerCount);
end;
procedure TBPAssignGameForm.btnBaseGameCountDecClick(Sender: TObject);
begin
  if (BaseGameCount > edtBaseGameCount.MinValue) then
    BaseGameCount := Pred(BaseGameCount);
end;
procedure TBPAssignGameForm.btnBaseGameCountIncClick(Sender: TObject);
begin
  if (BaseGameCount < edtBaseGameCount.MaxValue) then
    BaseGameCount := Succ(BaseGameCount);
end;
procedure TBPAssignGameForm.btnBaseGameMinDecClick(Sender: TObject);
begin
  if (BaseGameMin > edtBaseGameMin.MinValue) then
    BaseGameMin := (BaseGameMin - 10);
end;
procedure TBPAssignGameForm.btnBaseGameMinIncClick(Sender: TObject);
begin
  if (BaseGameMin < edtBaseGameMin.MaxValue) then
    BaseGameMin := (BaseGameMin + 10);
end;
procedure TBPAssignGameForm.LoadAssignList(const ALaneNo: ShortInt);
var
  LIndex, LItem, LGameCnt: ShortInt;
begin
  ClearAssignList;
  EditMode := True;
  with FDataSet do
  try
    DisableControls;
    FAssignList.BeginUpdate;
    if (RecordCount > 0) then
    begin
      LItem := 0;
      FBowlerCount := RecordCount;
      FEditRecceiptNo := '';
      edtBowlerCount.Value := FBowlerCount;
      First;
      BaseAssignNo := FieldByName('assign_no').AsString;

      //chy test
      //BaseGameDiv := FieldByName('game_div').AsInteger;
      rdgBaseGameDiv.ItemIndex := (FieldByName('game_div').AsInteger - 1);

      LGameCnt := FieldByName('game_fin').AsInteger;
      BaseLaneStatus := FieldByName('lane_status').AsInteger;
      while not Eof do
      begin
        LIndex := FAssignList.AddObject(LIndex.ToString, TAssignControl.Create(nil, LItem, sbxAssignList));
        FEditRecceiptNo := FieldByName('receipt_no').AsString;
        with TAssignControl(FAssignList.Objects[LIndex]) do
        begin
          ItemIndex := LIndex;
          AssignedGame := True;
          LaneNo := FieldByName('lane_no').AsInteger;
          AssignLaneNo := FieldByName('assign_lane_no').AsInteger;
          AssignNo := BaseAssignNo;
          ReceiptNo := FEditRecceiptNo;
          EntrySeq := FieldByName('entry_seq').AsInteger;
          BowlerId := FieldByName('bowler_id').AsString;
          BowlerName := FieldByName('bowler_nm').AsString;
          MemberNo := FieldByName('member_no').AsString;
          MemberName := FieldByName('member_nm').AsString;
          GameDiv := FieldByName('game_div').AsInteger; //���ӹ��: 1=������, 2=�ð���
          FeeDiv := FieldByName('fee_div').AsString; //�����: 01=�Ϲ�, 02=ȸ��, 03=�л�, 04=Ŭ��
          GameCount := FieldByName('game_cnt').AsInteger;
          GameMin := FieldByName('game_min').AsInteger;
          MembershipSeq := FieldByName('membership_seq').AsInteger;
          MembershipUseCount := FieldByName('membership_use_cnt').AsInteger;
          MembershipUseMin := FieldByName('membership_use_min').AsInteger;
          BuyGameCount := (GameCount - MembershipUseCount);
          BuyGameMin := (GameMin - MembershipUseMin);
          GameToCnt := FieldByName('to_cnt').AsInteger;
          GameProgress := FieldByName('game_fin').AsInteger;
          BaseGameCount := GameCount;
          //BaseGameMin := GameMin;
          ProdCode := FieldByName('prod_cd').AsString;
          ProdName := FieldByName('prod_nm').AsString;
          ProdAmt := FieldByName('prod_amt').AsInteger;
          ProdDiv := CO_PROD_GAME;
          ProdDetailDiv := FieldByName('prod_detail_div').AsString;
          ShoesRent := FieldByName('shoes_rent_yn').AsBoolean;
          ShoesFree := FieldByName('shoes_free_yn').AsBoolean;

          if (MembershipSeq = 0) and (FieldByName('payment_type').AsInteger = 1) then
            BasePaymentType := 1;

          if BasePaymentType = 1 then
          begin
            ChargeAmt := 0;
            ButtonProdPopup.Enabled := False;
            ButtonProdClear.Enabled := False;
            ButtonGameCountDec.Enabled := False;
            ButtonGameCountInc.Enabled := False;
            CheckBoxShoesRent.Enabled := False;
            ButtonRemoveBowler.Enabled := False;
          end
          else
          begin
            if (GameDiv = CO_RATEPLAN_GAME) and (FeeDiv = CO_GAMEFEE_BASIC) and (ProdCode <> Global.StoreInfo.DefaultGameProdCode) then
            begin
              ChargeAmt := (ProdAmt - FieldByName('dc_amt').AsInteger) + IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0);
              ButtonGameCountDec.Enabled := False;
              ButtonGameCountInc.Enabled := False;
            end
            else if (GameDiv = CO_RATEPLAN_TIME) then
            begin
              ChargeAmt := IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0);
              ButtonGameCountDec.Enabled := False;
              ButtonGameCountInc.Enabled := False;
            end
            else
              ChargeAmt := (ProdAmt * FieldByName('order_qty').AsInteger - FieldByName('dc_amt').AsInteger) + IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0);
          end;

          if (GameCount <> BaseGameCount) then
            BaseGameCount := GameCount;
          if not MemberNo.IsEmpty then
            UpdateMemberInfo(LIndex, MemberNo, MembershipSeq);
        end;
        Inc(LItem);
        Next;
      end;
    end;
  finally
    FAssignList.EndUpdate;
    EnableControls;
    BowlerCount := RecordCount;
    btnDoAssign.Enabled := (BaseLaneStatus <> 5);
    btnDoAssign.Caption := '���� ���';
    btnCheckOut.Enabled := ((LGameCnt > 0) and (BaseLaneStatus <> 5));

    if BasePaymentType = 1 then
    begin
      btnBowlerCountDec.Enabled := False;
      btnBowlerCountInc.Enabled := False;
      rdgBaseGameDiv.Enabled := False;
      btnBaseGameCountDec.Enabled := False;
      btnBaseGameCountInc.Enabled := False;
      btnBaseGameMinDec.Enabled := False;
      btnBaseGameMinInc.Enabled := False;
      edtBaseProdName.Enabled := False;
      btnBaseProdPopup.Enabled := False;
      btnBaseProdClear.Enabled := False;
    end;
  end;
end;
procedure TBPAssignGameForm.ClearAssignList;
begin
  BowlerCount := 0;
  BaseAssignNo := '';
  BaseGameCount := 1;
  BaseGameDiv := CO_RATEPLAN_GAME;
  rdgBaseGameDiv.ItemIndex := 0;
  btnDoAssign.Enabled := False;
  btnDoAssign.Caption := '���� ���';
  btnCheckOut.Enabled := False;
end;
procedure TBPAssignGameForm.UpdateMemberInfo(const AIndex: ShortInt; const AMemberNo: string; const AMembershipSeq: Integer);
var
  LResMsg: string;
begin
  if not BPDM.QRMembership.Active then
    if not BPDM.GetMembership(AMemberNo, '', '', LResMsg) then
      raise Exception.Create(LResMsg);
  with TAssignControl(FAssignList.Objects[AIndex]) do
  try
    if MemberNo <> AMemberNo then
    begin
      MemberNo := AMemberNo;
      MemberName := Global.MemberInfo.MemberName;
    end;
    BowlerName := MemberName;
    if (AMembershipSeq > 0) and
       BPDM.QRMembership.Locate('member_no;membership_seq', VarArrayOf([AMemberNo, AMembershipSeq]), []) then
    begin
      MembershipSeq := AMembershipSeq;
      ProdDiv := CO_PROD_MEMBERSHIP;
      ProdDetailDiv := BPDM.QRMembership.FieldByName('prod_detail_div').AsString;
      ShoesFree := BPDM.QRMembership.FieldByName('shoes_free_yn').AsBoolean;
      if (ProdDetailDiv = CO_PROD_DETAIL_MEMBER_GAME) then
      begin
        MembershipUseMin := 0;
        MembershipRemainMin := 0;
        MembershipRemainCount := BPDM.QRMembership.FieldByName('remain_game_cnt').AsInteger;
        if (MembershipRemainCount < BaseGameCount) then
        begin
          EnableBuy := True;
          BuyGameCount := (BaseGameCount - MembershipRemainCount);
          MembershipUseCount := MembershipRemainCount;
        end
        else
        begin
          EnableBuy := False;
          BuyGameCount := 0;
          MembershipUseCount := BaseGameCount;
        end;
      end
      else if (ProdDetailDiv = CO_PROD_DETAIL_MEMBER_TIME) then
      begin
        MembershipUseCount := 0;
        MembershipRemainCount := 0;
        MembershipRemainMin := BPDM.QRMembership.FieldByName('remain_game_min').AsInteger;
        if (MembershipRemainMin < BaseGameMin) then
        begin
          EnableBuy := True;
          BuyGameMin := (BaseGameMin - MembershipRemainMin);
          MembershipUseMin := MembershipRemainMin;
        end
        else
        begin
          EnableBuy := False;
          BuyGameMin := 0;
          MembershipUseMin := BaseGameMin;
        end;
      end;
      MembershipProdCode := BPDM.QRMembership.FieldByName('prod_cd').AsString;
      MembershipName := BPDM.QRMembership.FieldByName('prod_nm').AsString;
    end;
  finally
    Global.MemberInfo.Clear;
  end;
end;
procedure TBPAssignGameForm.GetDefaultProdInfo(const AGameDiv: ShortInt);
var
  LProdCode, LProdDetailDiv, LProdName, LResMsg: string;
  LProdAmt, LGameCnt, LGameMin: Integer;
  LShoesFree: Boolean;
begin
  try
    if not BPDM.GetProdGameList(LResMsg) then
      raise Exception.Create(LResMsg);
    if not BPDM.OpenProdDataSet(BaseGameDiv, CO_PROD_GAME, '', CO_GAMEFEE_BASIC, False, True, LResMsg) then
      raise Exception.Create(LResMsg);
    case AGameDiv of
      CO_RATEPLAN_GAME: //������
        LProdCode := Global.StoreInfo.DefaultGameProdCode;
      CO_RATEPLAN_TIME: //�ð���
        LProdCode := Global.StoreInfo.DefaultTimeProdCode;
      else
        raise Exception.Create('����� �� ���� ����� ���� �ڵ�: ' + AGameDiv.ToString);
    end;
    with BPDM.QRProdGame do
    try
      DisableControls;
      if not Locate('prod_cd', LProdCode, []) then
        raise Exception.Create('��ϵ��� ���� ����� ��ǰ �ڵ�: ' + LProdCode);
      LProdDetailDiv := FieldByName('prod_detail_div').AsString;
      LProdName := FieldByName('prod_nm').AsString;
      LProdAmt := FieldByName('prod_amt').AsInteger;
      LShoesFree := FieldByName('shoes_free_yn').AsBoolean;
      LGameCnt := BPDM.QRProdGame.FieldByName('use_game_cnt').AsInteger;
      LGameMin := BPDM.QRProdGame.FieldByName('use_game_min').AsInteger;
      BaseGameMin := LGameMin;
      UpdateProdInfo(-1, CO_GAMEFEE_BASIC, CO_PROD_GAME, LProdDetailDiv, LProdCode, LProdName, LProdAmt, 0, LGameCnt, LGameMin, False);
    finally
      EnableControls;
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '�˸�', '�⺻ ����� ��ǰ ������ ��ȸ�� �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;
procedure TBPAssignGameForm.UpdateProdInfo(const AIndex: ShortInt; const AFeeDiv, AProdDiv, AProdDetailDiv, AProdCode, AProdName: string;
  const AProdAmt, AMembershipSeq, AUseGameCnt, AUseGameMin: Integer; const AShoesFree: Boolean);
begin
  if (AIndex = -1) then //��ü ����
  begin
    BaseFeeDiv := AFeeDiv;
    BaseProdDiv := AProdDiv;
    BaseProdDetailDiv := AProdDetailDiv;
    BaseProdCode := AProdCode;
    BaseProdName := AProdName;
    BaseProdAmt := AProdAmt;
    BaseProdGameCnt := AUseGameCnt;
    BaseProdGameMin := AUseGameMin;
    BaseProdShoesFree := AShoesFree;
    for var I: ShortInt := 0 to Pred(FAssignList.Count) do
      with TAssignControl(FAssignList.Objects[I]) do
      begin
        FeeDiv := AFeeDiv;
        ProdDiv := AProdDiv;
        ProdDetailDiv := AProdDetailDiv;
        ProdCode := AProdCode;
        ProdName := AProdName;
        ProdAmt := AProdAmt;
        GameMin := IfThen(GameDiv = CO_RATEPLAN_TIME, IfThen(AUseGameMin < BaseGameMin, BaseGameMin, AUseGameMin), 0);
        ShoesFree := AShoesFree;

        if (GameDiv = CO_RATEPLAN_GAME) and (FeeDiv = CO_GAMEFEE_BASIC) and (ProdCode <> Global.StoreInfo.DefaultGameProdCode) then
        begin
          GameCount := AUseGameCnt;
          ButtonGameCountDec.Enabled := False;
          ButtonGameCountInc.Enabled := False;
        end
        else if (GameDiv = CO_RATEPLAN_TIME) then
        begin
          ButtonGameCountDec.Enabled := False;
          ButtonGameCountInc.Enabled := False;
          SendMessage(Global.Plugin.AssignGamePluginId, LWM_TOTAL_AMT, 0, 0);
        end
        else
        begin
          ButtonGameCountDec.Enabled := True;
          ButtonGameCountInc.Enabled := True;
        end;
     end;
  end
  else //�� ���� �г� �� ����
  begin
    for var I: ShortInt := 0 to Pred(FAssignList.Count) do
      if (I = AIndex) then
      begin
        with TAssignControl(FAssignList.Objects[I]) do
        begin
          FeeDiv := AFeeDiv;
          ProdName := AProdName;
          GameMin := IfThen(GameDiv = CO_RATEPLAN_TIME, AUseGameMin, 0);
          ShoesFree := AShoesFree;

          if (AMembershipSeq > 0) then
          begin
            MembershipProdDiv := AProdDiv;
            MembershipProdDetailDiv := AProdDetailDiv;
            MembershipProdCode := AProdCode;
            MembershipSeq := AMembershipSeq;
            MembershipUseCount := 1;
            //if ProdCode.IsEmpty then
              //BuyGameCount := 0
            ProdCode := AProdCode;
          end
          else
          begin
            ProdDiv := AProdDiv;
            ProdDetailDiv := AProdDetailDiv;
            ProdCode := AProdCode;
            //BuyGameCount := 1;

            if (GameDiv = CO_RATEPLAN_GAME) and (FeeDiv = CO_GAMEFEE_BASIC) and (ProdCode <> Global.StoreInfo.DefaultGameProdCode) then
            begin
              BuyGameCount := AUseGameCnt;
              ButtonGameCountDec.Enabled := False;
              ButtonGameCountInc.Enabled := False;
            end
            else
            begin
              ButtonGameCountDec.Enabled := True;
              ButtonGameCountInc.Enabled := True;
            end;

            if MembershipProdCode.IsEmpty then
              MembershipUseCount := 0;
          end;

          ProdAmt := AProdAmt; //�ݾװ��
        end;
        Break;
      end;
  end;
end;
function TBPAssignGameForm.CheckAssignInfo: Boolean;
begin
  Result := False;
  try
    for var I: ShortInt := 0 to Pred(FAssignList.Count) do
      with TAssignControl(FAssignList.Objects[I]) do
        if ProdCode.IsEmpty and
           (GameCount <> MembershipUseCount) then
          raise Exception.Create(Format('%s ���� ������ ���� ����� ������ ���õ��� �ʾҽ��ϴ�.', [BowlerId]));
    Result := True;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '�˸�', '�ʼ� ���� ������ �����Ǿ����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;
procedure TBPAssignGameForm.ResetAssignList(const ADelete: Boolean; const ALaneNo: ShortInt);
begin
  if ADelete then
    for var I: ShortInt := Pred(FAssignList.Count) downto 0 do
      if (TAssignControl(FAssignList.Objects[I]).LaneNo = ALaneNo) then
        DoRemoveBowler(TAssignControl(FAssignList.Objects[I]).ItemIndex);
end;
procedure TBPAssignGameForm.ResetBowlerId;
var
  sBowlerId: String;
  nByte: Byte;
begin
  nByte := 65;

  for var I: ShortInt := 0 to Pred(FAssignList.Count) do
  begin
    with TAssignControl(FAssignList.Objects[I]) do
    begin
      if BowlerId.IsEmpty then
        BowlerId := Format('%.2d%s', [BaseLaneNo, Char(65 + I)]);
      {  BowlerId := Format('%.2d%s', [BaseLaneNo, Char(nByte)])
      else
      begin
        sBowlerId := copy(BowlerId, 3, 1);
        nByte := Ord(sBowlerId[1]) + 1;
      end;}
    end;
  end;

end;
function TBPAssignGameForm.SelectGameProd(var AResMsg: string): Boolean;
var
  PM: TPluginMessage;
begin
  Result := False;
  AResMsg := '';
  try
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Global.Plugin.AssignGamePluginId);
      PM.AddParams(CPP_INDEX, -1); //��ü ����
      PM.AddParams(CPP_PROD_DIV, CO_PROD_GAME);
      PM.AddParams(CPP_GAME_DIV, BaseGameDiv);
      PM.AddParams(CPP_PROD_DETAIL_DIV, '');
      PM.AddParams(CPP_GAME_DIV, BaseGameDiv);
      PM.AddParams(CPP_FEE_DIV, CO_GAMEFEE_BASIC); //�Ϲ�
      PM.AddParams(CPP_MEMBER_NO, '');
      PM.AddParams(CPP_MEMBERSHIP_YN, False);
      PM.AddParams(CPP_TODAY_YN, True);
      if not ShowProdPopup(PM, AResMsg) then
        if not AResMsg.IsEmpty then
          raise Exception.Create(AResMsg);
      Result := True;
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      AResMsg := E.Message;
  end;
end;
procedure TBPAssignGameForm.DoAssignGame;
var
  GA: TArray<TGameAssignRec>;
  LItemCount, LChargeAmt, LBowler: Integer;
  LReceiptNo, LResMsg: string;
begin
  if FWorking then
    Exit;
  FWorking := True;
  try
    LItemCount := FAssignList.Count;
    LChargeAmt := 0;
    if (LItemCount = 0) or
       not CheckAssignInfo then
      Exit;
    try
      SetLength(GA, 1);
      GA[0].LaneNo := BaseLaneNo;
      GA[0].GameDiv := BaseGameDiv;
      GA[0].RallySeq := 0;
      GA[0].LeagueMode := False;
      GA[0].ShiftMethod := CO_TABLE_SHIFT_GENERAL;
      GA[0].ShiftCount := 0;
      GA[0].PrepareMin := 0;
      SetLength(GA[0].Bowlers, LItemCount);
      for LBowler := 0 to Pred(LItemCount) do
        with TAssignControl(FAssignList.Objects[LBowler]) do
        begin
          GA[0].Bowlers[LBowler].ProdInfo.Clear;
          GA[0].Bowlers[LBowler].EntrySeq := 0;
          GA[0].Bowlers[LBowler].BowlerId := BowlerId;
          GA[0].Bowlers[LBowler].BowlerName := IfThen(BowlerName.IsEmpty, BowlerId, BowlerName);
          GA[0].Bowlers[LBowler].MemberNo := MemberNo;
          GA[0].Bowlers[LBowler].FeeDiv := FeeDiv;
          GA[0].Bowlers[LBowler].GameCount := GameCount;
          GA[0].Bowlers[LBowler].GameMin := IfThen(GameDiv = CO_RATEPLAN_TIME, GameMin, 0);
          GA[0].Bowlers[LBowler].MembershipSeq := MembershipSeq;
          GA[0].Bowlers[LBowler].MembershipUseCount := MembershipUseCount;
          GA[0].Bowlers[LBowler].MembershipUseMin := MembershipUseMin;
          GA[0].Bowlers[LBowler].ShoesRent := ShoesRent;
          GA[0].Bowlers[LBowler].ShoesFree := ShoesFree;
          GA[0].Bowlers[LBowler].PaymentType := IfThen(ChargeAmt = 0, CO_PAYTYPE_PREPAID, CO_PAYTYPE_DEFERRED);
          GA[0].Bowlers[LBowler].ProdInfo.ProdDiv := ProdDiv;
          GA[0].Bowlers[LBowler].ProdInfo.ProdDetailDiv := ProdDetailDiv;
          GA[0].Bowlers[LBowler].ProdInfo.ProdCode := ProdCode;
          GA[0].Bowlers[LBowler].ProdInfo.ProdName := ProdName;
          GA[0].Bowlers[LBowler].ProdInfo.ProdAmt := ProdAmt;
          GA[0].Bowlers[LBowler].ProdInfo.OrderQty := GameCount;
          LChargeAmt := (LChargeAmt + ChargeAmt);
          if ShoesRent and
             not ShoesFree then
            LChargeAmt := LChargeAmt + Global.StoreInfo.ShoesRentProdAmt;
        end;
      if (LChargeAmt > 0) and
         not BPDM.MakeNewReceipt(BaseLaneNo, LReceiptNo, LResMsg) then //var LReceiptNo
        raise Exception.Create(LResMsg);
      //if not BPDM.SetHoldLane(BaseLaneNo, True, LResMsg) then
        //raise Exception.Create(LResMsg);
      if not BPDM.AssignGame(False, LReceiptNo, GA, LResMsg) then
        raise Exception.Create(LResMsg);
      FNormalClosing := True;
      Self.ModalResult := mrOK;
    except
      on E: Exception do
        BPMsgBox(Self.Handle, mtError, '�˸�', '���� ������ �����Ͽ����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
    end;
  finally
    FWorking := False;
  end;
end;
procedure TBPAssignGameForm.DoEditGame;
var
  BI: TBowlerRec;
  LReceiptNo, LOldProdCode, LResMsg, LBowlerId: string;
  LItemCount: ShortInt;
  LOldGameCount, LOldGameMin: Integer;
  LExist, LOldShoesRent: Boolean;
begin
  if FWorking then
    Exit;
  FWorking := True;
  with FDataSet do
  try
    LItemCount := FAssignList.Count;
    if (LItemCount = 0) or
       not CheckAssignInfo then
      Exit;
    FDataSet.DisableControls;
    try
      for var I: ShortInt := 0 to Pred(LItemCount) do
        with TAssignControl(FAssignList.Objects[I]) do
        begin
          LReceiptNo := ReceiptNo;
          BI.EntrySeq := EntrySeq;
          BI.BowlerId := BowlerId;
          BI.BowlerName := IfThen(BowlerName.IsEmpty, BowlerId, BowlerName);
          BI.MemberNo := MemberNo;
          BI.FeeDiv := FeeDiv;
          BI.GameCount := GameCount;
          BI.GameMin := IfThen(GameDiv = CO_RATEPLAN_TIME, GameMin, 0);
          BI.MembershipSeq := MembershipSeq;
          BI.MembershipUseCount := MembershipUseCount;
          BI.MembershipUseMin := MembershipUseMin;
          BI.ShoesRent := ShoesRent;
          BI.ShoesFree := ShoesFree;
          BI.PaymentType := CO_PAYTYPE_DEFERRED;
          BI.ProdInfo.AssignLaneNo := AssignLaneNo;
          BI.ProdInfo.AssignNo := AssignNo;
          BI.ProdInfo.BowlerId := BowlerId;
          BI.ProdInfo.ProdDiv := ProdDiv;
          BI.ProdInfo.ProdDetailDiv := ProdDetailDiv;
          BI.ProdInfo.ProdCode := ProdCode;
          BI.ProdInfo.ProdName := ProdName;

          //chy test
          If (I > 0) and (GameDiv = CO_RATEPLAN_TIME) then
            BI.ProdInfo.ProdAmt := 0
          else
            BI.ProdInfo.ProdAmt := ProdAmt;

          BI.ProdInfo.OrderQty := GameCount;
          LExist := FDataSet.Locate('assign_no;bowler_id', VarArrayOf([AssignNo, BowlerId]), []);
          //Updatelog(Format('DoEditGame.Locate(%s) = AssignNo: %s, BowlerId: %s', [BoolToStr(LExist, True), AssignNo, BowlerId]));
          if LExist then
          begin
            LOldProdCode := FieldByName('prod_cd').AsString;
            LOldGameCount := FieldByName('game_cnt').AsInteger;
            LOldGameMin := FieldByName('game_min').AsInteger;
            LOldShoesRent := FieldByName('shoes_rent_yn').AsBoolean;
            if (BowlerName <> FieldByName('bowler_nm').AsString) or
               (MemberNo <> FieldByName('member_no').AsString) or
               (GameDiv <> FieldByName('game_div').AsInteger) or
               (FeeDiv <> FieldByName('fee_div').AsString) or
               (MembershipSeq <> FieldByName('membership_seq').AsInteger) or
               ((ProdDetailDiv = CO_PROD_DETAIL_GAME_COUNT) and (GameCount <> LOldGameCount)) or
               ((ProdDetailDiv = CO_PROD_DETAIL_GAME_MIN) and (GameMin <> LOldGameMin)) or
               (ShoesRent <> LOldShoesRent) then
            begin
              if not BPDM.ChangeBowler(LaneNo, AssignNo, BI, LResMsg) then
                raise Exception.Create(LResMsg);
              { ����� ��ǰ�� ���� �� �Ǵ� ���� �ð��� ����Ǿ��� ��� }
              if ((ProdDetailDiv = CO_PROD_DETAIL_GAME_COUNT) and (GameCount <> LOldGameCount)) or
                 ((ProdDetailDiv = CO_PROD_DETAIL_GAME_MIN) and (GameMin <> LOldGameMin)) then
              begin
                if (not BI.ProdInfo.ProdCode.IsEmpty) and
                   (not BPDM.UpdateSaleItem(LReceiptNo, BI.ProdInfo, LResMsg)) then
                  raise Exception.Create(LResMsg);
              end;
              { ����ȭ ��ȭ ���� ���� ������Ʈ }
              if (ShoesRent <> LOldShoesRent) then
              begin
                if ShoesRent and
                   not ShoesFree then
                begin
                  BI.ProdInfo.Clear;
                  BI.ProdInfo.AssignLaneNo := AssignLaneNo;
                  BI.ProdInfo.AssignNo := AssignNo;
                  BI.ProdInfo.BowlerId := BowlerId;
                  BI.ProdInfo.ProdDiv := CO_PROD_RENT;
                  BI.ProdInfo.ProdDetailDiv := Global.StoreInfo.ShoesRentProdDetailDiv;
                  BI.ProdInfo.ProdCode := Global.StoreInfo.ShoesRentProdCode;
                  BI.ProdInfo.ProdName := Global.StoreInfo.ShoesRentProdName;
                  BI.ProdInfo.ProdAmt := Global.StoreInfo.ShoesRentProdAmt;
                  BI.ProdInfo.OrderQty := 1;
                  if not BPDM.UpdateSaleItem(LReceiptNo, BI.ProdInfo, LResMsg) then
                    raise Exception.Create(LResMsg);
                end
                else
                begin
                  if not BPDM.DeleteABSRecord('TBSaleItem', Format('assign_no = %s AND bowler_id = %s AND prod_cd = %s',
                      [AssignNo.QuotedString, BowlerId.QuotedString, Global.StoreInfo.ShoesRentProdCode.QuotedString]), False, LResMsg) then
                    raise Exception.Create(LResMsg);
                end;
              end;
            end;
            { ����� ��ǰ �ڵ尡 ����Ǿ��� ��� }
            if (ProdCode <> LOldProdCode) then
            begin
              if not BPDM.DeleteABSRecord('TBSaleItem', Format('assign_no = %s AND bowler_id = %s AND prod_cd = %s',
                  [AssignNo.QuotedString, BowlerId.QuotedString, LOldProdCode.QuotedString]), False, LResMsg) then
                raise Exception.Create(LResMsg);
              if (not BI.ProdInfo.ProdCode.IsEmpty) and
                 (not BPDM.UpdateSaleItem(LReceiptNo, BI.ProdInfo, LResMsg)) then
                raise Exception.Create(LResMsg);
            end;
          end
          else
          begin
            { ���� �߰� }
            if not BPDM.AddBowler(LaneNo, AssignNo, BI, LResMsg, LBowlerId) then
              raise Exception.Create(LResMsg);
            BI.ProdInfo.BowlerId := LBowlerId;
            { �߰��� �̿� ��ǰ ������Ʈ }
            if (not BI.ProdInfo.ProdCode.IsEmpty) and
               (not BPDM.UpdateSaleItem(LReceiptNo, BI.ProdInfo, LResMsg)) then
              raise Exception.Create(LResMsg);
            { ����ȭ ��ȭ ���� ���� ������Ʈ }
            if ShoesRent and
               not ShoesFree then
            begin
              BI.ProdInfo.Clear;
              BI.ProdInfo.AssignLaneNo := AssignLaneNo;
              BI.ProdInfo.AssignNo := AssignNo;
              //BI.ProdInfo.BowlerId := BowlerId;
              BI.ProdInfo.BowlerId := LBowlerId;
              BI.ProdInfo.ProdDiv := CO_PROD_RENT;
              BI.ProdInfo.ProdDetailDiv := Global.StoreInfo.ShoesRentProdDetailDiv;
              BI.ProdInfo.ProdCode := Global.StoreInfo.ShoesRentProdCode;
              BI.ProdInfo.ProdName := Global.StoreInfo.ShoesRentProdName;
              BI.ProdInfo.ProdAmt := Global.StoreInfo.ShoesRentProdAmt;
              BI.ProdInfo.OrderQty := 1;
              if not BPDM.UpdateSaleItem(LReceiptNo, BI.ProdInfo, LResMsg) then
                raise Exception.Create(LResMsg);
            end;
          end;
          { ������ ������ ������Ʈ }
          if not BPDM.UpdateReceipt(LReceiptNo, LResMsg) then
            raise Exception.Create(LResMsg);
        end;
      FNormalClosing := True;
      Self.ModalResult := mrOK;
    except
      on E: Exception do
        BPMsgBox(Self.Handle, mtError, '�˸�', '���� ������ �����Ͽ����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
    end;
  finally
    FDataSet.EnableControls;
    FWorking := False;
  end;
end;
procedure TBPAssignGameForm.DoRemoveBowler(const AItemIndex: ShortInt);
var
  LAssignedGame: Boolean;
  LAssignNo, LBowlerId, LBowlerName, LResMsg: string;
  bDelete: Boolean;
  nGameToCnt, nGameProgress, nFrame: Integer;
begin
  if (BaseLaneStatus = 5) then
    Exit;
  if (AItemIndex < 0) then
    Exit;
  try
    with TAssignControl(FAssignList.Objects[AItemIndex]) do
    begin
      LAssignedGame := AssignedGame;
      LAssignNo := AssignNo;
      LBowlerId := BowlerId;
      LBowlerName := BowlerName;
      nGameToCnt := GameToCnt;
      nGameProgress := GameProgress;

      if LBowlerName.IsEmpty then
        LBowlerName := LBowlerId
      else if (LBowlerId <> LBowlerName) then
        LBowlerName := Format('%s-%s', [LBowlerId, LBowlerName]);
    end;

    bDelete := True;

    if LAssignedGame and
       EditMode then
    begin

      //chy test - ���� �Ϸ� ������ �ɼ� �� ���� �ʿ�
      nFrame := (4 - 1) * 2;
      if (nGameProgress > 0) or (nGameToCnt > nFrame) then
        bDelete := False;

      if bDelete = true then
      begin
        if (BPMsgBox(Self.Handle, mtConfirmation, '���� ����', ErrorString(LBowlerName) + ' ������ ���� �� �ֹ� ������ ��� �����˴ϴ�.' + _BR +
              '���� ������ �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
          Exit;
        if not BPDM.RemoveBowler(LAssignNo, LBowlerId, LResMsg) then
          raise Exception.Create(LResMsg);
        if not BPDM.DeleteABSRecord('TBSaleItem', Format('assign_no = %s AND bowler_id = %s', [LAssignNo.QuotedString, LBowlerId.QuotedString]), True, LResMsg) then
          raise Exception.Create(LResMsg);
        SendToMainForm(CPC_GAME_REFRESH_FORCE);
      end
      else
      begin
        if (BPMsgBox(Self.Handle, mtConfirmation, '���� ����',
              ErrorString(LBowlerName) + ' ������ �Ͻ� ������ �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOk) then
          Exit;
        if not BPDM.SetBowlerPause(LAssignNo, LBowlerId, True, LResMsg) then
          raise Exception.Create(LResMsg);
        SendToMainForm(CPC_GAME_REFRESH_FORCE);
      end;
    end;

    if bDelete = True then
    begin
      try
        TAssignControl(FAssignList.Objects[AItemIndex]).Free;
        if (FAssignList.Count > 0) then
          for var I: ShortInt := AItemIndex to (FAssignList.Count - 2) do
          begin
            FAssignList.Objects[I] := FAssignList.Objects[I + 1];
            TAssignControl(FAssignList.Objects[I]).ItemIndex := I;
          end;
        FAssignList.Delete(Pred(FAssignList.Count));
        FBowlerCount := FAssignList.Count;
        edtBowlerCount.Value := FAssignList.Count;
      finally
        btnDoAssign.Enabled := (FAssignList.Count > 0);
      end;
    end;

    if LAssignedGame and
       EditMode then
    begin
      if bDelete = true then
        BPMsgBox(Self.Handle, mtInformation, '�˸�', Format('%s ������ �����Ǿ����ϴ�.', [LBowlerName]), ['Ȯ��'], 5)
      else
        BPMsgBox(Self.Handle, mtInformation, '�˸�', Format('%s ������ ��� ������ �Ϸ��Ͽ����ϴ�.', [LBowlerName]), ['Ȯ��'], 5);
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '�˸�', '���� ������ �����Ͽ����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;
procedure TBPAssignGameForm.DoResetProdInfo(const AItemIndex: ShortInt);
begin
  if (AItemIndex < 0) then
    Exit;
  with TAssignControl(FAssignList.Objects[AItemIndex]) do
  begin
    FeeDiv := BaseFeeDiv;
    ProdDiv := BaseProdDiv;
    ProdDetailDiv := BaseProdDetailDiv;
    ProdCode := BaseProdCode;
    ProdName := BaseProdName;
    ProdAmt := BaseProdAmt;
  end;
end;
procedure TBPAssignGameForm.edtBaseProdNameClick(Sender: TObject);
begin
  btnBaseProdPopup.Click;
end;
procedure TBPAssignGameForm.SetBaseLaneNo(const AValue: ShortInt);
begin
  if (FBaseLaneNo <> AValue) then
  try
    FBaseLaneNo := AValue;
    panAssignInfo.Visible := (FBaseLaneNo > 0);
    panAssignList.Visible := (FBaseLaneNo > 0);
    for var I: ShortInt := 0 to High(FLaneNoPanels) do
      FLaneNoPanels[I].Color := IfThen(FLaneNoPanels[I].LaneNo = FBaseLaneNo, CO_COLOR_LANE_NO_SELECT, CO_COLOR_LANE_NO_NORMAL);
  finally
    ResetBowlerId;
  end;
end;
procedure TBPAssignGameForm.SetCanReserve(const AValue: Boolean);
begin
  if (FCanReserve <> AValue) then
  begin
    FCanReserve := AValue;
    rdgBaseGameDiv.Enabled := (not FCanReserve);
    btnDoReserve.Enabled := FCanReserve and (not FReserveMode);
  end;
end;
procedure TBPAssignGameForm.SetBowlerCount(const AValue: ShortInt);
var
  LOldCount: Integer;
  LIndex: ShortInt;
begin
  if (BaseLaneStatus = 5) then
    Exit;
  if (FBowlerCount <> AValue) then
  begin
    LOldCount := FBowlerCount;
    FBowlerCount := AValue;
    edtBowlerCount.Value := FBowlerCount;
    if (FBowlerCount > LOldCount) then
    begin
      for var I: ShortInt := LOldCount to Pred(FBowlerCount) do
      begin
        LIndex := FAssignList.AddObject(LIndex.ToString, TAssignControl.Create(nil, I, sbxAssignList));
        with TAssignControl(FAssignList.Objects[LIndex]) do
        begin
          LaneNo := BaseLaneNo;
          AssignLaneNo := BaseLaneNo;
          AssignNo := BaseAssignNo;
          ReceiptNo := FEditRecceiptNo;
          GameDiv := BaseGameDiv;
          FeeDiv := BaseFeeDiv;
          BaseGameCount := BaseGameCount;
          BaseGameMin := BaseGameMin;
          //GameCount := BaseGameCount;
          GameMin := BaseGameMin;
          MembershipSeq := 0;
          MembershipUseCount := 0;
          MembershipUseMin := 0;
          ProdDiv := BaseProdDiv;
          ProdDetailDiv := BaseProdDetailDiv;
          ProdCode := BaseProdCode;
          ProdName := BaseProdName;
          ProdAmt := BaseProdAmt;
          ShoesRent := True;
          ShoesFree := False;

          if (GameDiv = CO_RATEPLAN_GAME) and (FeeDiv = CO_GAMEFEE_BASIC) and (ProdCode <> Global.StoreInfo.DefaultGameProdCode) then
          begin
            GameCount := BaseProdGameCnt;
            ButtonGameCountDec.Enabled := False;
            ButtonGameCountInc.Enabled := False;
          end

          //chy test
          else if (GameDiv = CO_RATEPLAN_TIME) then
          begin
            GameCount := BaseGameCount;
            GameMin := (GameCount * FBaseGameMin);
            ButtonGameCountDec.Enabled := False;
            ButtonGameCountInc.Enabled := False;
          end

          else
            GameCount := BaseGameCount;
        end;
      end;
    end
    else
      for var I: ShortInt := Pred(LOldCount) downto FBowlerCount do
      begin
        DoRemoveBowler(I);
        if BaseGameDiv = CO_RATEPLAN_GAME then
          SendMessage(Global.Plugin.AssignGamePluginId, LWM_TOTAL_COUNT, 0, 0);
        //SendMessage(Global.Plugin.AssignGamePluginId, LWM_TOTAL_MIN, 0, 0);
        SendMessage(Global.Plugin.AssignGamePluginId, LWM_TOTAL_AMT, 0, 0);
      end;
    ResetBowlerId;
    SendMessage(Global.Plugin.AssignGamePluginId, LWM_REFRESH_LANES, 0, 0);
    panAssignInfo.Visible := (FAssignList.Count > 0);
    panAssignList.Visible := (FAssignList.Count > 0);
    btnDoAssign.Enabled := (FAssignList.Count > 0);
  end;
end;
procedure TBPAssignGameForm.SetBaseGameCount(const AValue: Integer);
begin
  if (FBaseGameCount <> AValue) then
  begin
    FBaseGameCount := AValue;
    edtBaseGameCount.Value := FBaseGameCount;
    for var I: ShortInt := 0 to Pred(FAssignList.Count) do
      with TAssignControl(FAssignList.Objects[I]) do
      begin
        if (GameDiv = CO_RATEPLAN_GAME) and (FeeDiv = CO_GAMEFEE_BASIC) and (ProdCode <> Global.StoreInfo.DefaultGameProdCode) then
          Continue;

        if (MembershipSeq > 0) and
           (MembershipRemainCount >= FBaseGameCount) then
        begin
          MembershipUseCount := FBaseGameCount;
          MembershipName := FMembershipName;
        end;
        BuyGameCount := (FBaseGameCount - MembershipUseCount);

        //chy test
        if (GameDiv = CO_RATEPLAN_TIME) then
        begin
          if (MembershipSeq > 0) and
             (MembershipRemainMin >= (BuyGameCount * FBaseGameMin)) then
          begin
            MembershipUseMin := BuyGameCount * FBaseGameMin;
            MembershipName := FMembershipName;
          end;
          BuyGameMin := ((BuyGameCount * FBaseGameMin) - MembershipUseMin);
        end;
      end;

    //chy test
    if (BaseGameDiv = CO_RATEPLAN_TIME) then
      SendMessage(Global.Plugin.AssignGamePluginId, LWM_TOTAL_AMT, 0, 0);
  end;
end;
procedure TBPAssignGameForm.SetBaseGameMin(const AValue: Integer);
begin
  if (FBaseGameMin <> AValue) then
  begin
    FBaseGameMin := AValue;
    edtBaseGameMin.Value := FBaseGameMin;
    for var I: ShortInt := 0 to Pred(FAssignList.Count) do
      with TAssignControl(FAssignList.Objects[I]) do
      begin
        if (MembershipSeq > 0) and
           (MembershipRemainMin >= FBaseGameMin) then
        begin
          MembershipUseMin := FBaseGameMin;
          MembershipName := FMembershipName;
        end;
        BuyGameMin := (FBaseGameMin - MembershipUseMin);
      end;
  end;
end;
procedure TBPAssignGameForm.SetBaseProdCode(const AValue: string);
begin
  if (FBaseProdCode <> AValue) then
    FBaseProdCode := AValue;
end;
procedure TBPAssignGameForm.SetBaseProdName(const AValue: string);
begin
  if (FBaseProdName <> AValue) then
  begin
    FBaseProdName := AValue;
    edtBaseProdName.Text := AValue;
  end;
end;
procedure TBPAssignGameForm.SetBaseProdAmt(const AValue: Integer);
begin
  if (FBaseProdAmt <> AValue) then
  begin
    FBaseProdAmt := AValue;
    edtBaseProdAmt.Value := AValue;
  end;
end;
procedure TBPAssignGameForm.SetBaseGameDiv(const AValue: ShortInt);
begin
  if (FBaseGameDiv <> AValue) then
  begin
    FBaseGameDiv := AValue;
    rdgBaseGameDiv.ItemIndex := (FBaseGameDiv - 1);
    BaseFeeDiv := '';
    BaseProdDiv := '';
    BaseProdDetailDiv := '';
    BaseProdCode := '';
    BaseProdName := '';
    BaseProdAmt := 0;
    if (FBaseGameDiv = CO_RATEPLAN_TIME) then
    begin
      BaseGameCount := 1;
      BaseGameMin := 60;
      lblBaseGameCount.Caption := '�̿� ��ǰ ��';
      lblGameCountTitle.Caption := '�̿� ��ǰ ��';
      edtUseGameCountTotal.ControlLabel.Caption := '�հ� ��  �̿� ��ǰ ��';
    end
    else if (FBaseGameDiv = CO_RATEPLAN_GAME) then
    begin
      BaseGameMin := 0;
      lblBaseGameCount.Caption := '�̿� ���� ��';
      lblGameCountTitle.Caption := '�̿� ���� ��';
      edtUseGameCountTotal.ControlLabel.Caption := '�հ� ��  �̿� ���� ��';
    end;
    for var I: ShortInt := 0 to Pred(FAssignList.Count) do
      with TAssignControl(FAssignList.Objects[I]) do
      begin
        GameDiv := FBaseGameDiv;
        MemberNo := '';
        MembershipSeq := 0;
        MembershipName := '';
        MembershipUseCount := 0;
        MembershipUseMin := 0;
        ShoesFree := False;
        GameCount := BaseGameCount;
        GameMin := BaseGameMin;

        ButtonGameCountDec.Enabled := (FBaseGameDiv = CO_RATEPLAN_GAME);
        ButtonGameCountInc.Enabled := (FBaseGameDiv = CO_RATEPLAN_GAME);
      end;
//    btnBaseGameCountDec.Enabled := (FBaseGameDiv = CO_RATEPLAN_GAME);
//    btnBaseGameCountInc.Enabled := (FBaseGameDiv = CO_RATEPLAN_GAME);
//    edtBaseGameCount.Enabled := (FBaseGameDiv = CO_RATEPLAN_GAME);
    btnBaseGameMinDec.Enabled := (FBaseGameDiv = CO_RATEPLAN_TIME);
    btnBaseGameMinInc.Enabled := (FBaseGameDiv = CO_RATEPLAN_TIME);
    edtBaseGameMin.Enabled := (FBaseGameDiv = CO_RATEPLAN_TIME);
  end;
end;
procedure TBPAssignGameForm.SetGameCountTotal(const AValue: integer);
begin
  if (FGameCountTotal <> AValue) then
  begin
    FGameCountTotal := AValue;
    edtUseGameCountTotal.Value := FGameCountTotal;

    btnCheckOut.Enabled := False;
  end;
end;
procedure TBPAssignGameForm.SetGameMinTotal(const AValue: integer);
begin
  if (FGameMinTotal <> AValue) then
  begin
    FGameMinTotal := AValue;
    edtUseGameMinTotal.Value := FGameMinTotal;

    btnCheckOut.Enabled := False;
  end;
end;
procedure TBPAssignGameForm.SetTitle(const AValue: string);
begin
  FTitle := AValue;
  if (BaseLaneNo = 0) then
    panHeader.Caption := FTitle
  else
    panHeader.Caption := Format('%s �� %d ����', [FTitle, BaseLaneNo]);

  if Pos('����', FTitle) > 0 then
    panHeader.Color := $001A9DF4;

end;
procedure TBPAssignGameForm.SetChargeAmtTotal(const AValue: Integer);
begin
  if (FChargeAmtTotal <> AValue) then
  begin
    FChargeAmtTotal := AValue;
    edtChargeAmtTotal.Value := FChargeAmtTotal;

    btnCheckOut.Enabled := False;
  end;
end;
{ TAssignControl }
constructor TAssignControl.Create(AOwner: TComponent; const AItemIndex: ShortInt; const AParent: TWinControl);
begin
  inherited Create(AOwner);
  FItemIndex := AItemIndex;
  FAssignedGame := False;
  FLaneNo := 0;
  FBuyGameCount := 0;
  FBuyGameMin := 0;
  FGameCount := 0;
  FGameMin := 0;
  FGameProgress := 0;
  FGameDiv := 0;
  FAssignNo := '';
  FReceiptNo := '';
  FEntrySeq := 0;
  FBowlerId := '';
  FMemberNo := '';
  FMemberName := '';
  FFeeDiv := '';
  FMembershipSeq := 0;
  FMembershipName := '';
  FMembershipUseCount := 0;
  FMembershipUseMin := 0;
  FMembershipRemainCount := 0;
  FMembershipRemainMin := 0;
  FProdDiv := '';
  FProdDetailDiv := '';
  FProdCode := '';
  FProdName := '';
  FProdAmt:= 0;
  FShoesRent := False;
  FShoesFree := False;
  FChargeAmt := 0;
  FEnableBuy := True;
  Align := alTop;
  AlignWithMargins := True;
  AutoSize := False;
  Caption := '';
  Font.Name := 'Pretendard Variable';
  Font.Size := 11;
  Height := 50;
  Margins.Bottom := 0;
  Margins.Left := 5;
  Margins.Right := 5;
  Margins.Top := 5;
  ParentFont := False;
  TabOrder := AItemIndex;
  Tag := 0;
  Top := 30 + (50 * AItemIndex);
  Width := 743;
  Parent := AParent;
  OnClick := OnControlEnter; //OnEnter Event�� �۵����� �����Ƿ� OnClick Event�� ����
  AssignedPanel := TPanel.Create(Self);
  with AssignedPanel do
  begin
    Align := alLeft;
    BevelOuter := bvNone;
    Color := CO_COLOR_LANE_BUSY;
    Height := 48;
    Parent := Self;
    ParentBackground := False;
    StyleElements := [];
    TabOrder := 0;
    Visible := False;
    Width := 5;
  end;
  DragReorderImage := TImage.Create(Self);
  with DragReorderImage do
  begin
    Center := True;
    Cursor := crHandPoint;
    Height := 32;
    HelpKeyword := LC_ID_DRAG_DROP; //Drag & Drop �ĺ���
    Hint := '���� ��ܼ� ���� ����';
    Left := 12;
    Parent := Self;
    Picture.Assign(BPDM.imcIcons.GetBitmap(62, 32, 32));
    ShowHint := True;
    Tag := AItemIndex;
    Top := 8;
    Transparent := True;
    Width := 32;
    OnMouseDown := OnAssignMouseDown;
    OnDragOver := OnAssignDragOver;
    OnDragDrop := OnAssignDragDrop;
  end;
  LabelBowlerId := TLabel.Create(Self);
  with LabelBowlerId do
  begin
    //Alignment := taCenter;
    Alignment := taRightJustify;
    AutoSize := False;
    Caption := '';
    Height := 27;
    Layout := tlCenter;
    Left := 48;
    Parent := Self;
    Top := 11;
    Width := 38;
  end;
  EditBowlerName := TDBEditEh.Create(Self);
  with EditBowlerName do
  begin
    AutoSize := False;
    Height := 27;
    ImeMode := Vcl.Controls.TImeMode.imSHanguel;
    Left := 90;
    Parent := Self;
    ShowHint := True;
    TabOrder := 0;
    Text := '';
    Top := 11;
    Width := 90;
    OnEnter := OnControlEnter;
  end;
  EditMembershipName := TDBEditEh.Create(Self);
  with EditMembershipName do
  begin
    AutoSize := False;
    Height := 27;
    ImeMode := Vcl.Controls.TImeMode.imSHanguel;
    Left := 183;
    Parent := Self;
    ReadOnly := True;
    ShowHint := True;
    TabOrder := 1;
    TabStop := False;
    Text := '';
    Top := 11;
    Width := 110;
    OnEnter := OnControlEnter;
  end;
  ButtonMemberPopup := TBitBtn.Create(Self);
  with ButtonMemberPopup do
  begin
    Caption := '';
    Height := 29;
    Hint := 'ȸ�� ����';
    Images := BPDM.imlIcon16;
    ImageIndex := 3;
    Left := 295;
    Parent := Self;
    ShowHint := True;
    TabOrder := 2;
    Top := 10;
    Width := 30;
    OnClick := OnButtonMemberPopupClick;
 end;
  ButtonMemberClear := TBitBtn.Create(Self);
  with ButtonMemberClear do
  begin
    Caption := '';
    Height := 29;
    Hint := 'ȸ�� ���� ���';
    Images := BPDM.imlIcon16;
    ImageIndex := 5;
    Left := 326;
    Parent := Self;
    ShowHint := True;
    TabOrder := 3;
    Top := 10;
    Width := 30;
    OnClick := OnButtonMemberClearClick;
  end;
  EditProdName := TDBEditEh.Create(Self);
  with EditProdName do
  begin
    AutoSize := False;
    EmptyDataInfo.Text := '����� ����';
    Height := 27;
    Left := 364;
    Parent := Self;
    ReadOnly := True;
    ShowHint := True;
    TabOrder := 4;
    TabStop := False;
    Text := '';
    Top := 11;
    Width := 110;
    OnEnter := OnControlEnter;
  end;
  ButtonProdPopup := TBitBtn.Create(Self);
  with ButtonProdPopup do
  begin
    Caption := '';
    Height := 29;
    Hint := '����� ����';
    Images := BPDM.imlIcon16;
    ImageIndex := 4;
    Left := 476;
    Parent := Self;
    ShowHint := True;
    TabOrder := 5;
    Top := 10;
    Width := 30;
    OnClick := OnButtonProdPopupClick;
  end;
  ButtonProdClear := TBitBtn.Create(Self);
  with ButtonProdClear do
  begin
    Caption := '';
    Height := 29;
    Hint := '����� ���� ���';
    Images := BPDM.imlIcon16;
    ImageIndex := 5;
    Left := 507;
    Parent := Self;
    ShowHint := True;
    TabOrder := 6;
    Top := 10;
    Width := 30;
    OnClick := OnButtonProdClearClick;
  end;
  ButtonGameCountDec := TButton.Create(Self);
  with ButtonGameCountDec do
  begin
    AutoSize := False;
    Caption := '��';
    Font.Name := 'Pretendard Variable';
    Font.Size := 11;
    Font.Style := [fsBold];
    Height := 29;
    Left := 544;
    Parent := Self;
    ParentFont := False;
    TabOrder := 7;
    Top := 10;
    Width := 30;
    OnClick := OnGameCountDecClick;
  end;
  EditGameCount := TNumberBox.Create(Self);
  with EditGameCount do
  begin
    Alignment := taCenter;
    AutoSize := False;
    Height := 27;
    Left := 575;
    Parent := Self;
    ReadOnly := True;
    TabOrder := 8;
    TabStop := False;
    Top := 11;
    Value := FGameCount;
    Width := 40;
    OnEnter := OnControlEnter;
  end;
  ButtonGameCountInc := TButton.Create(Self);
  with ButtonGameCountInc do
  begin
    Caption := '��';
    Font.Name := 'Pretendard Variable';
    Font.Size := 11;
    Font.Style := [fsBold];
    Height := 29;
    Left := 616;
    Parent := Self;
    ParentFont := False;
    TabOrder := 9;
    Top := 10;
    Width := 30;
    OnClick := OnGameCountIncClick;
  end;
  LabelGameProgress := TLabel.Create(Self);
  with LabelGameProgress do
  begin
    Alignment := taCenter;
    AutoSize := False;
    Caption := '0';
    Height := 27;
    Layout := tlCenter;
    Left := 650;
    Parent := Self;
    Top := 11;
    Width := 38;
  end;
  EditGameMin := TDBNumberEditEh.Create(Self);
  with EditGameMin do
  begin
    Alignment := taCenter;
    AutoSize := False;
    DisplayFormat := ',0 ��';
    Enabled := False;
    Height := 27;
    Left := 692;
    Parent := Self;
    ReadOnly := True;
    TabOrder := 10;
    TabStop := False;
    Top := 11;
    Value := FGameMin;
    Width := 60;
    OnEnter := OnControlEnter;
  end;
  CheckBoxShoesRent := TCheckBox.Create(Self);
  with CheckBoxShoesRent do
  begin
    Caption := '�뿩';
    Checked := False;
    Height := 17;
    Left := 765;
    Parent := Self;
    TabOrder := 11;
    Top := 16;
    Width := 48;
    OnClick := OnCheckBoxShoesRentClick;
  end;
  CheckBoxShoesFree := TCheckBox.Create(Self);
  with CheckBoxShoesFree do
  begin
    Caption := '����';
    Checked := False;
    Enabled := False;
    Height := 17;
    Left := 815;
    Parent := Self;
    TabOrder := 12;
    Top := 16;
    Width := 48;
  end;
  EditChargeAmt := TDBNumberEditEh.Create(Self);
  with EditChargeAmt do
  begin
    Alignment := taRightJustify;
    DecimalPlaces := 0;
    DisplayFormat := ',0 ��';
    Height := 27;
    Left := 870;
    Parent := Self;
    ReadOnly := True;
    TabOrder := 13;
    TabStop := False;
    Top := 11;
    Value := 0;
    Width := 100;
    OnEnter := OnControlEnter;
  end;
  ButtonRemoveBowler := TBitBtn.Create(Self);
  with ButtonRemoveBowler do
  begin
    Caption := '';
    Height := 29;
    Hint := '���� ����';
    Images := BPDM.imlIcon16;
    ImageIndex := 5;
    Left := 978;
    Parent := Self;
    ShowHint := True;
    TabOrder := 14;
    Top := 10;
    Width := 30;
    OnClick := OnButtonRemoveBowlerClick;
  end;
end;
destructor TAssignControl.Destroy;
begin
  DragReorderImage.Free;
  LabelBowlerId.Free;
  EditBowlerName.Free;
  EditMembershipName.Free;
  ButtonMemberPopup.Free;
  ButtonMemberClear.Free;
  EditProdName.Free;
  ButtonProdPopup.Free;
  ButtonProdClear.Free;
  EditGameCount.Free;
  ButtonGameCountDec.Free;
  ButtonGameCountInc.Free;
  LabelGameProgress.Free;
  EditGameMin.Free;
  CheckBoxShoesRent.Free;
  CheckBoxShoesFree.Free;
  EditChargeAmt.Free;
  ButtonRemoveBowler.Free;
  inherited;
end;
procedure TAssignControl.OnAssignMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  with TImage(Sender) do
    if (Button = mbLeft) then
      BeginDrag(False);
end;
procedure TAssignControl.OnAssignDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TImage) and
            (Sender is TImage) and
            (TImage(Source).Tag <> TImage(Sender).Tag) and
            (TAssignControl(FAssignList.Objects[TImage(Source).Tag]).AssignedGame = TAssignControl(FAssignList.Objects[TImage(Sender).Tag]).AssignedGame);
end;
procedure TAssignControl.OnAssignDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  LSource, LSender, LIndex, I: ShortInt;
  LAssignNo, LBowlerId, LBowlerName, LResMsg: string;
begin
  LSource := TImage(Source).Tag;
  LSender := TImage(Sender).Tag;
  with TAssignControl(FAssignList.Objects[LSource]) do
  begin
    LAssignNo := AssignNo;
    LBowlerName := BowlerName;
    LBowlerId := BowlerId;
    if LBowlerName.IsEmpty then
      LBowlerName := LBowlerId
    else if (LBowlerId <> LBowlerName) then
      LBowlerName := Format('%s-%s', [LBowlerId, LBowlerName]);
  end;
  if (Source <> Sender) and
     ((not AssignedGame) or
      (BPMsgBox(Self.Handle, mtConfirmation, '���� ���� ����', ErrorString(LBowlerName) + ' ������ ' +
          ErrorString(Succ(LSender).ToString) + ' ��° ������ �����Ͻðڽ��ϱ�?' + _BR + '����� ������ ������ ���ӿ� ��� ����˴ϴ�.', ['��', '�ƴϿ�']) = mrOK)) then
  begin
    //ShowMessage(Format('Source: %d -> Sender: %d', [LSource, LSender]));
    FAssignList.BeginUpdate;
    try
      try
        if AssignedGame then
        begin
          if not BPDM.SetBowlerThrowOrder(LAssignNo, LBowlerId, LSender + 1, LResMsg) then
            raise Exception.Create(LResMsg);
          BPMsgBox(Self.Handle, mtInformation, '�˸�', Format('%s ������ ������ ����Ǿ����ϴ�.', [LBowlerName]), ['Ȯ��'], 5);
          SendToMainForm(CPC_GAME_REFRESH_FORCE);
        end;
        if (LSource > LSender) then
        begin
          TAssignControl(FAssignList.Objects[LSource]).Top := TAssignControl(FAssignList.Objects[LSender]).Top - 10;
          TAssignControl(FAssignList.Objects[LSource]).ItemIndex := LSender;
          FAssignList[LSource] := LSender.ToString;
          LIndex := LSender;
          for I := LSender to Pred(FAssignList.Count) do
            if (I <> LSource) then
            begin
              Inc(LIndex);
              TAssignControl(FAssignList.Objects[I]).ItemIndex := LIndex;
              FAssignList[I] := LIndex.ToString;
            end;
        end
        else
        begin
          TAssignControl(FAssignList.Objects[LSource]).Top := TAssignControl(FAssignList.Objects[LSender]).Top + 10;
          TAssignControl(FAssignList.Objects[LSource]).ItemIndex := LSender;
          FAssignList[LSource] := LSender.ToString;
          for I := Succ(LSource) to LSender do
          begin
            LIndex := TAssignControl(FAssignList.Objects[I]).ItemIndex - 1;
            TAssignControl(FAssignList.Objects[I]).ItemIndex := LIndex;
            FAssignList[I] := LIndex.ToString;
          end;
        end;
      finally
        FAssignList.CustomSort(StringListSortAsc);
        FAssignList.EndUpdate;
      end;
    except
      on E: Exception do
        BPMsgBox(Self.Handle, mtError, '�˸�', '���� ������ ������ �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
    end;
  end;
end;
procedure TAssignControl.OnButtonMemberPopupClick(Sender: TObject);
var
  PM: TPluginMessage;
  LResMsg: string;
begin
  FAssignIndex := ItemIndex;
  try
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Global.Plugin.AssignGamePluginId);
      PM.AddParams(CPP_GAME_DIV, GameDiv);
      PM.AddParams(CPP_PROD_DIV, CO_PROD_GAME);
      PM.AddParams(CPP_DATA_MODE, CO_DATA_MODE_SELECT);
      PM.AddParams(CPP_SEARCH_TYPE, CO_SEARCH_NONE);
      if (ShowMemberPopup(PM, LResMsg) = mrOK) and
         not LResMsg.IsEmpty then
        raise Exception.Create(LResMsg);
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '�˸�', 'ȸ�� ����� �ҷ��� �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;
procedure TAssignControl.OnButtonMemberClearClick(Sender: TObject);
begin
  FAssignIndex := ItemIndex;
  if (MembershipSeq > 0) or
     not MemberNo.IsEmpty then
  begin
    MemberNo := '';
    MemberName := '';
    BowlerName := '';
    MembershipSeq := 0;
    MembershipUseCount := 0;
    MembershipUseMin := 0;
    MembershipRemainCount := 0;
    MembershipRemainMin := 0;
    MembershipName := '';
    ShoesFree := False;
    EnableBuy := True;
  end;
end;
procedure TAssignControl.OnButtonProdPopupClick(Sender: TObject);
var
  PM: TPluginMessage;
  LResMsg: string;
begin
  if not EnableBuy then
    Exit;
  FAssignIndex := ItemIndex;
  try
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Global.Plugin.AssignGamePluginId);
      PM.AddParams(CPP_INDEX, ItemIndex); //���� ����
      PM.AddParams(CPP_PROD_DIV, CO_PROD_GAME);
      PM.AddParams(CPP_PROD_DETAIL_DIV, '');
      PM.AddParams(CPP_GAME_DIV, GameDiv);
      PM.AddParams(CPP_FEE_DIV, CO_GAMEFEE_BASIC); //�Ϲ�
      PM.AddParams(CPP_MEMBER_NO, MemberNo);
      PM.AddParams(CPP_MEMBERSHIP_YN, False);
      PM.AddParams(CPP_TODAY_YN, True);
      if not ShowProdPopup(PM, LResMsg) then
        if not LResMsg.IsEmpty then
          raise Exception.Create(LResMsg);
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '�˸�', '��ǰ ����� �ҷ��� �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;
procedure TAssignControl.OnButtonProdClearClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  FAssignIndex := ItemIndex;
  if not ProdCode.IsEmpty then
  begin
    {
    ProdCode := '';
    if (MembershipSeq = 0) then
      ShoesFree := False;
    }
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_SEL_PROD_GAME_DEFAULT;
      PM.AddParams(CPP_INDEX, ItemIndex); //���� ���� ȭ�鿡�� �⺻���� ��ǰ�� ������ ��ǰ�� �����ϱ� ���� ���
      PM.PluginMessageToId(Global.Plugin.AssignGamePluginId);
    finally
      FreeAndNil(PM);
    end;
  end;
end;
procedure TAssignControl.OnGameCountDecClick(Sender: TObject);
begin
  FAssignIndex := ItemIndex;
  if (GameCount > 1) and (GameCount > FGameProgress) then
    GameCount := (GameCount - 1);
end;
procedure TAssignControl.OnGameCountIncClick(Sender: TObject);
begin
  FAssignIndex := ItemIndex;
  if (GameCount < LC_LIMIT_GAME_COUNT) then
    GameCount := (GameCount + 1);
end;
procedure TAssignControl.OnCheckBoxShoesRentClick(Sender: TObject);
begin
  FAssignIndex := ItemIndex;
  ShoesRent := TCheckBox(Sender).Checked;
end;
procedure TAssignControl.OnButtonRemoveBowlerClick(Sender: TObject);
begin
  PostMessage(Global.Plugin.AssignGamePluginId, LWM_REMOVE_BOWLER, ItemIndex, 0);
end;
procedure TAssignControl.OnControlEnter(Sender: TObject);
begin
  FAssignIndex := ItemIndex;
end;
procedure TAssignControl.SetLaneNo(const AValue: ShortInt);
begin
  if (FLaneNo <> AValue) then
    FLaneNo := AValue;
end;
procedure TAssignControl.SetAssignedGame(const AValue: Boolean);
begin
  if (FAssignedGame <> AValue) then
  begin
    FAssignedGame := AValue;
    AssignedPanel.Visible := FAssignedGame;
    ButtonMemberPopup.Enabled := not FAssignedGame;
    ButtonMemberClear.Enabled := not FAssignedGame;
  end;
end;
procedure TAssignControl.SetBowlerId(const AValue: string);
begin
  FBowlerId := AValue;
  LabelBowlerId.Caption := FBowlerId;
  EditBowlerName.EmptyDataInfo.Text := FBowlerId;
end;
function TAssignControl.GetBowlerName: string;
begin
  Result := EditBowlerName.Text;
end;
procedure TAssignControl.SetBowlerName(const AValue: string);
begin
  EditBowlerName.Text := AValue;
  EditBowlerName.Hint := AValue;
end;
procedure TAssignControl.SetGameCount(const AValue: Integer);
begin
  if (FGameCount <> AValue) then
  begin
    FGameCount := AValue;
    if (MembershipSeq > 0) then
    begin
      if (MembershipRemainCount < FGameCount) then
      begin
        MembershipUseCount := MembershipRemainCount;
        BuyGameCount := (FGameCount - MembershipRemainCount);
      end
      else
      begin
        MembershipUseCount := FGameCount;
        BuyGameCount := 0;
      end;
    end
    else
    begin
      MembershipUseCount := 0;
      BuyGameCount := FGameCount;
    end;
    EditGameCount.Value := FGameCount;
    SendMessage(Global.Plugin.AssignGamePluginId, LWM_TOTAL_COUNT, 0, 0);

    if (GameDiv = CO_RATEPLAN_GAME) and (FeeDiv = CO_GAMEFEE_BASIC) and (ProdCode <> Global.StoreInfo.DefaultGameProdCode) then
      ChargeAmt := ProdAmt + IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0)

    //chy test
    else if (GameDiv = CO_RATEPLAN_TIME) then
      ChargeAmt := IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0)

    else
      ChargeAmt := (ProdAmt * FGameCount) + IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0);
  end;
end;
procedure TAssignControl.SetGameMin(const AValue: Integer);
begin
  if (FGameMin <> AValue) then
  begin
    FGameMin := AValue;
    if (MembershipSeq > 0) then
    begin
      if (MembershipRemainMin < FGameMin) then
      begin
        MembershipUseMin := MembershipRemainMin;
        BuyGameMin := (FGameMin - MembershipRemainMin);
      end
      else
      begin
        MembershipUseMin := FGameMin;
        BuyGameMin := 0;
      end;
    end
    else
    begin
      MembershipUseMin := 0;
      BuyGameMin := FGameMin;
    end;
    EditGameMin.Value := FGameMin;
    SendMessage(Global.Plugin.AssignGamePluginId, LWM_TOTAL_MIN, 0, 0);

    //chy test
    //ChargeAmt := (ProdAmt * FGameCount) + IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0);
    ChargeAmt := IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0);
  end;
end;
procedure TAssignControl.SetMembershipUseCount(const AValue: Integer);
begin
  if (FMembershipUseCount <> AValue) then
  begin
    FMembershipUseCount := AValue;
    GameCount := (FMembershipUseCount + BuyGameCount);
    if (FMembershipUseCount > 0) then
      MembershipName := FMembershipName;
//    GameCountSubTotal := (GameCount + FMembershipGameCount);
//    GameMinSubTotal := (GameCount * BuyGameMin) + (FMembershipGameCount * MembershipGameMin);
//    ChargeAmt := (ProdAmt * (GameCount + FMembershipGameCount)) + IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0);
  end;
end;
procedure TAssignControl.SetMembershipUseMin(const AValue: Integer);
begin
  if (FMembershipUseMin <> AValue) then
  begin
    FMembershipUseMin := AValue;
    GameMin := (FMembershipUseMin + BuyGameMin);
    if (FMembershipUseMin > 0) then
      MembershipName := FMembershipName;
//    GameMinSubTotal := ((BuyGameMin * (GameCount - MembershipGameCount)) + FMembershipGameMin);
  end;
end;
procedure TAssignControl.SetBuyGameCount(const AValue: Integer);
begin
  if (FBuyGameCount <> AValue) then
  begin
    FBuyGameCount := AValue;
    GameCount := (FBuyGameCount + MembershipUseCount);
//    ChargeAmt := (ProdAmt * (GameCount - MembershipGameCount)) + IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0);
  end;
end;
procedure TAssignControl.SetBuyGameMin(const AValue: Integer);
begin
  if (FBuyGameMin <> AValue) then
  begin
    FBuyGameMin := AValue;
    GameMin := (FBuyGameMin + MembershipUseMin);
//    GameMinSubTotal := ((FBuyGameMin * (GameCount - MembershipGameCount)) + MembershipGameMin);
//    ChargeAmt := (ProdAmt * (GameCount - MembershipGameCount)) + IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0);
  end;
end;
procedure TAssignControl.SetGameProgress(const AValue: Integer);
begin
  FGameProgress := AValue;
  LabelGameProgress.Caption := FGameProgress.ToString;
  //EditGameCount.MaxValue := LC_LIMIT_GAME_COUNT;
  //EditGameCount.MinValue := FGameProgress; //�̹� ����� ���� ������ ���� ���� ����
  //if (GameCount < FGameProgress) then
    //GameCount := FGameProgress;
end;
procedure TAssignControl.SetGameToCnt(const AValue: Integer);
begin
  if (FGameToCnt <> AValue) then
    FGameToCnt := AValue;
end;
procedure TAssignControl.SetGameDiv(const AValue: ShortInt);
begin
  if (FGameDiv <> AValue) then
  begin
    FGameDiv := AValue;
    ProdCode := '';
    if (FGameDiv = CO_RATEPLAN_TIME) then
      GameCount := 1;
//    ButtonGameCountDec.Enabled := (FGameDiv = CO_RATEPLAN_GAME);
//    ButtonGameCountInc.Enabled := (FGameDiv = CO_RATEPLAN_GAME);
//    EditGameCountSubTotal.Enabled := (FGameDiv = CO_RATEPLAN_GAME);
  end;
end;
procedure TAssignControl.SetProdCode(const AValue: string);
begin
  if (FProdCode <> AValue) then
  begin
    FProdCode := AValue;
    if FProdCode.IsEmpty then
    begin
      FeeDiv := '';
      BuyGameCount := 0;
      BuyGameMin := 0;
      ProdName := '';
      ProdAmt := 0;
    end;
  end;
end;
procedure TAssignControl.SetProdName(const AValue: string);
begin
  if (FProdName <> AValue) then
  begin
    FProdName := AValue;
    EditProdName.Text := FProdName;
    EditProdName.Hint := FProdName;
  end;
end;
procedure TAssignControl.SetShoesRent(const AValue: Boolean);
begin
  if (FShoesRent <> AValue) then
  begin
    FShoesRent := AValue;
    CheckBoxShoesRent.Checked := FShoesRent;

    if (GameDiv = CO_RATEPLAN_GAME) and (FeeDiv = CO_GAMEFEE_BASIC) and (ProdCode <> Global.StoreInfo.DefaultGameProdCode) then
      ChargeAmt := ProdAmt + IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0)
    else if (GameDiv = CO_RATEPLAN_TIME) then
      ChargeAmt := IfThen(FShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0)
    else
      ChargeAmt := (ProdAmt * GameCount) + IfThen(FShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0);
  end;
end;
procedure TAssignControl.SetShoesFree(const AValue: Boolean);
begin
  if (FShoesFree <> AValue) then
  begin
    FShoesFree := AValue;
    CheckBoxShoesFree.Checked := FShoesFree;

    if (GameDiv = CO_RATEPLAN_GAME) and (FeeDiv = CO_GAMEFEE_BASIC) and (ProdCode <> Global.StoreInfo.DefaultGameProdCode) then
      ChargeAmt := ProdAmt + IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0)
    else if (GameDiv = CO_RATEPLAN_TIME) then
      ChargeAmt := IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0)
    else
      ChargeAmt := (ProdAmt * GameCount) + IfThen(ShoesRent and not FShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0);
  end;
end;
procedure TAssignControl.SetMembershipName(const AValue: string);
var
  LValue: string;
begin
  FMembershipName := AValue;
  if (MembershipUseCount > 0) and (ProdDetailDiv = CO_PROD_DETAIL_MEMBER_GAME) then
    LValue := Format('%d���� ���) %s', [MembershipUseCount, FMembershipName])
  else if (MembershipUseMin > 0) and (ProdDetailDiv = CO_PROD_DETAIL_MEMBER_TIME) then
    LValue := Format('%d�� ���) %s', [MembershipUseMin, FMembershipName])
  else
    LValue := FMembershipName;
  EditMembershipName.Text := LValue;
  EditMembershipName.Hint := LValue;
end;
procedure TAssignControl.SetProdAmt(const AValue: Integer);
begin
  if (FProdAmt <> AValue) then
  begin
    FProdAmt := AValue;

    if (GameDiv = CO_RATEPLAN_GAME) and (FeeDiv = CO_GAMEFEE_BASIC) and (ProdCode <> Global.StoreInfo.DefaultGameProdCode) then
      ChargeAmt := FProdAmt + IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0)

    //chy
    else if (GameDiv = CO_RATEPLAN_TIME) then
      ChargeAmt := IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0)

    else
      ChargeAmt := (FProdAmt * GameCount) + IfThen(ShoesRent and not ShoesFree, Global.StoreInfo.ShoesRentProdAmt, 0);
  end;
end;
procedure TAssignControl.SetChargeAmt(const AValue: Integer);
begin
  if (FChargeAmt <> AValue) then
  begin
    FChargeAmt := AValue;
    EditChargeAmt.Value := FChargeAmt;
    SendMessage(Global.Plugin.AssignGamePluginId, LWM_TOTAL_AMT, 0, 0);
  end;
end;
procedure TAssignControl.SetEnableBuy(const AValue: Boolean);
begin
  if (FEnableBuy <> AValue) then
  begin
    FEnableBuy := AValue;
    EditProdName.Enabled := FEnableBuy;
    ButtonProdPopup.Enabled := FEnableBuy;
    ButtonProdClear.Enabled := FEnableBuy;
    if not FEnableBuy then
      ProdCode := '';
  end;
end;
procedure TAssignControl.SetItemIndex(const AValue: ShortInt);
begin
  FItemIndex := AValue;
  DragReorderImage.Tag := FItemIndex;
end;
{ TLaneNoPanel }
constructor TLaneNoPanel.Create(AOwner: TComponent; const AIndex: ShortInt; AParent: TWinControl);
begin
  inherited Create(AOwner);
  FLaneNo := 0;
  FLaneStatus := CO_LANE_READY;
  Self.Caption := Global.LaneInfo.Lanes[AIndex].LaneNo.ToString;
  Self.Cursor := crHandPoint;
  Self.Tag := AIndex;
  Self.Height := 40;
  Self.Width := 40;
  Self.BevelOuter := bvNone;
  Self.AlignWithMargins := True;
  Self.Color := CO_COLOR_LANE_NO_NORMAL;
  Self.Margins.Left := 0;
  Self.Margins.Right := IfThen(Odd(Global.LaneInfo.Lanes[AIndex].LaneNo), 1, 5);
  Self.Margins.Top := 5;
  Self.Margins.Bottom := 0;
  Self.Font.Color := clWhite;
  Self.Font.Size := 14;
  Self.Font.Style := [fsBold];
  Self.StyleElements := [];
  Self.Align := alLeft;
  Self.Left := (Self.Width + Self.Margins.Right + 100) * AIndex + 40;
  Self.Parent := AParent;
  Self.ShowHint := True;
  Self.Hint := '���';
  StatusPanel := TPanel.Create(AOwner);
  with StatusPanel do
  begin
    Caption := '';
    Tag := AIndex;
    Height := 5;
    BevelOuter := bvNone;
    Color := CO_COLOR_LANE_READY;
    StyleElements := [];
    Parent := Self;
    Align := alBottom;
    Visible := False;
  end;
end;
destructor TLaneNoPanel.Destroy;
begin
  StatusPanel.Free;
  inherited;
end;
procedure TLaneNoPanel.SetLaneStatus(const AValue: Shortint);
begin
  if (FLaneStatus <> AValue) then
  begin
    FLaneStatus := AValue;
    Self.Hint := GetLaneStatusName(FLaneStatus);
    Self.Font.Color := IfThen(FLaneStatus in [CO_LANE_READY], clWhite, clSilver);
    StatusPanel.Color := GetLaneStatusColor(FLaneStatus);
    StatusPanel.Visible := (FLaneStatus <> CO_LANE_READY);
  end;
end;
////////////////////////////////////////////////////////////////////////////////////////////////////
function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPAssignGameForm.Create(Application, AMsg);
end;
exports
  OpenPlugin;
end.
