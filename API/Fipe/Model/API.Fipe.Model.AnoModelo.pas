unit API.Fipe.Model.AnoModelo;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TAnoModelo = class
  private
    FLabel: string;
    FValue: string;
  published
    property &Label: string read FLabel write FLabel;
    property Value: string read FValue write FValue;
  end;
  
  TAnosModelos = class(TJsonDTO)
  private
    [JSONName('Items'), JSONMarshalled(False)]
    FAnosModelosArray: TArray<TAnoModelo>;
    [GenericListReflect]
    FAnosModelos: TObjectList<TAnoModelo>;
    function GetAnosModelos: TObjectList<TAnoModelo>;
  protected
    function GetAsJson: string; override;
  published
    property AnosModelos: TObjectList<TAnoModelo> read GetAnosModelos;
  public
    destructor Destroy; override;
  end;
  
implementation

{ TAnosModelos }

destructor TAnosModelos.Destroy;
begin
  GetAnosModelos.Free;
  inherited;
end;

function TAnosModelos.GetAnosModelos: TObjectList<TAnoModelo>;
begin
  Result := ObjectList<TAnoModelo>(FAnosModelos, FAnosModelosArray);
end;

function TAnosModelos.GetAsJson: string;
begin
  RefreshArray<TAnoModelo>(FAnosModelos, FAnosModelosArray);
  Result := inherited;
end;

end.
