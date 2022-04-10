unit API.Fipe.Model.Marca;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TMarca = class
  private
    FLabel: string;
    FValue: string;
  published
    property &Label: string read FLabel write FLabel;
    property Value: string read FValue write FValue;
  end;
  
  TMarcas = class(TJsonDTO)
  private
    [JSONName('Items'), JSONMarshalled(False)]
    FMarcasArray: TArray<TMarca>;
    [GenericListReflect]
    FMarcas: TObjectList<TMarca>;
    function GetMarcas: TObjectList<TMarca>;
  protected
    function GetAsJson: string; override;
  published
    property Marcas: TObjectList<TMarca> read GetMarcas;
  public
    destructor Destroy; override;
  end;
  
implementation

{ TMarcas }

destructor TMarcas.Destroy;
begin
  GetMarcas.Free;
  inherited;
end;

function TMarcas.GetMarcas: TObjectList<TMarca>;
begin
  Result := ObjectList<TMarca>(FMarcas, FMarcasArray);
end;

function TMarcas.GetAsJson: string;
begin
  RefreshArray<TMarca>(FMarcas, FMarcasArray);
  Result := inherited;
end;

end.
