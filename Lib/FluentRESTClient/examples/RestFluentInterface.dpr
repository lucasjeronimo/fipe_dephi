program RestFluentInterface;

uses
  FastMM4,
  Vcl.Forms,
  Foundation.JsonUtils in '..\source\Foundation.JsonUtils.pas',
  Foundation.Fluent.REST.Client in '..\source\Foundation.Fluent.REST.Client.pas',
  JsonDataObjects in '..\source\vendor\JsonDataObjects\JsonDataObjects.pas',
  RestFluentInterface.Main.Form in 'RestFluentInterface.Main.Form.pas' {FluentRestClientForm},
  DelphiPraxys.Forum.Entity in 'DelphiPraxys.Forum.Entity.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFluentRestClientForm, FluentRestClientForm);
  Application.Run;
end.
