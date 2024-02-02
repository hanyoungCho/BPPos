(*******************************************************************************

  Project     : ������ POS �ý���
  Title       : �ſ�ī�� ���� �÷�����
  Author      : �̼���
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  Copyright��SolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPPaymentCard.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Mask,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { EhLib }
  DBCtrlsEh, dxGDIPlusClasses;

{$I ..\..\common\Common.BPCommon.inc}

type
  TBPPaymentCardForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    lblPluginVersion: TLabel;
    panRight: TPanel;
    imgLogo: TImage;
    btnApprove: TBitBtn;
    edtChargeTotal: TDBNumberEditEh;
    edtUnpaidTotal: TDBNumberEditEh;
    edtInstallMonth: TDBNumberEditEh;
    edtPaymentAmt: TDBNumberEditEh;
    edtManualApproveNo: TDBEditEh;
    edtManualCardNo: TDBEditEh;
    cbxManualCardList: TDBComboBoxEh;
    ckbManualnput: TCheckBox;
    ckbApplyDiscount: TCheckBox;
    ckbUseAppCard: TCheckBox;
    lblOrgApproveDate: TLabel;
    lblOrgApproveNo: TLabel;

    procedure PluginModuleActivate(Sender: TObject);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnApproveClick(Sender: TObject);
    procedure ckbManualnputClick(Sender: TObject);
    procedure edtPaymentAmtChange(Sender: TObject);
    procedure edtPaymentAmtEnter(Sender: TObject);
    procedure edtInstallMonthEnter(Sender: TObject);
    procedure ckbApplyDiscountClick(Sender: TObject);
    procedure edtInstallMonthChange(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FInputAmt: Integer;
    FIsApproval: Boolean;
    FIsSaleMode: Boolean;
    FIsManualInput: Boolean;
    FReceiptNo: string;
    FApprovalNo: string;
    FApprovalDate: string;
    FAppCardOTC: string;
    FWorking: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DoApprove;
    procedure UseAppCardControl(const AValue: Boolean);
    procedure SetIsApproval(const AValue: Boolean);
    procedure SetIsManualInput(const AValue: Boolean);
    procedure SetInputAmt(const AValue: Integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    property InputAmt: Integer read FInputAmt write SetInputAmt default 0;
    property IsApproval: Boolean read FIsApproval write SetIsApproval default False;
    property IsManualInput: Boolean read FIsManualInput write SetIsManualInput default False;
  end;

implementation

uses
  { Native }
  Vcl.Dialogs, System.Variants, System.StrUtils,
  { VAN }
  uVanDaemonModule,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.LayeredForm, Common.BPMsgBox;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPPaymentCardForm }

constructor TBPPaymentCardForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);

  FOwnerId := 0;
  FIsApproval := False;
  FIsManualInput := False;
  FAppCardOTC := '';
  FReceiptNo := '';

  LF := TLayeredForm.Create(nil);
  LF.Show;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  IsApproval := False;
  IsManualInput := False;
  UseAppCardControl(False);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPPaymentCardForm.Destroy;
begin
  LF.Release;

  inherited Destroy;
end;

procedure TBPPaymentCardForm.PluginModuleActivate(Sender: TObject);
begin
  with edtPaymentAmt do
  begin
    SelStart := Length(Text) + 1;
    if FIsApproval then
      Self.SetFocus;
  end;
end;

procedure TBPPaymentCardForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPPaymentCardForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPPaymentCardForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    InputAmt := AMsg.ParamByInteger(CPP_APPROVAL_AMT);
    IsApproval := AMsg.ParamByBoolean(CPP_APPROVAL_YN);
    FIsSaleMode := AMsg.ParamByBoolean(CPP_SALEMODE_YN);
    FReceiptNo := AMsg.ParamByString(CPP_RECEIPT_NO);
    FApprovalNo := AMsg.ParamByString(CPP_APPROVAL_NO);
    FApprovalDate := AMsg.ParamByString(CPP_APPROVAL_DATE);
  end
  else if (AMsg.Command = CPC_SEND_DATA) then
  begin
    FAppCardOTC := AMsg.ParamByString(CPP_BARCODE);
    edtManualCardNo.Text := Copy(FAppCardOTC, 1, 6);
  end;
end;

procedure TBPPaymentCardForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    239: //CL
      if (ActiveControl is TCustomEdit) then
        TCustomEdit(ActiveControl).Clear;
    VK_RETURN:
      if IsApproval then
        btnApprove.Click;
    VK_ESCAPE:
      Self.Close;
  end;
end;

procedure TBPPaymentCardForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPPaymentCardForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPPaymentCardForm.btnApproveClick(Sender: TObject);
begin
  DoApprove;
end;

procedure TBPPaymentCardForm.ckbApplyDiscountClick(Sender: TObject);
begin
  UseAppCardControl(TCheckBox(Sender).Checked);
end;

procedure TBPPaymentCardForm.ckbManualnputClick(Sender: TObject);
begin
  IsManualInput := TCheckBox(Sender).Checked;
end;

procedure TBPPaymentCardForm.edtPaymentAmtChange(Sender: TObject);
begin
  with TDBNumberEditEh(Sender) do
  begin
    if VarIsNull(Value) then
      Value := 0;
    InputAmt := Trunc(Value);
    Text := FormatCurr('#,##0', InputAmt);
    SelStart := Length(Text) + 1;
  end;
end;

procedure TBPPaymentCardForm.edtPaymentAmtEnter(Sender: TObject);
begin
  with TDBNumberEditEh(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TBPPaymentCardForm.edtInstallMonthChange(Sender: TObject);
begin
  with TDBNumberEditEh(Sender) do
    if VarIsNull(Value) then
      Value := 0;
end;

procedure TBPPaymentCardForm.edtInstallMonthEnter(Sender: TObject);
begin
  with TDBNumberEditEh(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TBPPaymentCardForm.DoApprove;
var
  PM: TPluginMessage;
  SI: TCardSendInfoDM;
  RI: TCardRecvInfoDM;
  PR: TPaymentItemRec;
  LAssignLaneNo: ShortInt;
  LInputAmt, LVatAmt, LPromoSeq, LPromoAmt, LOldOwnerId: Integer;
  LCardNo, LAgreeNo, LCardBinNo, LProdDiv, LPromoDiv, LResMsg: string;
  LResult: Boolean;
begin
  if FWorking then
    Exit;
  FWorking := True;
  LAssignLaneNo := Global.LaneInfo.AssignLaneNo(Global.LaneInfo.SelectedLaneNo);
  btnApprove.Enabled := False;
  edtManualApproveNo.Text := '';
  edtManualCardNo.Text := '';
  cbxManualCardList.ItemIndex := -1;
  try
    FAppCardOTC := '';
    LInputAmt := InputAmt;
    LPromoSeq := 0;
    LPromoAmt := 0;
    LPromoDiv := '';
    LResMsg := '';
    if (BPDM.QRSaleItem.RecordCount > 0) then
      LProdDiv := BPDM.QRSaleItem.FieldByName('prod_div').AsString;

    try
      //��� ����
      if ckbApplyDiscount.Checked then
      begin
        if (BPDM.QRSaleItem.RecordCount = 0) or
           (BPDM.QRSaleItem.RecordCount > 1) then
          raise Exception.Create('������� ������ �ֹ���ǰ�� 1���� ��쿡�� �����մϴ�.');

        if LProdDiv.IsEmpty then
          raise Exception.Create('��������� ������ ��ǰ�� ���õ��� �ʾҽ��ϴ�.');
      end;

      //��ī��(OTC) ����
      if ckbUseAppCard.Checked then
      begin
        with Global.BarcodeScanner do
        if (not Enabled) or
           (not Assigned(Comdevice)) then
          raise Exception.Create('�� ī��� �����Ϸ��� ���ڵ� ��ĳ�ʸ� ����� �� �־�� �մϴ�.');

        //���� ��⿡�� OTC ���ڵ� ������ ���� ��Ʈ ����
        Global.BarcodeScanner.Close;
      end;

      if (LInputAmt <= 0) then
        raise Exception.Create('������ �ݾ��� �Է��Ͽ� �ֽʽÿ�.');
      if IsApproval and
         (LInputAmt > Global.ReceiptInfo.ChargeAmt) then
        raise Exception.Create('���� �ݾ׺��� ������ �ݾ��� �� �����ϴ�.');
      if IsManualInput and
         ((Length(edtManualCardNo.Text) <> 4) or (edtManualApproveNo.Text = '') or (cbxManualCardList.ItemIndex < 0)) then
        raise Exception.Create('���ι�ȣ �� ī���ȣ �� 4�ڸ��� �Է��ϰ�' + _CRLF + '�ſ�ī�� �߱޻縦 �����Ͽ� �ֽʽÿ�.');

      LVatAmt := (LInputAmt - Trunc(LInputAmt / 1.1));
      if IsManualInput then
      begin
        LCardNo := Trim(edtManualCardNo.Text);
        LAgreeNo := Trim(edtManualApproveNo.Text);
        if (LCardNo.Length < 4) or
           (LAgreeNo.Length < 8) then
          raise Exception.Create('ī���ȣ �� 4�ڸ� �� ���ι�ȣ 8�ڸ��� �Է��Ͽ� �ֽʽÿ�.');

        RI.CardNo := LCardNo + StringOfChar('*', 12);
        RI.AgreeNo := LAgreeNo;
        with BPDM.QRCreditCardList do
          if (cbxManualCardList.ItemIndex >= 0) then
          begin
            RI.BalgupsaCode := FieldByName('code').AsString;
            RI.BalgupsaName := FieldByName('issuer').AsString;
            RI.CompCode := FieldByName('code').AsString;
            RI.CompName := FieldByName('acquirer').AsString;
          end;
        LResult := True;
      end
      else
      begin
        SI.Approval     := FIsApproval;
        SI.SaleAmt      := LInputAmt;
        SI.FreeAmt      := 0;
        SI.SvcAmt       := 0;
        SI.VatAmt       := LVatAmt;
        SI.EyCard       := False;
        SI.KeyInput     := False;
        SI.TrsType      := ''; //'A'=���ڵ� ���� ��� ��
        SI.HalbuMonth   := Trunc(StrToIntDef(edtInstallMonth.Text, 0));
        SI.TerminalID   := Global.TerminalInfo.VanTID;
        SI.BizNo        := Global.StoreInfo.BizNo;
        SI.SignOption   := CO_RESULT_YES;
        SI.CardBinNo    := '';
        SI.OrgAgreeNo   := '';
        SI.OrgAgreeDate := '';

        if ckbUseAppCard.Checked then
        begin
          LOldOwnerId := Global.BarcodeScanner.OwnerId;
          Global.BarcodeScanner.OwnerId := Self.PluginID;
          PM := TPluginMessage.Create(nil);
          try
            PM.Command := CPC_INIT;
            PM.AddParams(CPP_OWNER_ID, Self.PluginID);
            if (PluginManager.OpenModal('BPAppCardScan' + CO_DEFAULT_EXT_PLUGIN, PM) = mrOK) then
              SI.OTCNo := FAppCardOTC;
          finally
            Global.BarcodeScanner.OwnerId := LOldOwnerId;
            FreeAndNil(PM);
          end;
        end;

        if FIsApproval then
        begin
          //����ƮPOS������ ������� ����
          if (Global.TerminalInfo.SaleZoneCode = CO_SALEZONE_POS_FRONT) and
             ckbApplyDiscount.Checked then
          begin
            RI := VanModule.CallCardInfo(SI);
            if RI.Result then
            begin
              LCardBinNo := Copy(IfThen(ckbUseAppCard.Checked, FAppCardOTC, RI.CardBinNo), 1, 6); //'944011';
              SI.CardBinNo := LCardBinNo;
              if BPDM.GetCardBinDiscount(LCardBinNo, LProdDiv, LInputAmt, LPromoSeq, LPromoAmt, LResMsg) and
                 (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
                    'ī��� ���� ������ ����Ǵ� �ſ�ī���Դϴ�.' + _BR + '���αݾ� ' + FormatCurr('#,##0', LPromoAmt) + ' ���� �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) = mrOK) then
              begin
                LPromoDiv := CO_DISCOUNT_CARD_IMMEDIATE;
                LInputAmt := (InputAmt - LPromoAmt);
                SI.SaleAmt:= LInputAmt;
              end;
            end;
          end;
        end
        else
        begin
          SI.OrgAgreeNo := FApprovalNo;
          SI.OrgAgreeDate := FApprovalDate;
        end;

        RI := VanModule.CallCard(SI);
        LResult := RI.Result;
        if not LResult then
          raise Exception.Create(RI.Msg);
      end;

      if LResult then
      begin
        if FIsApproval then
        begin
          if FIsSaleMode then
          begin
            PayLog(FReceiptNo, FIsApproval, IsManualInput, CO_PAYMENT_CARD, RI.CardNo, RI.AgreeNo, LInputAmt);
            Global.ReceiptInfo.CardPayAmt := (Global.ReceiptInfo.CardPayAmt + LInputAmt);
          end;

          PR.Clear;
          PR.IsApproval := FIsApproval;
          PR.IsManualInput := IsManualInput;
          PR.PayMethod := CO_PAYMENT_CARD;
          PR.VanCode := Global.TerminalInfo.VanCode;
          PR.TID := Global.TerminalInfo.VanTID;
          PR.ApproveNo := RI.AgreeNo;
          PR.ApproveAmt := LInputAmt;
          PR.VAT := LVatAmt;
          PR.InstallMonth := edtInstallMonth.Value;
          PR.CardNo := RI.CardNo;
          PR.TradeNo := RI.TransNo;
          PR.TradeDate := Global.DateTime.CurrentDate;
          PR.IssuerCode := RI.BalgupsaCode;
          PR.ISsuerName := RI.BalgupsaName;
          PR.BuyerCode := RI.CompCode;
          PR.BuyerName := RI.CompName;
          if not BPDM.UpdatePayment(LAssignLaneNo, FIsSaleMode, False, PR, LResMsg) then
            raise Exception.Create(LResMsg);
        end
        else
        begin
          if FIsSaleMode then
            Global.ReceiptInfo.CardPayAmt := (Global.ReceiptInfo.CardPayAmt - LInputAmt);

          PayLog(FReceiptNo, FIsApproval, IsManualInput, CO_PAYMENT_CARD, RI.CardNo, RI.AgreeNo, LInputAmt);
          PM := TPluginMessage.Create(nil);
          try
            PM.Command := CPC_CARD_CANCEL;
            PM.AddParams(CPP_APPROVAL_NO, RI.AgreeNo);
            PM.PluginMessageToID(FOwnerId);
          finally
            FreeAndNil(PM);
          end;
        end;

        if not IsManualInput then
          BPMsgBox(Self.Handle, mtInformation, '�˸�', '�ſ�ŷ��� ���� ' + IfThen(FIsApproval, '����', '���') + '�Ǿ����ϴ�.', ['Ȯ��'], 5);
        ModalResult := mrOK;
      end;
    except
      on E: Exception do
      begin
        UpdateLog(Format('DoCardApprove(%s).Exception = %s', [BoolToStr(FIsApproval), E.Message]));
        BPMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
      end;
    end;
  finally
    if (edtManualCardNo.Text = '') then
      edtManualCardNo.Clear;
    if (edtManualApproveNo.Text = '') then
      edtManualApproveNo.Clear;

    //���� ��⿡�� OTC ���ڵ� ������ ���� ������ �����ߴ� ��Ʈ�� �翬��
    if ckbUseAppCard.Checked then
      Global.BarcodeScanner.Open;
    btnApprove.Enabled := True;
    FWorking := False;
  end;
end;

procedure TBPPaymentCardForm.UseAppCardControl(const AValue: Boolean);
begin
  ckbUseAppCard.Enabled := AValue;
  ckbUseAppCard.Checked := False;
end;

procedure TBPPaymentCardForm.SetInputAmt(const AValue: Integer);
var
  LUnpaidAmt: Integer;
begin
  FInputAmt := AValue;
  with Global.ReceiptInfo do
  begin
    if (FInputAmt > UnpaidAmt) then
      LUnpaidAmt := 0
    else
      LUnpaidAmt := (UnpaidAmt - FInputAmt);

    edtPaymentAmt.Value := FInputAmt;
    edtChargeTotal.Text := FormatCurr('#,##0', ChargeAmt); //�����ݾ�
    edtUnpaidTotal.Text := FormatCurr('#,##0', LUnpaidAmt); //�̰����ݾ�
  end;
end;

procedure TBPPaymentCardForm.SetIsApproval(const AValue: Boolean);
begin
  FIsApproval := AValue;
  panHeader.Caption := '�ſ�ī�� '+ IfThen(FIsApproval, '����', '���');
  edtPaymentAmt.ControlLabel.Caption := IfThen(FIsApproval, '���� ����', '���� ���') + ' �ݾ� (��)';
  edtPaymentAmt.ReadOnly := (not FIsApproval);
  edtInstallMonth.Enabled := FIsApproval;
  lblOrgApproveDate.Caption := Format('���ŷ����� : %s', [FApprovalNo]);
  lblOrgApproveNo.Caption := Format('�����ι�ȣ : %s', [FApprovalDate]);
  lblOrgApproveDate.Visible := (not FIsApproval);
  lblOrgApproveNo.Visible := (not FIsApproval);
  ckbManualnput.Enabled := FIsApproval;
  edtManualCardNo.Enabled := FIsApproval;
  edtManualApproveNo.Enabled := FIsApproval;
  ckbUseAppCard.Enabled := (not FIsApproval);
  ckbApplyDiscount.Enabled := FIsApproval and (Global.TerminalInfo.SaleZoneCode = CO_SALEZONE_POS_FRONT); //����ƮPOS�� ������� ����
  btnApprove.Caption := IfThen(FIsApproval, '���� ��û', '��� ��û');
end;

procedure TBPPaymentCardForm.SetIsManualInput(const AValue: Boolean);
begin
  FIsManualInput := AValue;
  if (FIsManualInput <> AValue) then
  begin
    edtManualCardNo.Enabled := FIsManualInput;
    cbxManualCardList.Enabled := FIsManualInput;
    edtManualApproveNo.Enabled := FIsManualInput;
    btnApprove.Caption := IfThen(FIsManualInput, '���� ���', '���� ��û');
    ckbApplyDiscount.Enabled := (not FIsManualInput);
    ckbUseAppCard.Enabled := (not FIsManualInput);
    if FIsManualInput then
    begin
      ckbApplyDiscount.Checked := False;
      ckbUseAppCard.Checked := False;
      if Self.Active then
        edtManualApproveNo.SetFocus;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPPaymentCardForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.