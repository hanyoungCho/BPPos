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
unit BPLaneControl.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Mask, Vcl.NumberBox,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages;

{$I ..\..\common\Common.BPCommon.inc}

const
  LC_COMMAND_MAX = 17;

type
  TLaneNoPanel = class(TPanel)
    StatusPanel: TPanel;
  private
    FLaneNo: ShortInt;
    FLaneStatus: Shortint;
    FSelected: Boolean;

    procedure SetLaneStatus(const AValue: Shortint);
    procedure SetSelected(const AValue: Boolean);
  public
    constructor Create(AOwner: TComponent; const AIndex: ShortInt; AParent: TWinControl); reintroduce;
    destructor Destroy; override;

    property LaneNo: Shortint read FLaneNo write FLaneNo default 0;
    property LaneStatus: Shortint read FLaneStatus write SetLaneStatus default 0;
    property Selected: Boolean read FSelected write SetSelected default False;
  end;

  TBPLaneControlForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    lblPluginVersion: TLabel;
    panMinimap: TPanel;
    panMain: TPanel;
    panBody: TPanel;
    btnClearSelectedLanes: TBitBtn;
    panSelectedLanes: TPanel;
    lblSelectedLanesTitle: TLabel;
    lblSelectedLanes: TLabel;
    panFooter: TPanel;
    btnApply: TBitBtn;
    btnCancel: TBitBtn;
    btnLaneControl1: TSpeedButton;
    btnLaneControl2: TSpeedButton;
    btnLaneControl3: TSpeedButton;
    btnLaneControl4: TSpeedButton;
    btnLaneControl5: TSpeedButton;
    btnLaneControl6: TSpeedButton;
    btnLaneControl7: TSpeedButton;
    btnLaneControl8: TSpeedButton;
    btnLaneControl9: TSpeedButton;
    btnLaneControl10: TSpeedButton;
    btnLaneControl11: TSpeedButton;
    btnLaneControl12: TSpeedButton;
    btnLaneControl13: TSpeedButton;
    btnLaneControl14: TSpeedButton;
    btnLaneControl15: TSpeedButton;
    btnLaneControl16: TSpeedButton;
    btnLaneControl17: TSpeedButton;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure OnLaneNoPanelClick(Sender: TObject);
    procedure btnClearSelectedLanesClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure OnLaneControlClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FWorking: Boolean;
    FBaseTitle: string;
    FButtonIndex: ShortInt;
    FLaneNoPanels: TArray<TLaneNoPanel>;
    FControlButtons: TArray<TSpeedButton>;

    procedure ProcessMessages(AMsg: TPluginMessage);

    procedure DoLaneControl;
    procedure DoLeagueMode(const AJobName: string; const ALeagueMode: Boolean);
    procedure DoGameNext(const AJobName: string);
    procedure DoInitLane(const AJobName: string);
    procedure DoPinSetterOnOff(const AJobName: string; const AValue: Boolean);
    procedure DoGameMonitorOnOff(const AJobName: string; const AValue: Boolean);
    procedure DoLaneCheckMode(const AJobName: string);
    procedure DoPinSettingType(const AJobName: string; const AValue: ShortInt);

    procedure SetBaseTitle(const AValue: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    property BaseTitle: string read FBaseTitle write SetBaseTitle;
  end;

var
  BPLaneControlForm: TBPLaneControlForm;
  FAssignList: TStringList;

implementation

uses
  { Native }
  Vcl.Graphics, Vcl.Dialogs, System.Math,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.BPMsgBox, Common.LayeredForm;

var
  LF: TLayeredForm;
  FSelectedLanes: TStringList;

{$R *.dfm}

{ TBPLaneControlForm }

constructor TBPLaneControlForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  I: ShortInt;
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
  LF := TLayeredForm.Create(nil);
  LF.Show;

  Global.Plugin.AssignGamePluginId := Self.PluginID;
  FOwnerId := 0;
  FButtonIndex := 0;
  FBaseTitle := panHeader.Caption;
  FSelectedLanes := TStringList.Create;
  FSelectedLanes.Delimiter := ',';

  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  panHeader.Caption := FBaseTitle;

  SetLength(FLaneNoPanels, Global.LaneInfo.LaneCount);
  for I := 0 to Pred(Global.LaneInfo.LaneCount) do
  begin
    FLaneNoPanels[I] := TLaneNoPanel.Create(nil, I, panMinimap);
    FLaneNoPanels[I].LaneNo := Global.LaneInfo.Lanes[I].LaneNo;
    FLaneNoPanels[I].LaneStatus := Global.LaneInfo.Lanes[I].LaneStatus;
    FLaneNoPanels[I].OnClick := OnLaneNoPanelClick;
  end;

  SetLength(FControlButtons, LC_COMMAND_MAX);
  for I := 0 to Pred(LC_COMMAND_MAX) do
  begin
    FControlButtons[I] := TSpeedButton(FindComponent('btnLaneControl' + Succ(I).ToString));
    FControlButtons[I].Tag := I;
    FControlButtons[I].OnClick := OnLaneControlClick;
  end;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPLaneControlForm.Destroy;
begin
  Global.Plugin.AssignGamePluginId := 0;
  LF.Release;

  inherited Destroy;
end;

procedure TBPLaneControlForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FSelectedLanes);
  for var I: ShortInt := 0 to High(FLaneNoPanels) do
    FLaneNoPanels[I].Free;
  Action := caFree;
end;

procedure TBPLaneControlForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPLaneControlForm.ProcessMessages(AMsg: TPluginMessage);
var
  LIndex, LStatus: ShortInt;
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
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
  end;
end;

procedure TBPLaneControlForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      Self.Close;
    VK_RETURN:
      btnApply.Click;
  end;
end;

procedure TBPLaneControlForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPLaneControlForm.OnLaneNoPanelClick(Sender: TObject);
begin
  with FLaneNoPanels[TPanel(sender).Tag] do
  try
    Selected := (not Selected);
    if Selected then
      FSelectedLanes.Add(LaneNo.ToString)
    else
      FSelectedLanes.Delete(FSelectedLanes.IndexOf(LaneNo.ToString))
  finally
    FSelectedLanes.CustomSort(StringListSortAsc);
    lblSelectedLanes.Caption := FSelectedLanes.DelimitedText;
  end;
end;

procedure TBPLaneControlForm.btnApplyClick(Sender: TObject);
begin
  if FWorking then
    Exit;
  FWorking := True;
  try
    if (FSelectedLanes.Count = 0) then
    begin
      BPMsgBox(Self.Handle, mtInformation, '�˸�', '���õ� ������ �����ϴ�.', ['Ȯ��'], 5);
      Exit;
    end;
    DoLaneControl;
  finally
    FWorking := False;
  end;
end;

procedure TBPLaneControlForm.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrYes;
end;

procedure TBPLaneControlForm.btnClearSelectedLanesClick(Sender: TObject);
begin
  for var I: ShortInt := 0 to High(FLaneNoPanels) do
    with TLaneNoPanel(FLaneNoPanels[I]) do
      if Selected then
        Selected := False;
  FSelectedLanes.Clear;
  lblSelectedLanes.Caption := '';
end;

procedure TBPLaneControlForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPLaneControlForm.OnLaneControlClick(Sender: TObject);
begin
  with TSpeedButton(Sender) do
  begin
    FButtonIndex := Tag;
    BaseTitle := '���� ���� �� ' + Caption;
  end;
end;

procedure TBPLaneControlForm.DoLaneControl;
var
  LJobName: string;
begin
  try
    if (FSelectedLanes.Count = 0) then
      raise Exception.Create('���õ� ������ �����ϴ�.');
    if not (FButtonIndex in [0..Pred(LC_COMMAND_MAX)]) then
      raise Exception.Create('ó���� �� ���� ���� ���� ����Դϴ�.');
    LJobName := FControlButtons[FButtonIndex].Caption;
    case FButtonIndex of
      0: //���� ����
        DoLeagueMode(LJobName, True);
      1: //���� ����
        DoLeagueMode(LJobName, False);
      2: //�Ϲ� ����
        ;
      3: //���� ����
        ;
      4: //���� �ؽ�Ʈ
        DoGameNext(LJobName);
      5: //���� �ʱ�ȭ
        DoInitLane(LJobName);
      6: //8�� ����
        ;
      7: //9�� ����
        ;
      8: //���̺� �̵�
        ;
      9: //���� �ڵ� �̵�
        ;
      10: //�� ���� On
        DoPinSetterOnOff(LJobName, True);
      11: //�� ���� Off
        DoPinSetterOnOff(LJobName, False);
      12: //����� On
        DoGameMonitorOnOff(LJobName, True);
      13: //����� Off
        DoGameMonitorOnOff(LJobName, False);
      14: //������ ǥ��
        DoLaneCheckMode(LJobName);
      15: //�� ���� 1
        DoPinSettingType(LJobName, 1);
      16: //�� ���� 2
        DoPinSettingType(LJobName, 2);
    end;
    SendToMainForm(CPC_GAME_REFRESH_FORCE);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
  end;
end;

procedure TBPLaneControlForm.DoLeagueMode(const AJobName: string; const ALeagueMode: Boolean);
var
  LLaneNo, LLaneIndex: ShortInt;
  LResMsg: string;
begin
  try
    if (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
          ErrorString(Format('<B>%s</B>', [FSelectedLanes.DelimitedText])) + ' ������ ' + ErrorString(Format('<B>%s</B>', [AJobName])) + ' ���� �����Ͻðڽ��ϱ�?' + _BR +
          '��� ������ ������ ������� �ʽ��ϴ�.', ['��', '�ƴϿ�']) <> mrOk) then
      Exit;

    for var I: ShortInt := 0 to Pred(FSelectedLanes.Count) do
    begin
      LLaneNo := FSelectedLanes[I].ToInteger;
      LLaneIndex := Global.LaneInfo.LaneIndex(LLaneNo);
      if (LLaneIndex = -1) or
         (Global.LaneInfo.Lanes[LLaneIndex].LaneStatus = CO_LANE_READY) then
        Continue;
      if not BPDM.SetLeagueMode(LLaneNo, ALeagueMode, LResMsg) then
        raise Exception.Create(LResMsg);
    end;
    BPMsgBox(Self.Handle, mtInformation, '�˸�', Format('%s ��� ������ �Ϸ��Ͽ����ϴ�.', [AJobName]), ['Ȯ��'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '�˸�', Format('%s ��� ���ۿ� �����Ͽ����ϴ�.', [AJobName]) + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;

procedure TBPLaneControlForm.DoGameNext(const AJobName: string);
var
  LLaneNo, LLaneIndex: ShortInt;
  LResMsg: string;
begin
  try
    if (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
          ErrorString(Format('<B>%s</B>', [FSelectedLanes.DelimitedText])) + ' ���ο� ' + ErrorString(Format('<B>%s</B>', [AJobName])) + ' ����� �����Ͻðڽ��ϱ�?' + _BR +
          '��� ������ ������ ������� �ʽ��ϴ�.', ['��', '�ƴϿ�']) <> mrOk) then
      Exit;

    for var I: ShortInt := 0 to Pred(FSelectedLanes.Count) do
    begin
      LLaneNo := FSelectedLanes[I].ToInteger;
      LLaneIndex := Global.LaneInfo.LaneIndex(LLaneNo);
      if (LLaneIndex = -1) or
         (Global.LaneInfo.Lanes[LLaneIndex].LaneStatus = CO_LANE_READY) then
        Continue;
      if not BPDM.SetGameNext(LLaneNo, LResMsg) then
        raise Exception.Create(LResMsg);
    end;
    BPMsgBox(Self.Handle, mtInformation, '�˸�', Format('%s ��� ������ �Ϸ��Ͽ����ϴ�.', [AJobName]), ['Ȯ��'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '�˸�', Format('%s ��� ���ۿ� �����Ͽ����ϴ�.', [AJobName]) + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;

procedure TBPLaneControlForm.DoInitLane(const AJobName: string);
var
  LLaneNo, LLaneIndex, LLaneStatus: ShortInt;
  LResMsg: string;
begin
  try
    if (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
          ErrorString(Format('<B>%s</B>', [FSelectedLanes.DelimitedText])) + ' ���ο� ' + ErrorString(Format('<B>%s</B>', [AJobName])) + ' ����� �����Ͻðڽ��ϱ�?' + _BR +
          '��� ������ ������ ������� �ʽ��ϴ�.', ['��', '�ƴϿ�']) <> mrOk) then
      Exit;

    for var I: ShortInt := 0 to Pred(FSelectedLanes.Count) do
    begin
      LLaneNo := FSelectedLanes[I].ToInteger;
      LLaneIndex := Global.LaneInfo.LaneIndex(LLaneNo);
      LLaneStatus := Global.LaneInfo.Lanes[LLaneIndex].LaneStatus;
      if (LLaneIndex = -1) or
         (LLaneStatus = CO_LANE_READY) then
        Continue;
      if (LLaneStatus = CO_LANE_HOLD) and
         (not BPDM.SetHoldLane(LLaneNo, False, LResMsg)) then
        raise Exception.Create(LResMsg);
      if not BPDM.InitLane(LLaneNo, LResMsg) then
        raise Exception.Create(LResMsg);
    end;
    BPMsgBox(Self.Handle, mtInformation, '�˸�', Format('%s ��� ������ �Ϸ��Ͽ����ϴ�.', [AJobName]), ['Ȯ��'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '�˸�', Format('%s ��� ���ۿ� �����Ͽ����ϴ�.', [AJobName]) + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;

procedure TBPLaneControlForm.DoPinSetterOnOff(const AJobName: string; const AValue: Boolean);
var
  LLaneNo, LLaneIndex: ShortInt;
  LResMsg: string;
begin
  try
    if (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
          ErrorString(Format('<B>%s</B>', [FSelectedLanes.DelimitedText])) + ' ���ο� ' + ErrorString(Format('<B>%s</B>', [AJobName])) + ' ����� �����Ͻðڽ��ϱ�?' + _BR +
          '��� ������ ������ ������� �ʽ��ϴ�.', ['��', '�ƴϿ�']) <> mrOk) then
      Exit;

    for var I: ShortInt := 0 to Pred(FSelectedLanes.Count) do
    begin
      LLaneNo := FSelectedLanes[I].ToInteger;
      LLaneIndex := Global.LaneInfo.LaneIndex(LLaneNo);
      if (LLaneIndex = -1) or
         (Global.LaneInfo.Lanes[LLaneIndex].LaneStatus = CO_LANE_READY) then
        Continue;
      if not BPDM.SetPinSetter(LLaneNo, AValue, LResMsg) then
        raise Exception.Create(LResMsg);
    end;
    BPMsgBox(Self.Handle, mtInformation, '�˸�', Format('%s ��� ������ �Ϸ��Ͽ����ϴ�.', [AJobName]), ['Ȯ��'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '�˸�', Format('%s ��� ���ۿ� �����Ͽ����ϴ�.', [AJobName]) + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;

procedure TBPLaneControlForm.DoGameMonitorOnOff(const AJobName: string; const AValue: Boolean);
var
  LLaneNo: ShortInt;
  LResMsg: string;
begin
  try
    if (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
          ErrorString(Format('<B>%s</B>', [FSelectedLanes.DelimitedText])) + ' ���ο� ' + ErrorString(Format('<B>%s</B>', [AJobName])) + ' ����� �����Ͻðڽ��ϱ�?',
          ['��', '�ƴϿ�']) <> mrOk) then
      Exit;

    for var I: ShortInt := 0 to Pred(FSelectedLanes.Count) do
    begin
      LLaneNo := FSelectedLanes[I].ToInteger;
      if not BPDM.SetGameMonitor(LLaneNo, AValue, LResMsg) then
        raise Exception.Create(LResMsg);
    end;
    BPMsgBox(Self.Handle, mtInformation, '�˸�', Format('%s ��� ������ �Ϸ��Ͽ����ϴ�.', [AJobName]), ['Ȯ��'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '�˸�', Format('%s ��� ���ۿ� �����Ͽ����ϴ�.', [AJobName]) + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;

procedure TBPLaneControlForm.DoLaneCheckMode(const AJobName: string);
var
  LLaneNo, LLaneIndex: ShortInt;
  LLockMode: Boolean;
  LResMsg: string;
begin
  try
    if (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
          ErrorString(Format('<B>%s</B>', [FSelectedLanes.DelimitedText])) + ' ���ο� ' + ErrorString(Format('<B>%s</B>', [AJobName])) + ' ����� �����Ͻðڽ��ϱ�?' + _BR +
          '���� ǥ�� ���� ������ ���� ���� ���·� ����ǰ�' + _BR + '���� ���°� �ƴ� ������ ���� ���·� ��ȯ�˴ϴ�.', ['��', '�ƴϿ�']) <> mrOk) then
      Exit;

    for var I: ShortInt := 0 to Pred(FSelectedLanes.Count) do
    begin
      LLaneNo := FSelectedLanes[I].ToInteger;
      LLaneIndex := Global.LaneInfo.LaneIndex(LLaneNo);
      if (LLaneIndex = -1) then
        Continue;
      LLockMode := (Global.LaneInfo.Lanes[LLaneIndex].LaneStatus = CO_LANE_MAINTENANCE);
      if not BPDM.SetMaintenanceLane(LLaneNo, (not LLockMode), LResMsg) then
        raise Exception.Create(LResMsg);
    end;
    BPMsgBox(Self.Handle, mtInformation, '�˸�', Format('%s ��� ������ �Ϸ��Ͽ����ϴ�.', [AJobName]), ['Ȯ��'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '�˸�', Format('%s ��� ���ۿ� �����Ͽ����ϴ�.', [AJobName]) + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;

procedure TBPLaneControlForm.DoPinSettingType(const AJobName: string; const AValue: ShortInt);
var
  LLaneNo: ShortInt;
  LResMsg: string;
begin
  try
    if (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��',
          ErrorString(Format('<B>%s</B>', [FSelectedLanes.DelimitedText])) + ' ���ο� ' + ErrorString(Format('<B>%s</B>', [AJobName])) + ' ����� �����Ͻðڽ��ϱ�?',
          ['��', '�ƴϿ�']) <> mrOk) then
      Exit;

    for var I: ShortInt := 0 to Pred(FSelectedLanes.Count) do
    begin
      LLaneNo := FSelectedLanes[I].ToInteger;
      if not BPDM.SetPinSettingType(LLaneNo, AValue, LResMsg) then
        raise Exception.Create(LResMsg);
    end;
    BPMsgBox(Self.Handle, mtInformation, '�˸�', Format('%s ��� ������ �Ϸ��Ͽ����ϴ�.', [AJobName]), ['Ȯ��'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '�˸�', Format('%s ��� ���ۿ� �����Ͽ����ϴ�.', [AJobName]) + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
  end;
end;

procedure TBPLaneControlForm.SetBaseTitle(const AValue: string);
begin
  if (FBaseTitle <> AValue) then
  begin
    FBaseTitle := AValue;
    panHeader.Caption := FBaseTitle;
  end;
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

procedure TLaneNoPanel.SetSelected(const AValue: Boolean);
begin
  if (FSelected <> AValue) then
  begin
    FSelected := AValue;
    if FSelected then
      Color := CO_COLOR_LANE_NO_SELECT
    else
      Color := CO_COLOR_LANE_NO_NORMAL;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPLaneControlForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.
