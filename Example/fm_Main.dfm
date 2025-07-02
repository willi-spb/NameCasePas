object FormDR: TFormDR
  Left = 0
  Top = 0
  Caption = 'FormDR'
  ClientHeight = 580
  ClientWidth = 823
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object edtName: TEdit
    Left = 56
    Top = 40
    Width = 409
    Height = 21
    TabOrder = 0
    Text = #1044#1103#1090#1083#1086#1074' '#1055#1072#1074#1077#1083' '#1041#1086#1088#1080#1089#1086#1074#1080#1095
  end
  object btnStart: TBitBtn
    Left = 56
    Top = 67
    Width = 75
    Height = 25
    Caption = 'btnStart'
    TabOrder = 1
    OnClick = btnStartClick
  end
  object mmoResult: TMemo
    Left = 16
    Top = 232
    Width = 537
    Height = 313
    TabOrder = 2
  end
  object btnClear: TBitBtn
    Left = 216
    Top = 67
    Width = 75
    Height = 25
    Caption = 'btnClear'
    TabOrder = 3
    OnClick = btnClearClick
  end
  object btnFemale: TBitBtn
    Left = 496
    Top = 24
    Width = 75
    Height = 25
    Caption = 'btnFemale'
    TabOrder = 4
    OnClick = btnFemaleClick
  end
  object rg_gender: TRadioGroup
    Left = 320
    Top = 67
    Width = 185
    Height = 105
    Caption = #1055#1086#1083
    ItemIndex = 1
    Items.Strings = (
      #1083#1102#1073#1086#1081
      #1084#1091#1078#1095#1080#1085#1072
      #1078#1077#1085#1097#1080#1085#1072)
    TabOrder = 5
  end
  object rg_FIO: TRadioGroup
    Left = 521
    Top = 55
    Width = 256
    Height = 74
    Caption = #1055#1088#1080#1084#1077#1088#1099
    ItemIndex = 0
    Items.Strings = (
      #1050#1072#1088#1072#1075#1086#1079#1080#1085#1072' '#1040#1085#1075#1077#1083#1080#1085#1072' '#1060#1080#1083#1080#1087#1087#1086#1074#1085#1072
      #1050#1086#1075#1072#1085' '#1069#1083#1100#1074#1080#1088#1072' '#1040#1073#1076#1091#1083#1083#1072#1077#1074#1085#1072)
    TabOrder = 6
  end
end
