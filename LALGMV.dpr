program LALGMV;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UAbout in 'UAbout.pas' {FSobre};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFSobre, FSobre);
  Application.Run;
end.
