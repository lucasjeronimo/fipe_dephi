unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  API.Fipe, API.Fipe.Interfaces;

type
  TFormMain = class(TForm)
    PnlBody: TPanel;
    ComboMarcas: TComboBox;
    LabelMarcas: TLabel;
    ComboModelos: TComboBox;
    LabelModelos: TLabel;
    LabelResult: TLabel;
    RadioButtonCar: TRadioButton;
    RadioButtonBike: TRadioButton;
    RadioButtonTruck: TRadioButton;
    LabelAno: TLabel;
    ComboBoxAno: TComboBox;
    procedure RadioButtonCarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButtonBikeClick(Sender: TObject);
    procedure RadioButtonTruckClick(Sender: TObject);
    procedure ComboMarcasSelect(Sender: TObject);
    procedure ComboModelosSelect(Sender: TObject);
    procedure ComboBoxAnoSelect(Sender: TObject);
  private
    { Private declarations }
    FReferencia : Integer;
    FTabelaFipe : ITabelaFipe;
    procedure getMarcas(ATipoVeiculo : TTipoVeiculoFipe);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses
   API.Fipe.Model.Referencia, API.Fipe.Model.Marca, API.Fipe.Model.Modelo, API.Fipe.Model.AnoModelo, API.Fipe.Model.Veiculo;

{$R *.dfm}

procedure TFormMain.ComboBoxAnoSelect(Sender: TObject);
begin
   TThread.CreateAnonymousThread(
      procedure
      var
         result : TResult<TVeiculo>;
         Marca : TMarca;
         Modelo : TModelo;
         AnoModelo : TAnoModelo;
      begin
         Marca := TMarca(ComboMarcas.Items.Objects[ComboMarcas.Items.IndexOf(ComboMarcas.Text)]);
         Modelo := TModelo(ComboModelos.Items.Objects[ComboModelos.Items.IndexOf(ComboModelos.Text)]);
         AnoModelo := TAnoModelo(ComboBoxAno.Items.Objects[ComboBoxAno.Items.IndexOf(ComboBoxAno.Text)]);
         result := FTabelaFipe.getVeiculo(FReferencia,StrToInt(Marca.Value),StrToInt(Modelo.Value),AnoModelo.Value);

         if result.success then
            LabelResult.Caption := result.data.Valor;

      end).Start;
end;

procedure TFormMain.ComboMarcasSelect(Sender: TObject);
begin
   TThread.CreateAnonymousThread(
      procedure
      var
         result : TResult<TModelos>;
         Marca : TMarca;
         Modelo : TModelo;
      begin
         Marca := TMarca(ComboMarcas.Items.Objects[ComboMarcas.Items.IndexOf(ComboMarcas.Text)]);
         result := FTabelaFipe.getModelos(FReferencia,StrToInt(Marca.Value));

         if result.success then
         begin
            ComboModelos.Clear;
            for Modelo in result.data.Modelos do
               ComboModelos.AddItem(Modelo.&Label,Modelo);
            ComboModelos.Enabled := true;
         end;

      end).Start;
end;

procedure TFormMain.ComboModelosSelect(Sender: TObject);
begin
   TThread.CreateAnonymousThread(
      procedure
      var
         result : TResult<TAnosModelos>;
         Marca  : TMarca;
         Modelo : TModelo;
         AnoModelo : TAnoModelo;
      begin
         Marca  := TMarca(ComboMarcas.Items.Objects[ComboMarcas.Items.IndexOf(ComboMarcas.Text)]);
         Modelo := TModelo(ComboModelos.Items.Objects[ComboModelos.Items.IndexOf(ComboModelos.Text)]);
         result := FTabelaFipe.getAnosModelos(FReferencia,StrToInt(Marca.Value),StrToInt(Modelo.Value));

         if result.success then
         begin
            ComboBoxAno.Clear;
            for AnoModelo in result.data.AnosModelos do
               ComboBoxAno.AddItem(AnoModelo.&Label,AnoModelo);
            ComboBoxAno.Enabled := true;
         end;

      end).Start;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
   FReferencia := TTabelaFipe.New(TTipoVeiculoFipe.tvfCarros).getReferencias.data.Referencias[0].Codigo;
end;

procedure TFormMain.getMarcas(ATipoVeiculo : TTipoVeiculoFipe);
begin
   ComboMarcas.Enabled  := false;
   ComboModelos.Enabled := false;
   ComboBoxAno.Enabled  := false;
   LabelResult.Caption  := '';

   FTabelaFipe := TTabelaFipe.New(ATipoVeiculo);
   TThread.CreateAnonymousThread(
      procedure
      var
         result : TResult<TMarcas>;
         Marca : TMarca;
      begin
         result := FTabelaFipe.getMarcas(FReferencia);

         if result.success then
         begin
            ComboMarcas.Clear;
            for Marca in result.data.Marcas do
               ComboMarcas.AddItem(Marca.&Label,Marca);
            ComboMarcas.Enabled := true;
         end;

      end).Start;
end;

procedure TFormMain.RadioButtonBikeClick(Sender: TObject);
begin
   getMarcas(TTipoVeiculoFipe.tvfMotos);
end;

procedure TFormMain.RadioButtonCarClick(Sender: TObject);
begin
   getMarcas(TTipoVeiculoFipe.tvfCarros);
end;

procedure TFormMain.RadioButtonTruckClick(Sender: TObject);
begin
   getMarcas(TTipoVeiculoFipe.tvfCaminhoes);
end;

end.
