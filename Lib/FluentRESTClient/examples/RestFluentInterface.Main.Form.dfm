object FluentRestClientForm: TFluentRestClientForm
  Left = 0
  Top = 0
  Caption = 'Fluent REST Client Interface API Demo'
  ClientHeight = 519
  ClientWidth = 812
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    812
    519)
  PixelsPerInch = 96
  TextHeight = 16
  object PraxysSimpleButton: TButton
    Left = 8
    Top = 150
    Width = 120
    Height = 25
    Caption = 'Praxys JSON'
    TabOrder = 4
    OnClick = PraxysSimpleButtonClick
  end
  object ResponseMemo: TMemo
    Left = 134
    Top = 8
    Width = 670
    Height = 503
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 6
  end
  object PraxysObjectListButton: TButton
    Left = 8
    Top = 181
    Width = 120
    Height = 25
    Caption = 'Praxys ObjectList'
    TabOrder = 5
    OnClick = PraxysObjectListButtonClick
  end
  object FormatJsonCheckBox: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Format JSON'
    TabOrder = 0
  end
  object SimpleJsonEchoButton: TButton
    Left = 8
    Top = 79
    Width = 120
    Height = 25
    Caption = 'JSON Echo'
    TabOrder = 2
    OnClick = SimpleJsonEchoButtonClick
  end
  object JsonEchoParamsButton: TButton
    Left = 8
    Top = 110
    Width = 120
    Height = 25
    Caption = 'JSON Echo Params'
    TabOrder = 3
    OnClick = JsonEchoParamsButtonClick
  end
  object WhatIsMyIpButton: TButton
    Left = 8
    Top = 31
    Width = 120
    Height = 25
    Caption = 'What is my IP?'
    TabOrder = 1
    OnClick = WhatIsMyIpButtonClick
  end
end
