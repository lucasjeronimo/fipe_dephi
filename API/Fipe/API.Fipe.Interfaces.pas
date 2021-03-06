unit API.Fipe.Interfaces;

interface

uses
   API.Fipe.Model.Referencia, API.Fipe.Model.Marca, API.Fipe.Model.Modelo, API.Fipe.Model.AnoModelo, API.Fipe.Model.Veiculo;

type
   TResult<T> = record
      success : Boolean;
      &message : String;
      data: T;
  end;

   ITabelaFipe = interface
      ['{0C133DFB-842C-4E62-89DF-1329A3FBDAF4}']
      function getReferencias:TResult<TReferencias>;
      function getMarcas(AReferencia:Integer;ATentativas:Integer=1):TResult<TMarcas>;
      function getModelos(AReferencia,AMarca:Integer;ATentativas:Integer=1):TResult<TModelos>;
      function getAnosModelos(AReferencia,AMarca,AModelo:Integer;ATentativas:Integer=1):TResult<TAnosModelos>;
      function getVeiculo(AReferencia,AMarca,AModelo:Integer;AAnoModelo:String;ATentativas:Integer=1):TResult<TVeiculo>;
   end;

implementation

end.
