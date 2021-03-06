unit API.Fipe;

interface

uses
   Foundation.Fluent.REST.Client, System.JSON, System.SysUtils, REST.Json.Types,REST.Types,
   API.Fipe.Interfaces,
   API.Fipe.Model.Referencia, API.Fipe.Model.Marca, API.Fipe.Model.Modelo, API.Fipe.Model.AnoModelo, API.Fipe.Model.Veiculo;

type
   TTipoVeiculoFipe = (tvfCarros = 1, tvfMotos = 2, tvfCaminhoes = 3);
   TTipoVeiculo = (tvCarros = 1, tvMotos = 0, tvCaminhoes = 2);

   TTabelaFipe = class(TInterfacedObject, ITabelaFipe)
   private
      FTipoVeiculo : Integer;
   public
      constructor create(ATipoVeiculo:TTipoVeiculoFipe);
      class function New(ATipoVeiculo:TTipoVeiculoFipe): ITabelaFipe;
      function getReferencias:TResult<TReferencias>;
      function getMarcas(AReferencia:Integer;ATentativas:Integer=1):TResult<TMarcas>;
      function getModelos(AReferencia,AMarca:Integer;ATentativas:Integer=1):TResult<TModelos>;
      function getAnosModelos(AReferencia,AMarca,AModelo:Integer;ATentativas:Integer=1):TResult<TAnosModelos>;
      function getVeiculo(AReferencia,AMarca,AModelo:Integer;AAnoModelo:String;ATentativas:Integer=1):TResult<TVeiculo>;
   end;

   const
      END_POINT = 'http://veiculos.fipe.org.br/api/veiculos/';

implementation

{ TTabelaFipe }

constructor TTabelaFipe.create(ATipoVeiculo: TTipoVeiculoFipe);
begin
   FTipoVeiculo := ord(ATipoVeiculo);
end;

class function TTabelaFipe.New(ATipoVeiculo: TTipoVeiculoFipe): ITabelaFipe;
begin
   Result := Create(ATipoVeiculo);
end;

function TTabelaFipe.getReferencias: TResult<TReferencias>;
var
   request : TRestClientRequest;
   Referencias : TReferencias;
   mString : String;
begin
   try
      request := RestBuilder.CreateRequest
                             .Resource(END_POINT)
                             .ResourceParams(['ConsultarTabelaDeReferencia'])
                             .Post;

      if (not request.RequestError) and (request.ResponseStatusCode = 200) then
      begin
         Referencias := TReferencias.Create;
         Result.success := true;
         mString := request.ResponseContent;
         Referencias.AsJson := mString;
         Result.data := Referencias;
      end
      else
      begin
         Result.message := request.RequestErrorMessage;
         Result.success := false;
         Result.data  := TReferencias.Create;
      end;
   except
      on E: ERESTException do
      begin
         Result.message := E.Message;
         Result.success := false;
         Result.data  := TReferencias.Create;
         Exit;
      end;
   end;
end;

function TTabelaFipe.getMarcas(AReferencia:Integer;ATentativas:Integer=1): TResult<TMarcas>;
var
   request : TRestClientRequest;
   mBody : String;
   Marcas : TMarcas;

   function getBody:String;
   var
      jSonObject : TJsonObject;
   begin
      Result      := '';
      jSonObject := TJsonObject.Create;
      try
         jSonObject.AddPair('codigoTabelaReferencia',IntToStr(AReferencia));
         jSonObject.AddPair('codigoTipoVeiculo',IntToStr(FTipoVeiculo));
         Result := jSonObject.ToJson;
      finally
         jSonObject.Free;
      end;
   end;
begin
   mBody := getBody;
   try
      request := RestBuilder.CreateRequest
                             .Resource(END_POINT)
                             .ResourceParams(['ConsultarMarcas'])
                             .Body(mBody, TRESTContentType.ctAPPLICATION_JSON)
                             .Post;

      if (not request.RequestError) and (request.ResponseStatusCode = 200) then
      begin
         Marcas := TMarcas.Create;
         Result.success := true;
         Marcas.AsJson := request.ResponseContent;
         Result.data := Marcas;
      end
      else
      begin
         Result.message := request.RequestErrorMessage;
         Result.success := false;
         Result.data  := TMarcas.Create;
      end;
   except
      on E: ERESTException do
      begin
         if ATentativas <= 3 then
         begin
            inc(ATentativas);
            Result := getMarcas(AReferencia,ATentativas);
            Exit;
         end;
         Result.message := E.Message;
         Result.success := false;
         Result.data  := TMarcas.Create;
         Exit;
      end;
   end;
end;

function TTabelaFipe.getModelos(AReferencia, AMarca: Integer;ATentativas:Integer=1): TResult<TModelos>;
var
   request : TRestClientRequest;
   mBody : String;
   Modelos : TModelos;

   function getBody:String;
   var
      jSonObject : TJsonObject;
   begin
      Result      := '';
      jSonObject := TJsonObject.Create;
      try
         jSonObject.AddPair('codigoTabelaReferencia',IntToStr(AReferencia));
         jSonObject.AddPair('codigoTipoVeiculo',IntToStr(FTipoVeiculo));
         jSonObject.AddPair('codigoMarca',IntToStr(AMarca));
         Result := jSonObject.ToJson;
      finally
         jSonObject.Free;
      end;
   end;
begin
   mBody := getBody;
   try
      request := RestBuilder.CreateRequest
                             .Resource(END_POINT)
                             .ResourceParams(['ConsultarModelos'])
                             .Body(mBody, TRESTContentType.ctAPPLICATION_JSON)
                             .Post;

      if (not request.RequestError) and (request.ResponseStatusCode = 200) then
      begin
         Modelos := TModelos.Create;
         Result.success := true;
         Modelos.AsJson := request.ResponseContent;
         Result.data := Modelos;
      end
      else
      begin
         Result.message := request.RequestErrorMessage;
         Result.success := false;
         Result.data  := TModelos.Create;
      end;
   except
      on E: ERESTException do
      begin
         if ATentativas <= 3 then
         begin
            inc(ATentativas);
            Result := getModelos(AReferencia,AMarca,ATentativas);
            Exit;
         end;
         Result.message := E.Message;
         Result.success := false;
         Result.data  := TModelos.Create;
         Exit;
      end;
   end;
end;

function TTabelaFipe.getAnosModelos(AReferencia, AMarca, AModelo: Integer;ATentativas:Integer=1): TResult<TAnosModelos>;
var
   request : TRestClientRequest;
   mBody : String;
   AnosModelos : TAnosModelos;

   function getBody:String;
   var
      jSonObject : TJsonObject;
   begin
      Result      := '';
      jSonObject := TJsonObject.Create;
      try
         jSonObject.AddPair('codigoTabelaReferencia',IntToStr(AReferencia));
         jSonObject.AddPair('codigoTipoVeiculo',IntToStr(FTipoVeiculo));
         jSonObject.AddPair('codigoMarca',IntToStr(AMarca));
         jSonObject.AddPair('codigoModelo',IntToStr(AModelo));
         Result := jSonObject.ToJson;
      finally
         jSonObject.Free;
      end;
   end;
begin
   mBody := getBody;
   try
      request := RestBuilder.CreateRequest
                             .Resource(END_POINT)
                             .ResourceParams(['ConsultarAnoModelo'])
                             .Body(mBody, TRESTContentType.ctAPPLICATION_JSON)
                             .Post;

      if (not request.RequestError) and (request.ResponseStatusCode = 200) then
      begin
         AnosModelos := TAnosModelos.Create;
         Result.success := true;
         AnosModelos.AsJson := request.ResponseContent;
         Result.data := AnosModelos;
      end
      else
      begin
         Result.message := request.RequestErrorMessage;
         Result.success := false;
         Result.data  := TAnosModelos.Create;
      end;
   except
      on E: ERESTException do
      begin
         if ATentativas <= 3 then
         begin
            inc(ATentativas);
            Result := getAnosModelos(AReferencia, AMarca, AModelo ,ATentativas);
            Exit;
         end;
         Result.message := E.Message;
         Result.success := false;
         Result.data  := TAnosModelos.Create;
         Exit;
      end;
   end;
end;

function TTabelaFipe.getVeiculo(AReferencia, AMarca, AModelo: Integer; AAnoModelo: String; ATentativas:Integer=1): TResult<TVeiculo>;
var
   request : TRestClientRequest;
   mBody : String;
   Veiculo : TVeiculo;

   function getBody:String;
   var
      jSonObject : TJsonObject;
      mCombustivel : String;
   begin
      Result       := '';
      mCombustivel := AAnoModelo.Substring(AAnoModelo.Length-1);
      AAnoModelo   := AAnoModelo.Substring(0,AAnoModelo.Length-2);
      jSonObject := TJsonObject.Create;
      try
         jSonObject.AddPair('codigoTabelaReferencia',IntToStr(AReferencia));
         jSonObject.AddPair('codigoTipoVeiculo',IntToStr(FTipoVeiculo));
         jSonObject.AddPair('codigoMarca',IntToStr(AMarca));
         jSonObject.AddPair('codigoModelo',IntToStr(AModelo));
         jSonObject.AddPair('anoModelo',AAnoModelo);
         jSonObject.AddPair('codigoTipoCombustivel',mCombustivel);
         jSonObject.AddPair('tipoConsulta','tradicional');
         Result := jSonObject.ToJson;
      finally
         jSonObject.Free;
      end;
   end;
begin
   mBody := getBody;
   try
      request := RestBuilder.CreateRequest
                             .Resource(END_POINT)
                             .ResourceParams(['ConsultarValorComTodosParametros'])
                             .Body(mBody, TRESTContentType.ctAPPLICATION_JSON)
                             .Post;

      if (not request.RequestError) and (request.ResponseStatusCode = 200) then
      begin
         Veiculo := TVeiculo.Create;
         Result.success := true;
         Veiculo.AsJson := request.ResponseContent;
         Result.data := Veiculo;
      end
      else
      begin
         Result.message := request.RequestErrorMessage;
         Result.success := false;
         Result.data  := TVeiculo.Create;
      end;
   except
      on E: ERESTException do
      begin
         if ATentativas <= 3 then
         begin
            inc(ATentativas);
            Result := getVeiculo(AReferencia, AMarca, AModelo, AAnoModelo ,ATentativas);
            Exit;
         end;
         Result.message := E.Message;
         Result.success := false;
         Result.data  := TVeiculo.Create;
         Exit;
      end;
   end;
end;

end.
