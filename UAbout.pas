unit UAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, JvExExtCtrls, JvImage, ImgList,
  JvExControls, JvaScrollText, JvScrollText, JvPoweredBy;

type
  TFSobre = class(TForm)
    Fechar: TButton;
    JvImage1: TJvImage;
    Timer1: TTimer;
    Memo1: TMemo;
    JvPoweredByJVCL1: TJvPoweredByJVCL;
    procedure FecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSobre: TFSobre;

implementation

{$R *.dfm}

procedure TFSobre.FecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFSobre.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=true;
end;

procedure TFSobre.FormDestroy(Sender: TObject);
begin
  DoubleBuffered:=false;
end;

end.
