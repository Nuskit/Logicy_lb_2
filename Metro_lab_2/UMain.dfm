object FMain: TFMain
  Left = 6
  Top = 5
  Width = 1090
  Height = 736
  Caption = 'Metrology'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo_plaintext: TMemo
    Left = 0
    Top = 40
    Width = 297
    Height = 593
    Lines.Strings = (
      #1048#1089#1093#1086#1076#1085#1099#1081' '#1090#1077#1082#1089#1090'.'
      '')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Memo_rezult: TMemo
    Left = 304
    Top = 40
    Width = 329
    Height = 633
    Lines.Strings = (
      #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1088#1072#1073#1086#1090#1099'.'
      '')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Button_open: TButton
    Left = 24
    Top = 0
    Width = 273
    Height = 41
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083'..'
    TabOrder = 2
    OnClick = Button_openClick
  end
  object Button_start_analyze: TButton
    Left = 304
    Top = 0
    Width = 329
    Height = 41
    Caption = #1040#1085#1072#1083#1080#1079#1080#1088#1086#1074#1072#1090#1100' '#1090#1077#1082#1089#1090
    TabOrder = 3
    OnClick = Button_start_analyzeClick
  end
  object Open_file_dialog: TOpenDialog
  end
end
