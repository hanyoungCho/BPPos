(*******************************************************************************

  Project     : ������ POS �ý���
  Title       : �ý��� ȯ�� ���� �÷�����
  Author      : �̼���
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  Copyright��SolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPSetting.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.Mask,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { EhLib }
  DBCtrlsEh;

{$I ..\..\common\Common.BPCommon.inc}

type
  TBPSettingForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    lblPluginVersion: TLabel;
    Panel1: TPanel;
    pgcSetting: TPageControl;
    tabSetting: TTabSheet;
    tabIniFile: TTabSheet;
    btnSaveSetting: TBitBtn;
    ckbApplyToPartnerCenter: TCheckBox;
    btnSettingFile: TSpeedButton;
    btnBaseSetting: TSpeedButton;
    mmoSettingFile: TMemo;
    panStoreInfo: TPanel;
    panBaseInfo: TPanel;
    mmoStoreInfo: TMemo;
    Panel4: TPanel;
    Panel5: TPanel;
    edtTerminalId: TDBEditEh;
    edtApiHostUrl: TDBEditEh;
    edtSecretKey: TDBEditEh;
    lblOAuthResult: TLabel;
    edtDeployHostUrl: TDBEditEh;
    edtVanTID: TDBEditEh;
    edtPaycoTID: TDBEditEh;
    ckbUseLocalSetting: TCheckBox;
    btnCheckOAuth: TBitBtn;
    edtTimeout: TDBNumberEditEh;
    panSettingFile: TPanel;
    panEncToDec: TPanel;
    edtEncryptString: TDBEditEh;
    btnDecryptString: TBitBtn;
    btnRefresh: TBitBtn;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure edtSecretKeyDblClick(Sender: TObject);
    procedure btnCheckOAuthClick(Sender: TObject);
    procedure OnSettingPageButtonClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnSaveSettingClick(Sender: TObject);
    procedure btnDecryptStringClick(Sender: TObject);
    procedure panSettingFileDblClick(Sender: TObject);
    procedure ckbApplyToPartnerCenterClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FNeedNewtoken: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    function RefreshToken(const AUpdateToken: Boolean; const AHostUrl, ATerminalId, ASecretKey: string; var AResMsg: string): Boolean;
    procedure ReadSetting;
    procedure WriteSetting;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  Vcl.Graphics, Vcl.Dialogs, Vcl.ClipBrd,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.BPMsgBox, Common.LayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPSettingForm }

constructor TBPSettingForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);

  FOwnerId := 0;
  FNeedNewtoken := False;
  LF := TLayeredForm.Create(nil);
  LF.Show;

  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  btnBaseSetting.GroupIndex := 100;
  btnSettingFile.GroupIndex := 100;
  panEncToDec.Visible := False;
  with pgcSetting do
  begin
    for var I: ShortInt := 0 to Pred(PageCount) do
      Pages[I].TabVisible := False;
    ActivePageIndex := 0;
  end;

  ReadSetting;
  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPSettingForm.Destroy;
begin
  LF.Release;

  inherited Destroy;
end;

procedure TBPSettingForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPSettingForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPSettingForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
  end;
end;

procedure TBPSettingForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    Self.Close;
end;

procedure TBPSettingForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPSettingForm.panSettingFileDblClick(Sender: TObject);
begin
  panEncToDec.Visible := (not panEncToDec.Visible);
end;

procedure TBPSettingForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPSettingForm.btnDecryptStringClick(Sender: TObject);
begin
  Clipboard.AsText := StrEncrypt(edtEncryptString.Text);
end;

procedure TBPSettingForm.btnRefreshClick(Sender: TObject);
begin
  ReadSetting;
end;

procedure TBPSettingForm.edtSecretKeyDblClick(Sender: TObject);
begin
  with TDBEditEh(Sender) do
    if (PasswordChar = #0) then
      PasswordChar := #42
    else
      PasswordChar := #0;
end;

procedure TBPSettingForm.OnSettingPageButtonClick(Sender: TObject);
begin
  pgcSetting.ActivePageIndex := TSpeedButton(Sender).Tag;
end;

procedure TBPSettingForm.btnSaveSettingClick(Sender: TObject);
var
  LResMsg: string;
begin
  try
    WriteSetting;
    if ckbApplyToPartnerCenter.Checked then
    begin
      if FNeedNewToken and
         not RefreshToken(True, edtApiHostUrl.Text, edtTerminalId.Text, edtSecretKey.Text, LResMsg) then
        raise Exception.Create(LResMsg);
      if not BPDM.PostSystemSetting(LResMsg) then
        raise Exception.Create(LResMsg);
    end;
    ModalResult := mrOk;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '�˸�', '��Ʈ�ʼ��Ϳ� ȯ�漳�� ������ �������� ���߽��ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;

procedure TBPSettingForm.ckbApplyToPartnerCenterClick(Sender: TObject);
begin
  with TCheckBox(Sender) do
    if Checked and
       (BPMsgBox(Self.Handle, mtConfirmation, '����',
          '����� ���� ������ ��Ʈ�ʼ��� �ܸ��� �������� �����Ͻðڽ��ϱ�?' + _BR +
          '����� ���� ���α׷� ����� �ÿ� �ݿ��� �Ǹ� �ý��� �۵� ����� ������ �ݴϴ�.', ['��', '�ƴϿ�']) <> mrOk) then
      Checked := False;
end;

procedure TBPSettingForm.btnCheckOAuthClick(Sender: TObject);
var
  LResMsg: string;
begin
  if Global.PartnerCenter.Authorized and
     (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��', '�̹� ������ �ܸ��� �Դϴ�!' + _BR + '�ٽ� ������ �õ��Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOK) then
    Exit;

  lblOAuthResult.Caption := '���� ��û';
  try
    if not RefreshToken(False, edtApiHostUrl.Text, edtTerminalId.Text, edtSecretKey.Text, LResMsg) then
      raise Exception.Create(LResMsg);
    lblOAuthResult.Caption := '���� �Ϸ�';
    BPMsgBox(Self.Handle, mtInformation, '�˸�', '�ܸ��� ���� �׽�Ʈ�� ���������� �Ϸ�Ǿ����ϴ�!', ['Ȯ��'], 5);
  except
    on E: Exception do
    begin
      lblOAuthResult.Caption := '���� ����';
      BPMsgBox(Self.Handle, mtError, '���� ����', '�͹̳� ID�� ��ũ�� Ű�� Ȯ���Ͽ� �ֽʽÿ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
    end;
  end;
end;

function TBPSettingForm.RefreshToken(const AUpdateToken: Boolean; const AHostUrl, ATerminalId, ASecretKey: string; var AResMsg: string): Boolean;
var
  LToken: string;
begin
  Result := False;
  AResMsg := '';
  try
    if not BPDM.GetToken(AHosturl, ATerminalId, ASecretKey, LToken, AResMsg) then
      raise Exception.Create(AResMsg);
    if AUpdateToken then
    begin
      Global.PartnerCenter.Host := AHostUrl;
      Global.PartnerCenter.Authorized := True;
      Global.PartnerCenter.OAuthToken := LToken;
      Global.PartnerCenter.SecretKey := ASecretKey;
    end;
    Result := True;
  except
    on E: Exception do
      AResMsg := E.Message;
  end;
end;

procedure TBPSettingForm.ReadSetting;
begin
  mmoStoreInfo.Lines.Clear;
  mmoStoreInfo.Lines.Add(Format('�� �����ڵ�: %s', [Global.StoreInfo.StoreCode]));
  mmoStoreInfo.Lines.Add(Format('�� �����: %s', [Global.StoreInfo.StoreName]));
  mmoStoreInfo.Lines.Add(Format('�� ����ڹ�ȣ: %s', [Global.StoreInfo.BizNo]));
  mmoStoreInfo.Lines.Add(Format('�� ����ڸ�: %s', [Global.StoreInfo.StoreName]));
  mmoStoreInfo.Lines.Add(Format('�� ��ǥ�ڸ�: %s', [Global.StoreInfo.BossName]));
  mmoStoreInfo.Lines.Add(Format('�� �ּ�: %s %s', [Global.StoreInfo.Addr, Global.StoreInfo.Addr2]));
  mmoStoreInfo.Lines.Add(Format('�� ��ǥ��ȭ: %s', [Global.StoreInfo.TelNo]));
  mmoStoreInfo.Lines.Add(Format('�� �����ð�: %s - %s', [Global.StoreInfo.OpenTime, Global.StoreInfo.CloseTime]));

  edtTerminalId.Text := Global.PartnerCenter.TerminalId;
  edtApiHostUrl.Text := Global.PartnerCenter.Host;
  edtSecretKey.Text := Global.PartnerCenter.SecretKey;
  edtDeployHostUrl.Text := Global.Setting.Launcher.ReadString('Config', 'DeployUrl', '');
  edtVanTID.Text := Global.TerminalInfo.VanTID;
  edtPaycoTID.Text := Global.TerminalInfo.PaycoTID;
  mmoSettingFile.Lines.LoadFromFile(Global.Setting.System.FileName);
end;

procedure TBPSettingForm.WriteSetting;
var
  LTerminalId, LAPIHostUrl, LSecretKey, LDeployHostUrl: string;
  LTimeout: Integer;
  LUseLocal: Boolean;
begin
  if FileExists(Global.Setting.System.FileName) then
  begin
    if (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
        '������ ����� ���������� �����մϴ�!' + _BR + '�����ϰ� �����Ͻðڽ��ϱ�?', ['Ȯ��', '�ƴϿ�']) <> mrOK) then
      Exit;
    //���� ���
    CopyFile(PChar(Global.Setting.System.FileName), PChar(Global.Setting.System.FileName + '.' + Global.DateTime.CurrentDate), False);
  end;

  //�켱 ���� ������ ������� ����
  mmoSettingFile.Lines.SaveToFile(Global.Setting.System.FileName);
  //�⺻ ���� ������� ����
  LTerminalId := Trim(edtTerminalId.Text);
  LAPIHostUrl := Trim(edtApiHostUrl.Text);
  LSecretKey := StrEncrypt(Trim(edtSecretKey.Text));
  LTimeout := Integer(edtTimeout.Value);
  LUseLocal := ckbUseLocalSetting.Checked;
  LDeployHostUrl := Trim(edtDeployHostUrl.Text);
  FNeedNewToken := (Global.PartnerCenter.TerminalId <> LTerminalId) or
                   (Global.PartnerCenter.Host <> LAPIHostUrl);
  with Global.Setting.System do
  begin
    WriteString('PartnerCenter', 'Host', LAPIHostUrl);
    WriteString('PartnerCenter', 'TerminalId', LTerminalId);
    WriteString('PartnerCenter', 'SecretKey', LSecretKey);
    WriteInteger('PartnerCenter', 'Timeout', LTimeout);
    WriteBool('PartnerCenter', 'UseLocalSetting', LUseLocal);

    WriteString('TerminalInfo', 'VanTID', Trim(edtVanTID.Text));
    WriteString('TerminalInfo', 'PaycoTID', Trim(edtPaycoTID.Text));
  end;

  Global.Setting.Launcher.WriteString('Config', 'DeployUrl', LDeployHostUrl);
  with Global.Setting.Local do
  begin
    if LUseLocal then
    begin
      WriteString('PartnerCenter', 'Host', LAPIHostUrl);
      WriteString('PartnerCenter', 'TerminalId', LTerminalId);
      WriteString('PartnerCenter', 'SecretKey', LSecretKey);
    end
    else
    begin
      WriteString('PartnerCenter', 'Host', '');
      WriteString('PartnerCenter', 'TerminalId', '');
      WriteString('PartnerCenter', 'SecretKey', '');
    end;
    WriteInteger('PartnerCenter', 'Timeout', LTimeout);
  end;

  BPMsgBox(Self.Handle, mtInformation, '�˸�', '���������� �����Ͽ����ϴ�!', ['Ȯ��'], 5);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPSettingForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.