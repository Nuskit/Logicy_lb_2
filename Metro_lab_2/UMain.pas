unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFMain = class(TForm)
    Memo_plaintext: TMemo;
    Memo_rezult: TMemo;
    Button_open: TButton;
    Open_file_dialog: TOpenDialog;
    Button_start_analyze: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button_openClick(Sender: TObject);
    procedure Button_start_analyzeClick(Sender: TObject);
  private
    { Private declarations }
  public
    plaintext:string;
  end;

var
  FMain: TFMain;

implementation

{$R *.dfm}

uses Uwork_with_text,UAnalyze_text;

procedure TFMain.FormCreate(Sender: TObject);
begin
  plaintext:='';
end;

procedure TFMain.Button_openClick(Sender: TObject);
begin
  if Open_file_dialog.Execute then
    Memo_plaintext.Lines.LoadFromFile(Open_file_dialog.FileName);
end;

procedure TFMain.Button_start_analyzeClick(Sender: TObject);
begin
  plaintext:='';
  Prepare_plaintext(plaintext);
  Analyze_text(plaintext);
  plaintext:='';
end;

end.
