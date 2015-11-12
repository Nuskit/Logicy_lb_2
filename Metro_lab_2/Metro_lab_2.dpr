program Metro_lab_2;

uses
  Forms,
  UMain in 'UMain.pas' {FMain},
  Uwork_with_text in 'Uwork_with_text.pas',
  UAnalyze_text in 'UAnalyze_text.pas',
  UChain_operator in 'UChain_operator.pas',
  UConstant in 'UConstant.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
