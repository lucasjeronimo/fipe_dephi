object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Consulta FIPE'
  ClientHeight = 313
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PnlBody: TPanel
    Left = 0
    Top = 0
    Width = 434
    Height = 313
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 479
    object LabelResult: TLabel
      Left = 40
      Top = 256
      Width = 337
      Height = 13
      WordWrap = True
    end
    object LabelMarcas: TLabel
      Left = 40
      Top = 77
      Width = 41
      Height = 16
      Caption = 'Marcas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LabelModelos: TLabel
      Left = 40
      Top = 133
      Width = 47
      Height = 16
      Caption = 'Modelos'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LabelAno: TLabel
      Left = 40
      Top = 189
      Width = 22
      Height = 16
      Caption = 'Ano'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object ComboMarcas: TComboBox
      Left = 40
      Top = 96
      Width = 337
      Height = 24
      Style = csDropDownList
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnSelect = ComboMarcasSelect
    end
    object ComboModelos: TComboBox
      Left = 40
      Top = 152
      Width = 337
      Height = 24
      Style = csDropDownList
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnSelect = ComboModelosSelect
    end
    object RadioButtonCar: TRadioButton
      Left = 40
      Top = 24
      Width = 89
      Height = 17
      Caption = 'Carros'
      TabOrder = 2
      OnClick = RadioButtonCarClick
    end
    object RadioButtonBike: TRadioButton
      Left = 135
      Top = 24
      Width = 89
      Height = 17
      Caption = 'Motos'
      TabOrder = 3
      OnClick = RadioButtonBikeClick
    end
    object RadioButtonTruck: TRadioButton
      Left = 230
      Top = 24
      Width = 89
      Height = 17
      Caption = 'Caminh'#245'es'
      TabOrder = 4
      OnClick = RadioButtonTruckClick
    end
    object ComboBoxAno: TComboBox
      Left = 40
      Top = 208
      Width = 337
      Height = 24
      Style = csDropDownList
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnSelect = ComboBoxAnoSelect
    end
  end
end
