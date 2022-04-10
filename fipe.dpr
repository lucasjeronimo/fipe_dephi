program fipe;

uses
  Vcl.Forms,
  main in 'main.pas' {FormMain},
  Data.DB.Helper in 'Lib\Data.DB.Helper.pas',
  Pkg.Json.DTO in 'Lib\Pkg.Json.DTO.pas',
  System.uJson in 'Lib\System.uJson.pas',
  Foundation.Fluent.REST.Client in 'Lib\FluentRESTClient\source\Foundation.Fluent.REST.Client.pas',
  Foundation.JsonUtils in 'Lib\FluentRESTClient\source\Foundation.JsonUtils.pas',
  JsonDataObjects in 'Lib\FluentRESTClient\source\vendor\JsonDataObjects\JsonDataObjects.pas',
  API.Fipe.Interfaces in 'API\Fipe\API.Fipe.Interfaces.pas',
  API.Fipe in 'API\Fipe\API.Fipe.pas',
  API.Fipe.Model.AnoModelo in 'API\Fipe\Model\API.Fipe.Model.AnoModelo.pas',
  API.Fipe.Model.Marca in 'API\Fipe\Model\API.Fipe.Model.Marca.pas',
  API.Fipe.Model.Modelo in 'API\Fipe\Model\API.Fipe.Model.Modelo.pas',
  API.Fipe.Model.Referencia in 'API\Fipe\Model\API.Fipe.Model.Referencia.pas',
  API.Fipe.Model.Veiculo in 'API\Fipe\Model\API.Fipe.Model.Veiculo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
