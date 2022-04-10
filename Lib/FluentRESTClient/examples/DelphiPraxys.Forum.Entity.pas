unit DelphiPraxys.Forum.Entity;

interface

uses
  System.Classes;

type
  TCustomForum = class(TPersistent)
  strict private
    FID: Integer;
    FTitle: string;
    FParent: Integer;
    FThreadCount: Integer;
    FLastPost: TDate;
  protected
    property ID: Integer read FID write FID;
    property Title: string read FTitle write FTitle;
    property Parent: Integer read FParent write FParent;
    property ThreadCount: Integer read FThreadCount write FThreadCount;
    property LastPost: TDate read FLastPost write FLastPost;
  end;

  TForum = class(TCustomForum)
  published
    property ID;
    property Title;
    property Parent;
    property ThreadCount;
    property LastPost;
  end;

implementation

end.
