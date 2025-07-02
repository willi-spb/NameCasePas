unit fm_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  u_namecasepas, Vcl.ExtCtrls;

type
  TFormDR = class(TForm)
    edtName: TEdit;
    btnStart: TBitBtn;
    mmoResult: TMemo;
    btnClear: TBitBtn;
    btnFemale: TBitBtn;
    rg_gender: TRadioGroup;
    rg_FIO: TRadioGroup;
    procedure btnStartClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnFemaleClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDR: TFormDR;

  NC:TNameCase;

implementation

{$R *.dfm}



procedure TFormDR.btnClearClick(Sender: TObject);
begin
 edtName.Clear;
end;

procedure TFormDR.btnFemaleClick(Sender: TObject);
begin
 // mmoResult.Lines.Add('name= '+NC.GetFirstName('Павел',CASE_DATIVE,1));
 edtName.Text:=rg_FIO.Items[rg_FIO.ItemIndex];
end;

procedure TFormDR.btnStartClick(Sender: TObject);
var SL: TStringList;
  fullname: String;
  L_sex:integer;
begin
  SL := TStringList.Create;
  try
      SL.Delimiter:=' ';
      SL.Delimitedtext:=Trim(edtName.Text);
      caption:=SL[0];

      L_sex:=rg_gender.ItemIndex;
      fullname:= NC.GetLastName(SL[0],CASE_DATIVE,L_sex);
      fullname:= fullname+' '+ NC.GetFirstName(SL[1],CASE_DATIVE,L_sex);
      fullname:= fullname+' '+ NC.GetMiddleName(SL[2],CASE_DATIVE,L_sex);
      mmoResult.Lines.Add(fullname);

      fullname:= NC.GetLastName(SL[0],CASE_GENITIVE,L_sex);
      fullname:= fullname+' '+ NC.GetFirstName(SL[1],CASE_GENITIVE,L_sex);
      fullname:= fullname+' '+ NC.GetMiddleName(SL[2],CASE_GENITIVE,L_sex);
      mmoResult.Lines.Add(fullname);

      fullname:= NC.GetLastName(SL[0],CASE_ACCUSATIVE,L_sex);
      fullname:= fullname+' '+ NC.GetFirstName(SL[1],CASE_ACCUSATIVE,L_sex);
      fullname:= fullname+' '+ NC.GetMiddleName(SL[2],CASE_ACCUSATIVE,L_sex);
      mmoResult.Lines.Add(fullname);

      fullname:= NC.GetLastName(SL[0],CASE_INSTRUMENTAL,L_sex);
      fullname:= fullname+' '+ NC.GetFirstName(SL[1],CASE_INSTRUMENTAL,L_sex);
      fullname:= fullname+' '+ NC.GetMiddleName(SL[2],CASE_INSTRUMENTAL,L_sex);
      mmoResult.Lines.Add(fullname);

      fullname:= NC.GetLastName(SL[0],CASE_PREPOSITIONAL,L_sex);
      fullname:= fullname+' '+ NC.GetFirstName(SL[1],CASE_PREPOSITIONAL,L_sex);
      fullname:= fullname+' '+ NC.GetMiddleName(SL[2],CASE_PREPOSITIONAL,L_sex);
      mmoResult.Lines.Add(fullname);
  finally
    SL.Free;
  end;
end;

procedure TFormDR.FormShow(Sender: TObject);
begin
  NC := TNameCase.Create;
end;

end.
