unit API.Fipe.Model.Referencia;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TReferencia = class
  private
    FCodigo: Integer;
    FMes: string;
  published
    property Codigo: Integer read FCodigo write FCodigo;
    property Mes: string read FMes write FMes;
  end;
  
  TReferencias = class(TJsonDTO)
  private
    [JSONName('Items'), JSONMarshalled(False)]
    FReferenciasArray: TArray<TReferencia>;
    [GenericListReflect]
    FReferencias: TObjectList<TReferencia>;
    function GetReferencias: TObjectList<TReferencia>;
  protected
    function GetAsJson: string; override;
  published
    property Referencias: TObjectList<TReferencia> read GetReferencias;
  public
    destructor Destroy; override;
  end;
  
implementation

{ TReferencias }

destructor TReferencias.Destroy;
begin
  GetReferencias.Free;
  inherited;
end;

function TReferencias.GetReferencias: TObjectList<TReferencia>;
begin
  Result := ObjectList<TReferencia>(FReferencias, FReferenciasArray);
end;

function TReferencias.GetAsJson: string;
begin
  RefreshArray<TReferencia>(FReferencias, FReferenciasArray);
  Result := inherited;
end;

end.
