unit UAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, JvExExtCtrls, JvImage;

type
  TFSobre = class(TForm)
    Button1: TButton;
    JvImage1: TJvImage;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSobre: TFSobre;

implementation

{$R *.dfm}

procedure TFSobre.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
