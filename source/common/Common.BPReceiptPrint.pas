unit Common.BPReceiptPrint;
interface
uses
  System.Classes, System.SysUtils, System.Math, System.StrUtils, fx.Json;
{$I Common.BPCommon.inc}
const
  // ������ Ư�����
  rptReceiptCharNormal    = '{N}';   // �Ϲ� ����
  rptReceiptCharBold      = '{B}';   // ���� ����
  rptReceiptCharInverse   = '{I}';   // ���� ����
  rptReceiptCharUnderline = '{U}';   // ���� ����
  rptReceiptAlignLeft     = '{L}';   // ���� ����
  rptReceiptAlignCenter   = '{C}';   // ��� ����
  rptReceiptAlignRight    = '{R}';   // ������ ����
  rptReceiptSizeNormal    = '{S}';   // ���� ũ��
  rptReceiptSizeWidth     = '{X}';   // ����Ȯ�� ũ��
  rptReceiptSizeHeight    = '{Y}';   // ����Ȯ�� ũ��
  rptReceiptSizeBoth      = '{Z}';   // ���μ���Ȯ�� ũ��
  rptReceiptSize3Times    = '{3}';   // ���μ���3��Ȯ�� ũ��
  rptReceiptSize4Times    = '{4}';   // ���μ���4��Ȯ�� ũ��
  rptReceiptInit          = '{!}';   // ������ �ʱ�ȭ
  rptReceiptCut           = '{/}';   // ����Ŀ��
  rptReceiptImage1        = '{*}';   // �׸� �μ� 1
  rptReceiptImage2        = '{@}';   // �׸� �μ� 2
  rptReceiptCashDrawerOpen= '{O}';   // ������ ����
  rptReceiptSpacingNormal = '{=}';   // �ٰ��� ����
  rptReceiptSpacingNarrow = '{&}';   // �ٰ��� ����
  rptReceiptSpacingWide   = '{\}';   // �ٰ��� ����
  rptLF                   = '{-}';   // �ٹٲ�
  rptBarCodeBegin128      = '{<}';   // ���ڵ� ��� ���� CODE128
  rptBarCodeBegin39       = '{[}';   // ���ڵ� ��� ���� CODE39
  rptBarCodeEnd           = '{>}';   // ���ڵ� ��� ��
  rptQRCodeBegin          = '{^}';   //QR�ڵ� ��� ����
  rptQRCodeEnd            = '{~}';   //QR�ڵ� ��� ��
  // ������ ��¸�� (������ ���� ��¿��� �����)
  rptReceiptCharSaleDate  = '{D}';   // �Ǹ�����
  rptReceiptCharPosNo     = '{P}';   // ������ȣ
  rptReceiptCharPosName   = '{Q}';   // ������
  rptReceiptCharBillNo    = '{A}';   // ����ȣ
  rptReceiptCharDateTime  = '{E}';   // ����Ͻ�
  RECEIPT_TITLE1          = '��ǰ��                      �ܰ� ����       �ݾ�';
  RECEIPT_TITLE2          = '��ǰ��                �ܰ� ����       �ݾ�';
  RECEIPT_LINE1           = '------------------------------------------------';
  RECEIPT_LINE2           = '------------------------------------------';
  RECEIPT_LINE3           = '================================================';
  RECEIPT_LINE4           = '==========================================';
type
  TDeviceType = (dtNone, dtPos, dtKiosk);
  TReceiptPaymentType = (ptVoid, ptCash, ptCard, ptPayco);
  TReceiptStoreInfo = class(TJson)
    StoreName: string;              // �����
    BizNo: string;                  // ����ڹ�ȣ
    BossName: string;               // ���ָ�
    Tel: string;                    // ��ȭ��ȣ
    Addr: string;                   // �ּ�
    CashierName: string;            // �Ǹ��ڸ�
  end;
  TReceiptMemberInfo = class(TJson)
    MemberName: string;             // ȸ����
    MemberNo: string;               // ȸ����ȣ
    TelNo: string;                  // ��ȭ��ȣ
    CarNo: string;                  // ������ȣ
    QRCode: string;                 // ȸ��QR�ڵ�
    LockerList: string;             // �̿����ζ�Ŀ����
    LockerExpiredDate: string;      // ��Ŀ������
  end;
  TReceiptBaseInfo = class(TJson)
    ReceiptNo: string;              // ��������ȣ(���ڵ�)
    SaleDate: string;               // �Ǹ�����
    SaleTime: string;               // �Ǹ��Ͻ�
    ReturnDate: string;             // ��ǰ���� (��ǰ�� ���Ǹ�����)
    IsReprint: Boolean;             // ����� ����
    TotalAmt: Integer;              // ��ǰ�ǸŽ� �� �Ǹűݾ�
    DCAmt: Integer;                 // ���αݾ�
    KeepAmt: Integer;               // ��Ŀ������
    Top1: string;                   // ��ܹ���1
    Top2: string;                   // ��ܹ���2
    Top3: string;                   // ��ܹ���3
    Top4: string;                   // ��ܹ���4
    Bottom1: string;                // �ϴܹ���1
    Bottom2: string;                // �ϴܹ���2
    Bottom3: string;                // �ϴܹ���3
    Bottom4: string;                // �ϴܹ���4
  end;
  TReceiptProductInfo = class(TJson)
    ProdName: string;               // ��ǰ��
    ProdCode: string;               // ��ǰ�ڵ�
    ProdAmt: Integer;               // �Ǹűݾ�(�ܰ�)
    Vat: Integer;                   // �ΰ�����(�ΰ���)
    OrderQty: Integer;              // �ֹ�����
  end;
  TReceiptPaymentInfo = class(TJson)
    &PayCode: TReceiptPaymentType;  // ���� ���
    IsApproval: Boolean;            // ���� ����(True:����, False:���)
    IsManualInput: Boolean;         // �����Է� ����
    ApprovalAmt: Integer;           // ���αݾ�
    ApprovalNo: string;             // ���ι�ȣ
    OrgApproveNo: string;           // �� ���ι�ȣ
    CardNo: string;                 // ī���ȣ
    CashReceiptPerson: Integer;     // �ҵ���� ���(1:����, 2:�����)
    InstallMonth: ShortInt;         // �Һ� ������
    MerchantKey: string;            // ���͹�ȣ
    TransDateTime: string;          // �����Ͻ�
    IssuerName: string;             // �߱޻�
    BuyerName: string;              // ���Ի�
    BuyerTypeName: string;          // ����ó
    PaycoApprovalName: string;      // PAYCO ���α��
  end;
  TReceiptLockerInfo = class(TJson)
    LockerNo: Integer;              // ��Ŀ��ȣ
    LockerName: string;             // ��Ŀ��
    PurchaseMonth: Integer;         // �̿� ������
    StartDate: string;              // �̿� ������
//    EndDate: string;                // �̿� ������
  end;
  TReceipt = class(TJson)
  private
  public
    StoreInfo: TReceiptStoreInfo;
    BaseInfo: TReceiptBaseInfo;
    MemberInfo: TReceiptMemberInfo;
    ProductItems: TArray<TReceiptProductInfo>;
    PaymentItems: TArray<TReceiptPaymentInfo>;
    LockerItems: TArray<TReceiptLockerInfo>;
    constructor Create;
    destructor Destroy; override;
    procedure Load(AJsonText: string);
  end;
  { ���� ���� �� ���� }
  TScorePrintInfo = class(TJson)
    BowlerId: String;
    BowlerNm: String;
    GameCount: Integer;
    TotalScoreSum: Integer;
    TopScore: Integer;
    AvgScore: Integer;
    GameSeq1: String;
    GameSeq2: String;
    GameSeq3: String;
    GameSeq4: String;
    GameSeq5: String;
    GameSeq6: String;
    GameSeq7: String;
    GameSeq8: String;
    GameSeq9: String;
    GameSeq10: String;
  end;
  TScorePrint = class(TJson)
  private
  public
    AssignNo: String;
    LaneNm: String;
    StartDate: String;
    ScorePrintInfo: TArray<TScorePrintInfo>;
    constructor Create;
    destructor Destroy; override;
    procedure Load(AJsonText: string);
  end;
  TReceiptPrint = class
  private
    FDeviceType: TDeviceType;
    FReceipt: TReceipt;
    FScorePrint: TScorePrint;
    FIsRefund: Boolean;
    FInt_37: Integer;
    FInt_11: Integer;
    FInt_48: Integer;
    FInt_33: Integer;
    FInt_15: Integer;
    function LPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
    function RPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
    function SCopy(S: AnsiString; F, L: Integer): string;
    function PadChar(ALength: Integer; APadChar: Char=' '): string;
    function ByteLen(const AText: string): Integer;
    function GetCurrStr(AData: Currency): string;
    function DateTimeStrToString(const ADateTime: string): string;
  public
    constructor Create(ADeviceType: TDeviceType);
    destructor Destroy; override;
    function ReceiptPrint(AJsonText: string; const AIsReprint: Boolean; var AErrMsg: string): Boolean;
    function ScorePrint(AJsonText: string; const AIsReprint: Boolean; var AErrMsg: string): Boolean;
    function PaymentSlipPrint(const APayMethod: ShortInt; const AJsonText: string; var AErrMsg: string): Boolean;
    function PaymentSlipForm(const APayMethod: ShortInt; const APaymentInfo: TReceiptPaymentInfo): string;
    function KitchenOrderPrint(const AJsonText, AReceiptNo, AMemberInfo: string; var AErrMsg: string): Boolean;
    function KitchenOrderForm(const AReceiptNo, AMemberInfo: string): string;
    function QRCodePrint(const AQRCode, ATitle, AStoreName, AMemberName: string; var AErrMsg: string): Boolean;
    function QRCodePrintForm(const AQRCode, ATitle, AStoreName, AMemberName: string): string;
    function SetReceiptPrint: Boolean;
    function SetScorePrint: Boolean;
    function Print(APrintData: string): Boolean;
    function ReceiptHeader: string;
    function ReceiptItemList: string;
    function ReceiptTotalAmt: string;
    function ReceiptPayList: string;
    function ReceiptPayListInfo: string;
    function ReceiptBottom: string;
    function MakeNewPayCoData(APaymentInfo: TReceiptPaymentInfo): string;  // NewPayCo����
    function ConvertPrintData(AData: string): string;
    function ConvertBarCodeCMD(AData: string): string;
    function MakeQRCodeCMD(AQRCode: string): string;
    property IsRefund: Boolean read FIsRefund write FIsRefund default False;
    property Int_11: Integer read FInt_11 write FInt_11;
    property Int_15: Integer read FInt_15 write FInt_15;
    property Int_33: Integer read FInt_33 write FInt_33;
    property Int_37: Integer read FInt_37 write FInt_37;
    property Int_48: Integer read FInt_48 write FInt_48;
  end;
implementation
uses
  { Native }
  Vcl.Controls, Vcl.Graphics,
  { Project }
  Common.BPGlobal;
{ TReceiptPrint }
function TReceiptPrint.MakeQRCodeCMD(AQRCode: string): string;
begin
  Result := Result + #29#40#107#3#0#49#65#50#0; //QR�ڵ� ����
  Result := Result + #29#40#107#3#0#49#67#8; //������
  Result := Result + #29#40#107 + Chr(length(AQRCode) + 3) + #0 + #49#80#48 + AQRCode; //QR������
  Result := Result + #29#40#107#3#0#49#81#48; //���ڵ�
end;
function TReceiptPrint.ConvertBarCodeCMD(AData: string): string;
const
  BAR_HEIGHT = #$50; // ���ڵ����
  BAR_CODE39 = #69;
  BAR_ITF = #70;
  BAR_CODABAR = #71;
  BAR_CODE93 = #72;
  BAR_CODE128 = #$49; //#73;
var
  BeginPos128, BeginPos39, BeginPos, EndPos: Integer;
  ChkBarCode39: Boolean;
  ALen: Char;
  BarCodeOrg, BarCodeToStr: string;
begin
  while Pos(rptBarCodeEnd, AData) > 0 do
  begin
    BeginPos128 := Pos(rptBarCodeBegin128, AData);
    BeginPos39 := Pos(rptBarCodeBegin39, AData);
    BeginPos := Min(BeginPos128, BeginPos39);
    if BeginPos128 = 0 then
      BeginPos := BeginPos39;
    if BeginPos39 = 0 then
      BeginPos := BeginPos128;
    ChkBarCode39 := BeginPos = BeginPos39;
    EndPos := Pos(rptBarCodeEnd, AData);
    if BeginPos <= 0 then
      Break;
    if EndPos <= 0 then
      Break;
    if BeginPos >= EndPos then
      Break;
    BarCodeOrg := Copy(AData, BeginPos + 3, EndPos - BeginPos - 3);
    // CODE39 �̸�
    if ChkBarCode39 then
    begin
      ALen := Char(Length(BarCodeOrg));
      BarCodeToStr := #$1D#$68 + BAR_HEIGHT + #$1D#$77#$02#$1B#$61#$01#$1D#$48#$02#$1D#$6B + BAR_CODE39 + ALen + BarCodeOrg;
    end
    else
    // CODE128 �̸�
    begin
      ALen := Char(Length(BarCodeOrg) + 2); // 2 �� ���ؾ� ��
      BarCodeToStr := #$1D#$68 + BAR_HEIGHT + #$1D#$77#$02#$1B#$61#$01#$1D#$48#$02#$1D#$6B + BAR_CODE128 + ALen + #$7B#$42 + BarCodeOrg;
    end;
    if ChkBarCode39 then
      AData := ReplaceStr(AData, rptBarCodeBegin39 + BarCodeOrg + rptBarCodeEnd, BarCodeToStr)
    else
      AData := ReplaceStr(AData, rptBarCodeBegin128 + BarCodeOrg + rptBarCodeEnd, BarCodeToStr);
  end;
  Result := AData;
end;
function TReceiptPrint.ConvertPrintData(AData: string): string;
begin
  Result := AData;
  Result := ReplaceStr(Result, rptReceiptCharBold,      #27#71#1);
  Result := ReplaceStr(Result, rptReceiptCharInverse,   #29#66#1);
  Result := ReplaceStr(Result, rptReceiptCharUnderline, #27#45#1);
  Result := ReplaceStr(Result, rptReceiptAlignLeft,     #27#97#0);
  Result := ReplaceStr(Result, rptReceiptAlignCenter,   #27#97#1);
  Result := ReplaceStr(Result, rptReceiptAlignRight,    #27#97#2);
  Result := ReplaceStr(Result, rptReceiptInit,          #27#64);
  Result := ReplaceStr(Result, rptReceiptCut,           #27#105);
  Result := ReplaceStr(Result, rptReceiptImage1,        #13#28#112#1#0);
  Result := ReplaceStr(Result, rptReceiptImage2,        #13#28#112#2#0);
  Result := ReplaceStr(Result, rptReceiptCashDrawerOpen,#27'p'#0#25#250#13#10);
  Result := ReplaceStr(Result, rptReceiptSpacingNormal, #27#51#60);
  Result := ReplaceStr(Result, rptReceiptSpacingNarrow, #27#51#50);
  Result := ReplaceStr(Result, rptReceiptSpacingWide,   #27#51#120);
  Result := ReplaceStr(Result, rptLF,                   #13#10);
  if FDeviceType = dtKiosk then
  begin
    Result := ReplaceStr(Result, rptReceiptSize3Times,  #29#33#17);
    Result := ReplaceStr(Result, rptReceiptSize4Times,  #29#33#34);
    Result := ReplaceStr(Result, rptReceiptSizeNormal,  #29#33#0);
    Result := ReplaceStr(Result, rptReceiptSizeWidth,   #29#33#1);
    Result := ReplaceStr(Result, rptReceiptSizeHeight,  #29#33#16);
  end
  else
  begin
    Result := ReplaceStr(Result, rptReceiptSize3Times,  #29#33#34);
    Result := ReplaceStr(Result, rptReceiptSize4Times,  #29#33#51);
    Result := ReplaceStr(Result, rptReceiptSizeNormal,  #27#33#0);
    Result := ReplaceStr(Result, rptReceiptSizeWidth,   #27#33#32);
    Result := ReplaceStr(Result, rptReceiptSizeHeight,  #27#33#16);
  end;
  Result := ReplaceStr(Result, rptReceiptSizeBoth,      #27#33#48);
  Result := ReplaceStr(Result, rptReceiptCharNormal,    #27#71#0#29#66#0#27#45#0);
  Result := ConvertBarCodeCMD(Result);
end;
constructor TReceiptPrint.Create(ADeviceType: TDeviceType);
begin
  FDeviceType := ADeviceType;
  if Global.ReceiptPrinter.Enabled and
     (not Global.ReceiptPrinter.ComDevice.Active) then
  begin
    Global.ReceiptPrinter.ComDevice.Open;
    Global.ReceiptPrinter.ComDevice.ClearInput;
    Global.ReceiptPrinter.ComDevice.ClearOutput;
  end;
  if (FDeviceType = dtPos) then
  begin
    Int_11 := 9;
    Int_15 := 13;
    Int_33 := 29;
    Int_37 := 33;
    Int_48 := 42;
  end
  else
  begin
    Int_11 := 11;
    Int_15 := 15;
    Int_33 := 33;
    Int_37 := 37;
    Int_48 := 48;
  end;
end;
destructor TReceiptPrint.Destroy;
begin
  inherited;
end;
function TReceiptPrint.MakeNewPayCoData(APaymentInfo: TReceiptPaymentInfo): string;
resourcestring
  STR_POINT = '����������Ʈ';
  STR_COUPON = '����������';
  STR_CARD = '�ſ�ī��';
  STR1 = '***��������(����)***';
  STR2 = '���α��     :';
  STR3 = '�ſ�ī���ȣ :';
  STR4 = '�Һΰ���     :';
  STR5 = '���ι�ȣ     :';
  STR6 = '�����Ͻ�     :';
  STR7 = '���͹�ȣ     :';
  STR8 = '���Ի�       :';
  STR9 = '����ó       :';
  STR10 = '***OK ĳ���� ����Ʈ ����***';
  STR11 = '��������Ʈ          :';
  STR12 = '��밡�� ��������Ʈ :';
  STR13 = '���� ��������Ʈ     :';
  STR14 = '�Ͻú�';
  STR15 = ' ����';
  STR16 = 'Ƽ�Ӵ�ī���ȣ :';
  STR17 = '�������ܾ�   :';
  STR18 = '�����ݾ�     :';
  STR19 = '�������ܾ�   :';
  STR20 = '- PAYCO �������� -';
  STR21 = '- PAYCO ������� -';
  STR22 = '***�����������(����)***';
  STR23 = '�����̸�     :';
var
  ASaleSign: Integer;
begin
  Result := '';
  if APaymentInfo.IsApproval then
    ASaleSign := 1
  else
    ASaleSign := -1;
  Result := Result + rptReceiptAlignCenter + IfThen(APaymentInfo.IsApproval, STR20, STR21) + rptLF;
  Result := Result + RPadB(STR_CARD, Int_33, ' ') + LPadB(GetCurrStr(ASaleSign * APaymentInfo.ApprovalAmt), Int_15, ' ') + rptLF;
  Result := Result + rptReceiptCharNormal + rptReceiptAlignLeft + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  Result := Result + rptReceiptAlignCenter + IfThen(APaymentInfo.IsApproval, STR1, STR22) + rptLF;
  Result := Result + rptReceiptAlignLeft + RPadB(STR2, Int_15, ' ') + LPadB(APaymentInfo.PaycoApprovalName, Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR3, Int_15, ' ') + LPadB(APaymentInfo.CardNo, Int_33, ' ') + rptLF;
  if (APaymentInfo.InstallMonth > 1) then
    Result := Result + RPadB(STR4, Int_15, ' ') + LPadB(APaymentInfo.InstallMonth.ToString + STR15, Int_33, ' ') + rptLF
  else
    Result := Result + RPadB(STR4, Int_15, ' ') + LPadB(STR14, Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR5, Int_15, ' ') + LPadB(APaymentInfo.ApprovalNo, Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR6, Int_15, ' ') + LPadB(DateTimeStrToString(APaymentInfo.TransDateTime), Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR7, Int_15, ' ') + LPadB(APaymentInfo.MerchantKey, Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR8, Int_15, ' ') + LPadB(APaymentInfo.BuyerName, Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR9, Int_15, ' ') + LPadB(APaymentInfo.BuyerTypeName, Int_33, ' ') + rptLF;
end;
function TReceiptPrint.ReceiptBottom: string;
begin
  Result := '';
  Result := Result + rptReceiptSizeNormal;
  Result := Result + rptBarCodeBegin128;
  Result := Result + FReceipt.BaseInfo.ReceiptNo;
  Result := Result+ rptBarCodeEnd + rptLF;
  if not FReceipt.BaseInfo.Bottom1.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Bottom1 + rptLF;
  if not FReceipt.BaseInfo.Bottom2.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Bottom2 + rptLF;
  if not FReceipt.BaseInfo.Bottom3.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Bottom3 + rptLF;
  if not FReceipt.BaseInfo.Bottom4.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Bottom4 + rptLF;
  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
  if FReceipt.BaseInfo.IsReprint then
  begin
    Result := Result + rptReceiptAlignCenter + '������� �� ������ �Դϴ١�' + rptLF;
    Result := Result + rptReceiptAlignLeft;
    if (FDeviceType = dtKiosk) then
      Result := Result + RECEIPT_LINE3 + rptLF;
  end;
  Result := Result + rptLF + rptLF + rptLF + rptReceiptCut;
end;
function TReceiptPrint.PaymentSlipPrint(const APayMethod: ShortInt; const AJsonText: string; var AErrMsg: string): Boolean;
var
  PI: TReceiptPaymentInfo;
begin
  Result := False;
  AErrMsg := '';
  FReceipt := TReceipt.Create;
  try
    try
      FReceipt.Load(AJsonText);
      for var I: ShortInt := 0 to Pred(Length(FReceipt.PaymentItems)) do
      begin
        PI := FReceipt.PaymentItems[I];
        Result := Print(PaymentSlipForm(APayMethod, PI));
      end;
      Result := True;
    except
      on E: Exception do
        AErrMsg := E.Message;
    end;
  finally
    FReceipt.Free;
  end;
end;
function TReceiptPrint.PaymentSlipForm(const APayMethod: ShortInt; const APaymentInfo: TReceiptPaymentInfo): string;
var
  LPayMethod, LApprovalType: string;
begin
  Result := '';
  Result := Result + rptReceiptInit;
  Result := Result + rptReceiptAlignCenter;
  Result := Result + rptReceiptSizeWidth;
  if APaymentInfo.IsApproval then
    LApprovalType := '����'
  else
    LApprovalType := '���';
  LPayMethod := '�ŷ�';
  case APayMethod of
    CO_PAYMENT_CARD:
      LPayMethod := '�ſ�ī��';
    CO_PAYMENT_CASH:
      LPayMethod := '���ݰ���';
    CO_PAYMENT_PAYCO_CARD:
      LPayMethod := 'PAYCO �ſ�ī��';
    CO_PAYMENT_PAYCO_COUPON:
      LPayMethod := 'PAYCO ��������';
    CO_PAYMENT_PAYCO_POINT:
      LPayMethod := 'PAYCO ����Ʈ';
  end;
  Result := Result + Format('%s %s ��ǥ', [LPayMethod, LApprovalType]) + rptLF + rptLF;
  Result := Result + rptReceiptSizeNormal;
  Result := Result + rptReceiptAlignLeft;
  Result := Result + '�� �� ��: ' + FReceipt.StoreInfo.StoreName + rptLF;
  Result := Result + '��ǥ�ڸ�: ' + FReceipt.StoreInfo.BossName + rptLF;
  Result := Result + '��ȭ��ȣ: ' + FReceipt.StoreInfo.Tel + rptLF;
  Result := Result + '�����ּ�: ' + FReceipt.StoreInfo.Addr + rptLF;
  Result := Result + '����ڹ�ȣ: ' + FReceipt.StoreInfo.BizNo + rptLF;
  Result := Result + '�Ǹ��ڸ�: ' + FReceipt.StoreInfo.CashierName + rptLF;
  Result := Result + '��½ð�: ' + Global.DateTime.FormattedCurrentDateTime + rptLF;
  Result := Result + RECEIPT_LINE2 + rptLF;
  Result := Result + rptReceiptAlignCenter + '[ �� �� �� ]' + rptLF;
  Result := Result + rptReceiptAlignLeft + RECEIPT_LINE2 + rptLF;
  Result := Result + '[�� �� �� ��] ' + FormatFloat('#,##0.##', APaymentInfo.ApprovalAmt) + rptLF;
  Result := Result + '[�� �� �� ��] ' + FormatFloat('#,##0', APaymentInfo.ApprovalAmt / 11) + rptLF;
  Result := Result + '[�� �� �� ȣ] ' + APaymentInfo.ApprovalNo + rptLF;
  if (APayMethod in [CO_PAYMENT_CARD, CO_PAYMENT_PAYCO_CARD]) then
  begin
    Result := Result + rptReceiptAlignLeft + '[ī �� �� ȣ] ' + APaymentInfo.CardNo + rptLF;
    if (APaymentInfo.InstallMonth > 1) then
      Result := Result + '[�� �� �� ��] ' + APaymentInfo.InstallMonth.ToString + rptLF
    else
      Result := Result + '[�� �� �� ��] ' + '�Ͻú�' + rptLF;
    Result := Result + '[ī �� �� ��] ' + APaymentInfo.IssuerName + rptLF;
    Result := Result + '[�� �� �� ��] ' + APaymentInfo.BuyerName + rptLF;
    Result := Result + '[�� �� �� ȣ] ' + APaymentInfo.MerchantKey + rptLF;
  end;
  Result := Result + RECEIPT_LINE2 + rptLF;
  Result := Result + rptLF + rptLF + rptLF + rptLF + rptLF + rptReceiptCut;
end;
function TReceiptPrint.KitchenOrderPrint(const AJsonText, AReceiptNo, AMemberInfo: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  FReceipt := TReceipt.Create;
  try
    try
      FReceipt.Load(AJsonText);
      if (Length(FReceipt.ProductItems) > 0) then
        Result := Print(KitchenOrderForm(AReceiptNo, AMemberInfo));
      Result := True;
    except
      on E: Exception do
        AErrMsg := E.Message;
    end;
  finally
    FReceipt.Free;
  end;
end;
function TReceiptPrint.KitchenOrderForm(const AReceiptNo, AMemberInfo: string): string;
var
  PI: TReceiptProductInfo;
begin
  Result := '';
  Result := Result + rptReceiptInit;
  Result := Result + rptReceiptAlignCenter;
  Result := Result + rptReceiptSizeWidth;
  Result := Result + '�ֹ��ֹ���' + rptLF + rptLF;
  Result := Result + rptReceiptSizeNormal;
  Result := Result + rptReceiptAlignLeft;
  Result := Result + RECEIPT_LINE2 + rptLF;
  for var I: ShortInt := 0 to Pred(Length(FReceipt.ProductItems)) do
  begin
    PI := FReceipt.ProductItems[I];
    Result := Result + Format('%s%10s%5s%11s', [
                       RPadB(PI.ProdName, IfThen(FDeviceType = dtKiosk, 22, 16), ' '),
                       FormatFloat('#,##0.##', PI.ProdAmt),
                       FormatFloat('#,##0.##', PI.OrderQty),
                       FormatFloat('#,##0.##', (PI.ProdAmt * PI.OrderQty))
                       ]) + rptLF;
  end;
  Result := Result + RECEIPT_LINE2 + rptLF;
  Result := Result + '�� �� �� ��: ' + AMemberInfo + rptLF;
  Result := Result + '������ ��ȣ: ' + AReceiptNo + rptLF;
  Result := Result + '�� �� �� ��: ' + Global.DateTime.FormattedCurrentDateTime + rptLF;
  Result := Result + rptLF + rptLF + rptLF + rptLF + rptLF + rptReceiptCut;
end;
function TReceiptPrint.QRCodePrint(const AQRCode, ATitle, AStoreName, AMemberName: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
    Result := Print(QRCodePrintForm(AQRCode, ATitle, AStoreName, AMemberName));
    Result := True;
  except
    on E: Exception do
      AErrMsg := E.Message;
  end;
end;
function TReceiptPrint.QRCodePrintForm(const AQRCode, ATitle, AStoreName, AMemberName: string): string;
begin
  Result := '';
  Result := Result + rptLF + rptLF;
  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  Result := Result + rptReceiptAlignCenter + rptReceiptSizeWidth + ATitle + rptReceiptSizeNormal + rptLF;
  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF + rptLF + rptLF;
  Result := Result + MakeQRCodeCMD(AQRCode) + rptLF;
  Result := Result + AMemberName + rptLF;
  Result := Result + AStoreName + rptLF;
  Result := Result + rptReceiptAlignLeft;
  Result := Result + rptLF + rptLF + rptLF + rptLF + rptLF + rptLF + rptReceiptCut;
end;
function TReceiptPrint.ReceiptHeader: string;
begin
  Result := '';
  Result := Result + rptReceiptInit;
  Result := Result + rptReceiptAlignCenter + rptReceiptSizeBoth + rptReceiptCharBold;
  Result := Result + '�� �� ��' + rptLF + rptLF;
  Result := Result + rptReceiptCharNormal + rptReceiptSizeNormal + rptReceiptAlignLeft;
  Result := Result + '�� �� �� : ' + FReceipt.StoreInfo.StoreName + rptLF;
  Result := Result + '��ǥ�ڸ� : ' + FReceipt.StoreInfo.BossName + rptLF;
  Result := Result + '��ȭ��ȣ : ' + FReceipt.StoreInfo.Tel + rptLF;
  Result := Result + '�����ּ� : ' + FReceipt.StoreInfo.Addr + rptLF;
  Result := Result + '����ڹ�ȣ : ' + FReceipt.StoreInfo.BizNo + rptLF;
  Result := Result + '�Ǹ��ڸ� : ' + FReceipt.StoreInfo.CashierName + rptLF;
  Result := Result + '�ŷ��Ͻ� : ' + FReceipt.BaseInfo.SaleDate + ' ' + FReceipt.BaseInfo.SaleTime + rptLF;
  Result := Result + '����Ͻ� : ' + Copy(Global.DateTime.FormattedCurrentDateTime, 1, 16) {yyyy-mm-dd hh:nn} + rptLF;
  if not FReceipt.BaseInfo.Top1.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Top1 + rptLF;
  if not FReceipt.BaseInfo.Top2.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Top2 + rptLF;
  if not FReceipt.BaseInfo.Top3.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Top3 + rptLF;
  if not FReceipt.BaseInfo.Top4.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Top4 + rptLF;
  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_TITLE1, RECEIPT_TITLE2) + rptLF;
  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
end;
function TReceiptPrint.ReceiptItemList: string;
var
  PI: TReceiptProductInfo;
begin
  Result := '';
  for var I: ShortInt := 0 to Pred(Length(FReceipt.ProductItems)) do
  begin
    PI := FReceipt.ProductItems[I];
    Result := Result + Format('%s%10s%5s%11s', [
                         RPadB(PI.ProdName, IfThen(FDeviceType = dtKiosk, 22, 16), ' '),
                         FormatFloat('#,##0.##', PI.ProdAmt),
                         FormatFloat('#,##0.##', PI.OrderQty),
                         FormatFloat('#,##0.##', (PI.ProdAmt * PI.OrderQty))
                        ]) + rptLF;
  end;
end;
function TReceiptPrint.ReceiptPayList: string;
var
  CashStr: string;
  PI: TReceiptPaymentInfo;
begin
  Result := '';
  for var I: ShortInt := 0 to Pred(Length(FReceipt.PaymentItems)) do
  begin
    PI := FReceipt.PaymentItems[I];
    if (PI.PayCode = ptCash) then
    begin
      if (not PI.IsManualInput) and
         (not PI.ApprovalNo.IsEmpty) then
      begin
        if Trim(PI.OrgApproveNo).IsEmpty then
          Result := Result + LPadB('���ݿ�����(����)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', PI.ApprovalAmt), Int_15, ' ') + rptLF
        else
          Result := Result + LPadB('���ݿ�����(���)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', (-1 * PI.ApprovalAmt)), Int_15, ' ') + rptLF;
      end
      else
      begin
        CashStr := IfThen(PI.IsApproval, '����', '���');
        Result := Result + LPadB('����(' + CashStr + ')', Int_33, ' ') +
          LPadB(FormatFloat('#,##0.##', IfThen(PI.IsApproval, 1, -1) * PI.ApprovalAmt), Int_15, ' ') + rptLF;
      end;
    end;
    if (PI.PayCode = ptCard) then
    begin
      if (not PI.IsManualInput) then
      begin
        if PI.IsApproval then
          Result := Result + LPadB('�ſ�ī��(����)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', PI.ApprovalAmt), Int_15, ' ') + rptLF
        else
          Result := Result + LPadB('�ſ�ī��(���)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', -1 * PI.ApprovalAmt), Int_15, ' ') + rptLF;
      end
      else
      begin
        Result := Result + LPadB('ī��(������)', Int_33, ' ') +
          LPadB(FormatFloat('#,##0.##', IfThen(PI.IsApproval, 1, -1) * PI.ApprovalAmt), Int_15, ' ') + rptLF;
      end;
    end;
    if (PI.PayCode = ptPayco) then
    begin
      if PI.IsApproval then
        Result := Result + LPadB('PAYCO(����)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', PI.ApprovalAmt), Int_15, ' ') + rptLF
      else
        Result := Result + LPadB('PAYCO(���)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', PI.ApprovalAmt), Int_15, ' ') + rptLF;
    end;
  end;
  Result := Result + rptReceiptSizeNormal;
  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
end;
function TReceiptPrint.ReceiptPayListInfo: string;
var
  CashMsg: string;
  PI: TReceiptPaymentInfo;
begin
  Result := '';
  with FReceipt do
  begin
    for var I: ShortInt := 0 to Pred(Length(PaymentItems)) do
    begin
      PI := PaymentItems[I];
      if (PI.PayCode = ptCash) then
      begin
        if not Trim(PI.ApprovalNo).IsEmpty then
        begin
          CashMsg := IfThen(PI.CashReceiptPerson = 1, '(�ҵ����)', '(��������)');
          Result := Result + rptReceiptAlignCenter + '';
          Result := Result + IfThen(PI.IsApproval, '<���ݿ�����' + CashMsg + ' ���γ���>', '<���ݿ�����' + CashMsg + ' ��ҳ���>') + rptLF;
          Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
          Result := Result + rptReceiptAlignLeft + rptReceiptCharNormal;
          Result := Result + RPadB('���αݾ�', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', PI.ApprovalAmt), Int_15, ' ') + rptLF;
          Result := Result + RPadB('���ι�ȣ', Int_33, ' ') + LPadB(PI.ApprovalNo, Int_15, ' ') + rptLF;
          Result := Result + RPadB('ī���ȣ', Int_33, ' ') + LPadB(PI.CardNo, Int_15, ' ') + rptLF;
        end;
      end;
      if (PI.PayCode = ptCard) then
      begin
        Result := Result + rptReceiptAlignCenter;
        Result := Result + IfThen(PI.IsApproval, '<�ſ�ī�� ���γ���>', '<�ſ�ī�� ��ҳ���>') + rptLF;
        Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
        Result := Result + rptReceiptAlignLeft + rptReceiptCharNormal;
        Result := Result + RPadB('���αݾ�', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', PI.ApprovalAmt), Int_15, ' ') + rptLF;
        if (PI.InstallMonth > 1) then
          Result := Result + RPadB('�Һΰ���', Int_33, ' ') + LPadB(PI.InstallMonth.ToString  + '����', Int_15, ' ') + rptLF
        else
          Result := Result + RPadB('�Һΰ���', Int_33, ' ') + LPadB('�Ͻú�', Int_15, ' ') + rptLF;
        Result := Result + RPadB('�� �� ��', Int_33, ' ') + LPadB(PI.IssuerName, Int_15, ' ') + rptLF;
        Result := Result + RPadB('���ι�ȣ', Int_33, ' ') + LPadB(PI.ApprovalNo, Int_15, ' ') + rptLF;
        Result := Result + RPadB('ī���ȣ', Int_33, ' ') + LPadB(PI.CardNo, Int_15, ' ') + rptLF;
      end;
      if (PI.PayCode = ptPayco) then
        Result := Result + MakeNewPayCoData(PI);
    end;
    if not Result.IsEmpty then
      Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  end;
end;
function TReceiptPrint.ReceiptPrint(AJsonText: string; const AIsReprint: Boolean; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  FReceipt := TReceipt.Create;
  try
    try
      FReceipt.Load(AJsonText);
      if (Length(FReceipt.ProductItems) > 0) then
        SetReceiptPrint;
      Result := True;
    except
      on E: Exception do
        AErrMsg := E.Message;
    end;
  finally
    FReceipt.Free;
  end;
end;

function TReceiptPrint.ScorePrint(AJsonText: string; const AIsReprint: Boolean; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  FScorePrint := TScorePrint.Create;
  try
    try
      FScorePrint.Load(AJsonText);
      SetScorePrint;
      Result := True;
    except
      on E: Exception do
        AErrMsg := E.Message;
    end;
  finally
    FScorePrint.Free;
  end;
end;

function TReceiptPrint.ReceiptTotalAmt: string;
var
  AVat: Integer;
begin
  AVat := (FReceipt.BaseInfo.TotalAmt - FReceipt.BaseInfo.DCAmt) - Trunc((FReceipt.BaseInfo.TotalAmt - FReceipt.BaseInfo.DCAmt) / 1.1);
  Result := '';
  Result := Result + rptReceiptSizeNormal;
  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  Result := Result + rptReceiptSizeWidth;                        // 16
  Result := Result + Format(IfThen(FDeviceType = dtKiosk, '�Ǹűݾ�%40s', '�Ǹűݾ�%13s'), [FormatFloat('#,##0.##', FReceipt.BaseInfo.TotalAmt)]) + rptLF;
  Result := Result + rptReceiptSizeNormal;
  if (FReceipt.BaseInfo.DCAmt <> 0) then
    Result := Result + LPadB('���αݾ�', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', FReceipt.BaseInfo.DCAmt), Int_11, ' ') + rptLF;
  Result := Result + LPadB('������ǰ�ݾ�', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', ((FReceipt.BaseInfo.TotalAmt - FReceipt.BaseInfo.DCAmt) - AVat)), Int_11, ' ') + rptLF;
  Result := Result + LPadB('�ΰ���(VAT)�ݾ�', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', AVat), Int_11, ' ') + rptLF;
  Result := Result + LPadB('---------------------------', Int_48, ' ') + rptLF;
  if (FReceipt.BaseInfo.KeepAmt <> 0) then
  begin
    Result := Result + LPadB('��Ŀ������', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', FReceipt.BaseInfo.KeepAmt), Int_11, ' ') + rptLF;
    for var I: ShortInt := 0 to Pred(Length(FReceipt.LockerItems)) do
      if (FReceipt.LockerItems[I].LockerNo > 0) then
//        Result := Result + LPadB(Format('%s (%d����) %s~%s', [FReceipt.LockerItems[I].LockerName, FReceipt.LockerItems[I].PurchaseMonth, FReceipt.LockerItems[I].StartDate, FReceipt.LockerItems[I].EndDate]), Int_48, ' ') + rptLF;
        Result := Result + LPadB(Format('%s (%d����) %s~', [FReceipt.LockerItems[I].LockerName, FReceipt.LockerItems[I].PurchaseMonth, FReceipt.LockerItems[I].StartDate]), Int_48, ' ') + rptLF;
    Result := Result + LPadB('---------------------------', Int_48, ' ') + rptLF;
  end;
  Result := Result + rptReceiptSizeWidth;
  if FIsRefund then
    Result := Result + Format(IfThen(FDeviceType = dtKiosk, '��ұݾ�%40s', '��ұݾ�%13s'), [FormatFloat('#,##0.##', -1 * (FReceipt.BaseInfo.TotalAmt - FReceipt.BaseInfo.DCAmt))]) + rptLF
  else
    Result := Result + Format(IfThen(FDeviceType = dtKiosk, '�����ݾ�%40s', '�����ݾ�%13s'), [FormatFloat('#,##0.##', (FReceipt.BaseInfo.TotalAmt - FReceipt.BaseInfo.DCAmt))]) + rptLF;
  Result := Result + rptReceiptSizeNormal;
end;
function TReceiptPrint.SetReceiptPrint: Boolean;
var
  PrintData: string;
  I: Integer;
begin
  Result := False;
  PrintData := '';
  PrintData := PrintData + rptReceiptInit;
  PrintData := PrintData + ReceiptHeader;
  PrintData := PrintData + ReceiptItemList;
  PrintData := PrintData + ReceiptTotalAmt;
  PrintData := PrintData + ReceiptPayList;
  PrintData := PrintData + ReceiptPayListInfo;
  PrintData := PrintData + ReceiptBottom;
  for I := 1 to Global.ReceiptPrinter.Copies do
    Result := Print(PrintData);
end;

function TReceiptPrint.SetScorePrint: Boolean;
var
  PrintData: string;
  I: Integer;
begin
  Result := False;
  PrintData := '';
  PrintData := PrintData + rptReceiptInit;
  PrintData := PrintData + rptReceiptAlignCenter;
  PrintData := PrintData + rptReceiptSizeWidth + '���� ����' + rptLF + rptLF;
  PrintData := PrintData + rptReceiptSizeNormal;
  PrintData := PrintData + rptReceiptAlignLeft;

  PrintData := PrintData + '�̿�ð� : ' + FScorePrint.StartDate + rptLF;
  PrintData := PrintData + '������ȣ : ' + FScorePrint.AssignNo + rptLF;

  PrintData := PrintData + RECEIPT_LINE2 + rptLF;
  PrintData := PrintData + '�� ��        LN    Game   TOT   TOP   AVR' + rptLF;
  PrintData := PrintData + RECEIPT_LINE2 + rptLF;

  for i := 0 to Length(FScorePrint.ScorePrintInfo) - 1 do
  begin
    PrintData := PrintData + Format('%s%4s%8s%7s%6s%6s', [
                     RPadB(FScorePrint.ScorePrintInfo[i].BowlerNm, 10, ' '),
                     FScorePrint.LaneNm,
                     IntToStr(FScorePrint.ScorePrintInfo[i].GameCount),
                     IntToStr(FScorePrint.ScorePrintInfo[i].TotalScoreSum),
                     IntToStr(FScorePrint.ScorePrintInfo[i].TopScore),
                     IntToStr(FScorePrint.ScorePrintInfo[i].AvgScore)
                     ]) + rptLF;
  end;
  PrintData := PrintData + RECEIPT_LINE2 + rptLF;

  for i := 0 to Length(FScorePrint.ScorePrintInfo) - 1 do
  begin
    PrintData := PrintData + FScorePrint.ScorePrintInfo[i].BowlerNm + '   ' +
                             FScorePrint.ScorePrintInfo[i].GameSeq1 + '   ' +
                             FScorePrint.ScorePrintInfo[i].GameSeq2 + '   ' +
                             FScorePrint.ScorePrintInfo[i].GameSeq3 + '   ' +
                             FScorePrint.ScorePrintInfo[i].GameSeq4 + '   ' +
                             FScorePrint.ScorePrintInfo[i].GameSeq5 + '   ' +
                             FScorePrint.ScorePrintInfo[i].GameSeq6 + '   ' +
                             FScorePrint.ScorePrintInfo[i].GameSeq7 + '   ' +
                             FScorePrint.ScorePrintInfo[i].GameSeq8 + '   ' +
                             FScorePrint.ScorePrintInfo[i].GameSeq9 + '   ' +
                             FScorePrint.ScorePrintInfo[i].GameSeq10 + rptLF;
  end;

  PrintData := PrintData + rptLF + rptLF;
  PrintData := PrintData + rptReceiptAlignCenter;
  PrintData := PrintData + FormatDateTime('yyyy��mm��dd�� hh��nn��', now) + rptLF + rptLF + rptLF;
  PrintData := PrintData + rptLF + rptLF + rptLF + rptReceiptCut;

  Result := Print(PrintData);
end;

function TReceiptPrint.Print(APrintData: string): Boolean;
var
  SendData: AnsiString;
begin
  Result := False;
  try
    SendData := ConvertPrintData(APrintData);
    Global.ReceiptPrinter.ComDevice.Write(PAnsiChar(SendData), Length(SendData), False);
    Result := True;
  except
    on E: Exception do
    begin
    end;
  end;
end;
function TReceiptPrint.LPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
begin
  Result := SCopy(AStr, 1, ALength);
  Result := PadChar(ALength - ByteLen(Result), APadChar) + Result;
end;
function TReceiptPrint.RPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
begin
  Result := SCopy(AStr, 1, ALength);
  Result := Result + PadChar(ALength - ByteLen(Result), APadChar);
end;
function TReceiptPrint.SCopy(S: AnsiString; F, L: Integer): string;
var
  ST, ED: Integer;
begin
  ST := 0;
  ED := 0;
  if (F = 1) then
    ST := 1
  else
  begin
    case ByteType(S, F) of
      mbSingleByte : ST := F;
      mbLeadByte   : ST := F;
      mbTrailByte  : ST := (F - 1);
    end;
  end;
  case ByteType(S, ST + L - 1) of
    mbSingleByte : ED := L;
    mbLeadByte   : ED := (L - 1);
    mbTrailByte  : ED := L;
  end;
  Result := Copy(S, ST, ED);
end;
function TReceiptPrint.PadChar(ALength: Integer; APadChar: Char = ' '): string;
begin
  Result := '';
  for var I: ShortInt := 1 to ALength do
    Result := Result + APadChar;
end;
function TReceiptPrint.ByteLen(const AText: string): Integer;
begin
  Result := 0;
  for var I: ShortInt := 1 to Length(AText) do
    Result := Result + IfThen(AText[I] <= #$00FF, 1, 2);
end;
function TReceiptPrint.GetCurrStr(AData: Currency): string;
begin
  Result := FormatFloat('#,##0.###', AData);
end;
function TReceiptPrint.DateTimeStrToString(const ADateTime: string): string;
begin
  if (Length(ADateTime) = 14) then
    Result := Copy(ADateTime, 1, 4) + FormatSettings.DateSeparator + Copy(ADateTime, 5, 2) + FormatSettings.DateSeparator + Copy(ADateTime, 7, 2) + ' ' +
              Copy(ADateTime, 9, 2) + FormatSettings.TimeSeparator + Copy(ADateTime, 11, 2) + FormatSettings.TimeSeparator + Copy(ADateTime, 13, 2);
end;
{ TReceipt }
constructor TReceipt.Create;
begin
  StoreInfo := TReceiptStoreInfo.Create;
  BaseInfo := TReceiptBaseInfo.Create;
  MemberInfo := TReceiptMemberInfo.Create;
  ProductItems := [];
  PaymentItems := [];
  LockerItems := [];
end;
destructor TReceipt.Destroy;
begin
  StoreInfo.Free;
  BaseInfo.Free;
  MemberInfo.Free;
  ProductItems := [];
  PaymentItems := [];
  LockerItems := [];
  inherited;
end;
procedure TReceipt.Load(AJsonText: string);
begin
  try
    TJsonReadWriter.JsonToObject<TReceipt>(AJsonText, Self);
  finally
  end;
end;
{ TScorePrint }

constructor TScorePrint.Create;
begin
  ScorePrintInfo := [];
end;
destructor TScorePrint.Destroy;
begin
  ScorePrintInfo := [];
  inherited;
end;
procedure TScorePrint.Load(AJsonText: string);
begin
  try
    TJsonReadWriter.JsonToObject<TReceipt>(AJsonText, Self);
  finally
  end;
end;

end.
