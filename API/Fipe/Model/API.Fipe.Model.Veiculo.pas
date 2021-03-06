unit API.Fipe.Model.Veiculo;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TVeiculo = class(TJsonDTO)
  private
    FAnoModelo: Integer;
    FAutenticacao: string;
    FCodigoFipe: string;
    FCombustivel: string;
    FDataConsulta: string;
    FMarca: string;
    FMesReferencia: string;
    FModelo: string;
    FSiglaCombustivel: string;
    FTipoVeiculo: Integer;
    FValor: string;
  published
    property AnoModelo: Integer read FAnoModelo write FAnoModelo;
    property Autenticacao: string read FAutenticacao write FAutenticacao;
    property CodigoFipe: string read FCodigoFipe write FCodigoFipe;
    property Combustivel: string read FCombustivel write FCombustivel;
    property DataConsulta: string read FDataConsulta write FDataConsulta;
    property Marca: string read FMarca write FMarca;
    property MesReferencia: string read FMesReferencia write FMesReferencia;
    property Modelo: string read FModelo write FModelo;
    property SiglaCombustivel: string read FSiglaCombustivel write FSiglaCombustivel;
    property TipoVeiculo: Integer read FTipoVeiculo write FTipoVeiculo;
    property Valor: string read FValor write FValor;
  end;
  
implementation

end.
