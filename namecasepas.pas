
unit u_namecasepas;


//  основа - Библиотека Петрович
//  https://github.com/petrovich/petrovich-rules

{Сopyright (c) 2024 Anton Lindeberg

https://github.com/WAYFARER87/NameCasePas

Склонение падежей русских имён, фамилий и отчеств для Pascal/Delphi
Библиотека использует набор правил от небезызвестной ruby библиотеки Petrovich (https://github.com/petrovich/petrovich-rules)

Вообще ничего не работало нормально после перевода на Delphi XE:
1. Почему-то в вызове отрубающей символы функции были перепутаны аргументы
2. Нет обработки исключений - типа имени Павел - хотя этот раздел в файле данных есть
3. Файл данных нужно подключать через ресурсы приложения...
4. Гендер как правило задается извне - важен случай с женскими ФИО

В итоге я поправил эти моменты + добавил проверку для несклоняемых Женских фамилий
 }

interface

uses
  Classes, SysUtils, System.JSON, System.JSONConsts, StrUtils, Dialogs;

type


  { TNameCase }


  TNameCase = class

  private
    middlename, firstname, lastname, gender: string;
    rules: TJSONObject;

    function inflect(Name: string; aCase: integer; ruleType: string; aGender:integer): string;
    function findInRules(Name: string; aCase: integer; ruleType: string; aGender:integer): string;
  public
    constructor Create;

    function GetFirstName(AFirstName: string; ACase,aGender: integer): string;
    function GetLastName(ALastName: string; ACase,aGender: integer): string;
    function GetMiddleName(AMiddleName: string; ACase,aGender: integer): string;
    function GetGender:String;
    ///
    function femaleFamilyIsConstant(const aFam:string):Boolean;
  end;

const
  CASE_DATIVE = 0; //родительный

const
  CASE_GENITIVE = 1; //дательный

const
  CASE_ACCUSATIVE = 2; //винительный

const
  CASE_INSTRUMENTAL = 3; //творительный

const
  CASE_PREPOSITIONAL = 4; //предложный

implementation

  uses System.IOUtils;

{ TCaseName }

constructor TNameCase.Create;
var L_HistRes:TResourceStream;
    L_Str:TStringStream;
begin
{  JSONParser := TJSONParser.Create(TFileStream.Create(ExtractFilePath(ParamStr(0)) +
    'rules.js', fmOpenRead));
 }
    L_HistRes:=TResourceStream.Create(HInstance,'ResJS','DAT');
    L_Str:=TStringStream.Create;
   try
    if L_HistRes<>nil then
     begin
      L_HistRes.Seek(0,0);
      if (L_HistRes.Size>0) then
       begin
        L_Str.LoadFromStream(L_HistRes);
        rules:=TJSONObject.ParseJSONValue(L_Str.DataString) as TJSONObject;
       end;
     end;
    finally
     L_HistRes.Free;
     L_Str.Free;
   end;

//  rules:=TJSONObject.ParseJSONValue(TFile.ReadAllText(TPath.Combine(ExtractFilePath(ParamStr(0)),'rules.js'))) as TJSONObject;
end;

function TNameCase.GetFirstName(AFirstName: string; ACase,aGender: integer): string;
begin
     { $this->firstname = $firstname;
        return $this->inflect($this->firstname,$case,__FUNCTION__);  }
  self.firstname := AFirstName;
  Result := inflect(firstname, ACase, 'firstname',aGender);
end;

function TNameCase.GetLastName(ALastName: string; ACase,aGender: integer): string;
begin
   self.lastname := ALastName;
   if (aGender=2) and (femaleFamilyIsConstant(AnsiLowerCase(ALastName))=True) then
       Result:=ALastName
   else
       Result := inflect(lastname, ACase, 'lastname',aGender);
end;

function TNameCase.GetMiddleName(AMiddleName: string; ACase,aGender: integer): string;
begin
   self.lastname := AMiddleName;
   Result := inflect(lastname, ACase, 'middlename',aGender);
end;

function TNameCase.GetGender: String;
begin
  Result:=gender;
end;

function CountChar(const str: string; const chr: char): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 1 to Length(str) do
    if str[i] = chr then
      Inc(Result);
end;
 (*
{ private function inflect($name,$case,$type) {
          //если двойное имя или фамилия или отчество
        if(substr_count($name,'-') > 0) {
            $names_arr = explode('-',$name);
            $result = '';

            foreach($names_arr as $arr_name) {
                $result .= $this->findInRules($arr_name,$case,$type).'-';
            }
            return substr($result,0,strlen($result)-1);
        } else {
            return $this->findInRules($name,$case,$type);
        }
    }}
   *)


function TNameCase.inflect(Name: string; aCase: integer; ruleType: string; aGender:integer): string;
var
  nameArr: TStringList;
  i: integer;
  res: string;
begin
  if CountChar(Name, '-') > 0 then
  begin
    nameArr := TStringList.Create;
    try
      nameArr.DelimitedText := Name;
      res := '';
      for i := 0 to nameArr.Count - 1 do
        res := res + findInRules(nameArr[i], aCase, ruleType,aGender) + '-';
      Result := Copy(res, 1, Length(res) - 1);
    finally
      nameArr.Free;
    end;
  end
  else
    Result := findInRules(Name, aCase, ruleType,aGender);

end;
 (*
{  foreach($this->rules[$type]->suffixes as $rule) {
            foreach($rule->test as $last_char) {
                $last_name_char = substr($name,strlen($name)-strlen($last_char),strlen($last_char));
                if($last_char == $last_name_char) {
                    if($rule->mods[$case] == '.')
                        continue;

                    if($this->gender == 'androgynous' || $this->gender == null)
                        $this->gender = $rule->gender;

                    return $this->applyRule($rule->mods,$name,$case);
                }
            }
        }}
   *)

function getGenderStr(aGender:Integer):string;
  begin
    case aGender of
     1: Result:='male';
     2: Result:='female';
     else Result:='androgynous';
    end;
  end;

function substr_count(const substr: string; Str: string): integer;
begin
  if (Length(substr) = 0) or (Length(Str) = 0) or (AnsiPos(substr, Str) = 0) then
    Result := 0
  else
    Result := (Length(Str) - Length(StringReplace(Str, substr, '', [rfReplaceAll]))) div
      Length(substr);
end;

function applyRule(Mods, Name: string; aCase: integer): string;
var
  res: string;
begin
  res := Copy(Name, 1, Length(Name) - substr_count('-',Mods));
  res := res + StringReplace(Mods, '-', '', [rfReplaceAll]);
  Result := res;
end;


function findInArray(const aName:string; aAr:TJSONArray; aCase: integer; ruleType: string; aGender:integer; aSectSign:integer):string;
var
  L_suffItem,L_charItem:TJSONValue;
  last_char,L_mods: TJSONArray;
  L_charV, L_GenderS, last_name_char, L_Jgender: string;
begin
  Result:='';
  L_GenderS:=getGenderStr(aGender);
  for L_suffItem in aAr do
      begin
        last_char := TJsonObject(L_suffItem).GetValue('test') as TJSONArray;
        L_Jgender :=TJsonObject(L_suffItem).GetValue('gender').Value;
        if (aGender<=0) or (SameText(L_Jgender,'androgynous')) or (SameText(L_Jgender,L_GenderS)) then
            for L_charItem in last_char do
             begin
               L_charV:=L_charItem.Value;
               if aSectSign=1 then
                  last_name_char := Copy(aName, Length(aName) - Length(L_charV) +1, Length(L_charV))
               else
                  last_name_char :=AnsiLowerCase(aName);
               //last_name_char = substr($name,strlen($name)-strlen($last_char),strlen($last_char));
               if (L_charV = last_name_char) then
                  begin
                    L_mods:=TJsonObject(L_suffItem).GetValue('mods') as TJSONArray;
                    if L_mods.Items[aCase].Value<>'.' then
                     begin
                       Result := applyRule(L_mods.Items[aCase].Value, aName, aCase);
                     end;
                  end;
             end;
      end;
end;



function TNameCase.femaleFamilyIsConstant(const aFam: string): Boolean;
begin
// Некоторые женские фамилии, которые не склоняются в русском языке:
// Все фамилии, оканчивающиеся на согласный. Например: речь Анналены Бербок, награда Ирине Круг, знакомство с Галиной Короткевич, статья Марии Каленчук, приёмный день у Ольги Стародуб, контрольная работа Изабеллы Агаджанян.
// Фамилии, которые оканчиваются на гласные е, и, о, у, ы, э, ю. Это правило действует для всех фамилий, независимо от их происхождения. Например: труды Антуана Мейе, опера Гретри, высказывание Матвиенко, улица Гримау.
// Фамилии, заканчивающиеся на -ч. Например: Ковач, Торопич, Дывыдович.
// Фамилии, если они совпадают с нарицательными словами или географическими названиями. Например: Соловей, Дрозд, Нева.
 Result:=False;
 if Length(aFam)>0 then
  if AnsiPos(aFam[Length(aFam)],'бвгджзйклмнпрстфхцчьыъ')>0 then Result:=True
  else
     if AnsiPos(aFam[Length(aFam)],'еиоуыэю')>0 then Result:=True
     else
      with TStringList.Create do
       try
        StrictDelimiter:=False;
        CommaText:='москва,нева,правда,свобода,коза';
        Result:=(IndexOf(aFam)>=0);
        finally
         Free;
      end;
end;

function TNameCase.findInRules(Name: string; aCase: integer; ruleType: string; aGender:integer): string;
var
  L_sect:TJSONObject;
  L_Array: TJSONArray;
begin
  Result:='';
  L_sect:=rules.GetValue(ruleType) as TJSONObject;
  L_Array:=L_sect.GetValue('exceptions') as TJSONArray;
  if L_Array<>nil then
     Result:=findInArray(Name,L_Array,aCase,ruleType,aGender,2);
  if Length(Result)=0 then
   begin
     L_Array:=L_sect.GetValue('suffixes') as TJSONArray;
     Result:=findInArray(Name,L_Array,aCase,ruleType,aGender,1);
   end;
end;

end.
