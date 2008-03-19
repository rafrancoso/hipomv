unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExStdCtrls, JvListComb, Mask, 
  ImgList, StrUtils, Math, Buttons, ExtCtrls, ActnList,
  XPStyleActnCtrls, ActnMan, ToolWin, ActnCtrls, DateUtils, Grids, ValEdit;

type
  TForm1 = class(TForm)
    ADados: TJvImageListBox;
    Label1: TLabel;
    ImageList1: TImageList;
    Label3: TLabel;
    FSaida: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    FEntrada: TEdit;
    Label6: TLabel;
    ActionToolBar1: TActionToolBar;
    ActionManager1: TActionManager;
    acAbrir: TAction;
    acStep: TAction;
    acExecutarTudo: TAction;
    acReset: TAction;
    acFechar: TAction;
    OpenDialog1: TOpenDialog;
    PnMensagem: TPanel;
    Label2: TLabel;
    PDados: TValueListEditor;
    acSobre: TAction;
    procedure acAbrirExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ADadosClick(Sender: TObject);
    procedure PDados2DrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure acStepExecute(Sender: TObject);
    procedure acExecutarTudoExecute(Sender: TObject);
    procedure acResetExecute(Sender: TObject);
    procedure acFecharExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure acSobreExecute(Sender: TObject);
  private
    FProgramCounter: integer;
    procedure SetProgramCounter(const Value: integer);
    procedure ResetLalgMV(AName: string);
    { Private declarations }
  public
    { Public declarations }
    property ProgramCounter:integer read FProgramCounter write SetProgramCounter;
    procedure pilhaPush(aValor:string);
    function pilhaValor(aIndex:integer):string;
    procedure pilhaValorSet(aValor,aIndex:integer);
    procedure FetchInstrucao(aLinha: string);
    function pilhaPop:string;
    function LeFitadeEntrada:string;
    procedure EscreveFitaSaida(aValor:string);
  end;

var
  Form1: TForm1;

implementation

uses UAbout;

{$R *.dfm}

procedure TForm1.acAbrirExecute(Sender: TObject);
begin
  if  OpenDialog1.Execute  then
  begin
      ResetLalgMV(OpenDialog1.FileName);
      PnMensagem.Caption := '';
  end;

end;

procedure TForm1.acExecutarTudoExecute(Sender: TObject);
begin
  if ADados.Items.Count < 1 then
  begin
    PnMensagem.Caption :='Programa não carregado ou inválido';
    exit;
  end;

  ResetLalgMV('');
  PnMensagem.Caption := 'Executando Programa';
  while ProgramCounter <> -1 do
    FetchInstrucao(ADados.Items[ProgramCounter].Text);

  PnMensagem.Caption := 'Execução completa';
end;

procedure TForm1.acFecharExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.acResetExecute(Sender: TObject);
begin
  ResetLalgMV('');
  PnMensagem.Caption:='Resetado';
end;

procedure TForm1.acSobreExecute(Sender: TObject);
var formSobre:TFSobre;
begin
  formSobre:=TFSobre.Create(nil);
  try
    formSobre.ShowModal;
  finally
    FreeAndNil(formSobre);
  end;
end;

procedure TForm1.acStepExecute(Sender: TObject);
begin
  if ADados.Items.Count < 1 then
  begin
    PnMensagem.Caption :='Programa não carregado ou inválido';
    exit;
  end;

  if ProgramCounter <> -1 then
  begin
    PnMensagem.Caption :='Executando Passo-a-Passo';
    FetchInstrucao(ADados.Items[ProgramCounter].Text)
  end else
     PnMensagem.Caption :='Programa encerrado, Resete-o antes de começar novamente';
end;

procedure TForm1.ADadosClick(Sender: TObject);
begin
  caption:=inttostr(ADados.ItemIndex);
end;

procedure TForm1.EscreveFitaSaida(aValor: string);
begin
//
end;

procedure TForm1.ResetLalgMV(AName: string);
var
  ind: Integer;
  sl: TStringList;
  i: Integer;
begin
  PDados.Strings.Text :='';
  ProgramCounter := 0;
  FSaida.Text := '';
  if AName <> '' then
  begin
    ADados.Items.Clear;  
    sl := TStringList.Create;
    sl.LoadFromFile(AName);
    for i := 0 to sl.Count - 1 do
    begin
      ind := ADados.Items.AddText(sl[i]);
      if pos('ALME', sl[i]) > 0 then
        ADados.Items[ind].ImageIndex := 0;
      if pos('DSVI', sl[i]) > 0 then
        ADados.Items[ind].ImageIndex := 1;
      if pos('CRVL', sl[i]) > 0 then
        ADados.Items[ind].ImageIndex := 2;
    end;
  end;
end;

procedure TForm1.FetchInstrucao(aLinha: string);
var aInstr:string;
    aValor,VlTopo:integer;
begin
  aInstr:=aLinha;
  if pos(' ',aLinha)>0 then
  begin
    aInstr:=Copy(aLinha,0,pos(' ',aLinha)-1);
    aValor:=StrToInt(trim(Copy(aLinha,Pos(' ',aLinha)+1,length(aLinha))));
  end;

  case AnsiIndexStr(aInstr,['','CRCT','CRVL','SOMA','SUBT','MULT'
                              ,'DIVI','INVE','CONJ','DISJ',''
                              ,'CPME','CPMA','','',''
                              ,'','ARMZ','DSVI','DSVF','LEIT'
                              ,'IMPR','ALME','INPP','PARA','COPVL'
                              ,'PARAM','PUSHER','CHPR','DESM','RTPR']) of
   1:begin
       pilhaPush(IntToStr(aValor));//CRCT
       ProgramCounter:=ProgramCounter+1;
     end;
   2:begin
       pilhaPush(pilhaValor(aValor));
       ProgramCounter:=ProgramCounter+1;
     end;
   3:begin
       pilhaPush(IntToStr(StrToInt(pilhaPop) + StrToInt(pilhaPop) ));
       ProgramCounter:=ProgramCounter+1;
     end;
   4:begin
       VlTopo:= StrToInt(pilhaPop);
       pilhaPush(IntToStr(StrToInt(pilhaPop) - VlTopo));
       ProgramCounter:=ProgramCounter+1;
     end;
   5:begin // MULT
       pilhaPush(IntToStr(StrToInt(pilhaPop) * StrToInt(pilhaPop) ));
       ProgramCounter:=ProgramCounter+1;
     end;
   6:begin // DIVI
       VlTopo:= StrToInt(pilhaPop);
       pilhaPush(FloatToStr(StrToInt(pilhaPop) / VlTopo));
       ProgramCounter:=ProgramCounter+1;
     end;
   7:begin //INVE
       pilhaPush(IntToStr(-StrToInt(pilhaPop)));
       ProgramCounter:=ProgramCounter+1;
     end;
   8:begin // CONJ
       pilhaPush(ifThen((pilhaPop = '1') and (pilhaPop = '1'),'1','0'));
       ProgramCounter:=ProgramCounter+1;
     end;
   9:begin // DISJ
       pilhaPush(ifThen((pilhaPop = '1') or (pilhaPop = '1'),'1','0'));
       ProgramCounter:=ProgramCounter+1;
     end;
   11:begin // CPME
       pilhaPush(ifThen(StrToInt(pilhaPop ) <= StrToInt(pilhaPop),'1','0'));
       ProgramCounter:=ProgramCounter+1;
     end;
   12:begin // CPMA
       pilhaPush(ifThen(StrToInt(pilhaPop) < StrToInt(pilhaPop),'1','0'));
       ProgramCounter:=ProgramCounter+1;
     end;
   17:begin // ARMZ
       pilhaValorSet(StrToInt(pilhaPop),aValor);
       ProgramCounter:=ProgramCounter+1;
     end;
   18:begin // DSVI
        ProgramCounter := aValor;
      end;
   19:begin // DSVF
        ProgramCounter := IfThen(pilhaPop = '1',ProgramCounter+1,aValor);
      end;
   20:begin // LEIT
        aValor:=StrToInt(LeFitadeEntrada);
        pilhaPush(IntToStr(aValor));
        ProgramCounter := ProgramCounter +1;
      end;
   21:begin // IMPR
        FSaida.Text := FSaida.Text + pilhaPop;
        ProgramCounter := ProgramCounter +1;
      end;
   22:begin // ALME
        pilhaPush('');
        ProgramCounter := ProgramCounter +1;
      end;
   23:begin // INPP
        ProgramCounter := ProgramCounter +1;
      end;
   24:begin // PARA
        ProgramCounter := -1;
      end;
   25:begin // COPVL
        ProgramCounter := ProgramCounter +1;
      end;
   26:begin // PARAM
        pilhaPush(pilhaValor(aValor));
        ProgramCounter := ProgramCounter +1;
      end;
   27:begin // PUSHER
        pilhaPush(IntToStr(aValor));
        ProgramCounter := ProgramCounter +1;
      end;
   28:begin // CHPR
        ProgramCounter := aValor -1;
      end;
   29:begin // DESM
        VlTopo := 0;
        repeat
          pilhaPop;
          inc(VlTopo);
        until VlTopo = aValor;
        ProgramCounter := ProgramCounter + 1;
      end;
   30:begin // RPTR
        ProgramCounter := StrToInt(pilhaPop);
      end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ResetLalgMV('');
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if key = Ord('E') then
  begin
    if ssCtrl in Shift then
       FEntrada.SetFocus;
  end;

  if key = Ord('S') then
  begin
    if ssCtrl in Shift then
       FSaida.SetFocus;
  end;

  if key = Ord('L') then
  begin
    if ssCtrl in Shift then
       FSaida.Text := '';
  end;

end;

function TForm1.LeFitadeEntrada: string;
var tmp:string;
begin
  if Trim(FEntrada.Text) = '' then
  begin// fita vazia
     result := '-1';
     exit;
  end;
  if pos(';',FEntrada.Text) = 0 then
  begin// se só tiver um número
    result:=FEntrada.Text;
    FEntrada.Text := '';
    exit;
  end;
  // se tiver mais de um número
  result := copy(FEntrada.Text,0,pos(';',FEntrada.Text)-1);
  FEntrada.Text := Copy(FEntrada.Text, pos(';',FEntrada.Text)+1,length(FEntrada.Text));
end;

procedure TForm1.PDados2DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
{  PDados.Canvas.Brush.Color:= clMoneyGreen;
  Pdados.Canvas.Pen.Color:= clMoneyGreen;
  PDados.Canvas.Rectangle(Rect);
  PDados.Canvas.TextOut(rect.Left, Rect.Top,PDados.Items[index]);}
end;

function TForm1.pilhaPop: string;
begin
  if PDados.RowCount > 0 then
  begin
    result := PDados.Values[inttostr(PDados.Strings.Count-1)];
    PDados.DeleteRow(PDados.RowCount-1);
  end else result:='-1';

end;

procedure TForm1.pilhaPush(aValor: string);
begin
  if aValor = '' then
     aValor := ' ';
  PDados.InsertRow(inttostr(PDados.Strings.Count),aValor,true)
end;

function TForm1.pilhaValor(aIndex: integer): string;
begin
  result:=PDados.Values[inttostr(aIndex)];
end;

procedure TForm1.pilhaValorSet(aValor, aIndex: integer);
begin
  PDados.Values[inttostr(aIndex)]:=inttostr(aValor);
end;

procedure TForm1.SetProgramCounter(const Value: integer);
begin
  FProgramCounter := Value;
  label4.Caption:= 'PC: '+inttostr(value);
  ADados.ItemIndex := Value;
end;

end.
