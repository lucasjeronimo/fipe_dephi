unit API.Fipe.Model.Modelo;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TModelo = class
  private
    FLabel: string;
    FValue: string;
  published
    property &Label: string read FLabel write FLabel;
    property Value: string read FValue write FValue;
  end;
  
  TModelos = class(TJsonDTO)
  private
    [JSONName('Modelos'), JSONMarshalled(False)]
    FModelosArray: TArray<TModelo>;
    [GenericListReflect]
    FModelos: TObjectList<TModelo>;
    function GetModelos: TObjectList<TModelo>;
  protected
    function GetAsJson: string; override;
  published
    property Modelos: TObjectList<TModelo> read GetModelos;
  public
    destructor Destroy; override;
  end;
  
implementation

{ TModelos }

destructor TModelos.Destroy;
begin
  GetModelos.Free;
  inherited;
end;

function TModelos.GetModelos: TObjectList<TModelo>;
begin
  Result := ObjectList<TModelo>(FModelos, FModelosArray);
end;

function TModelos.GetAsJson: string;
begin
  RefreshArray<TModelo>(FModelos, FModelosArray);
  Result := inherited;
end;

end.
