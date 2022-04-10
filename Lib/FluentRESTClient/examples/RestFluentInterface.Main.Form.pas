unit RestFluentInterface.Main.Form;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  System.Variants,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.StdCtrls,
  Winapi.Messages,
  Winapi.Windows,
  DelphiPraxys.Forum.Entity;

type
  TProcessType = (
    BeginProcess,
    EndProcess
  );

  TFluentRestClientForm = class(TForm)
    FormatJsonCheckBox: TCheckBox;
    JsonEchoParamsButton: TButton;
    PraxysObjectListButton: TButton;
    PraxysSimpleButton: TButton;
    ResponseMemo: TMemo;
    SimpleJsonEchoButton: TButton;
    WhatIsMyIpButton: TButton;
    procedure JsonEchoParamsButtonClick(Sender: TObject);
    procedure PraxysObjectListButtonClick(Sender: TObject);
    procedure PraxysSimpleButtonClick(Sender: TObject);
    procedure SimpleJsonEchoButtonClick(Sender: TObject);
    procedure WhatIsMyIpButtonClick(Sender: TObject);
  protected
    function FormatJson: Boolean;
    procedure UpdateStatus(ProcessType: TProcessType);
    procedure ShowForumList(const ForumList: TObjectList<TForum>);
  end;

var
  FluentRestClientForm: TFluentRestClientForm;

implementation

{$R *.dfm}

uses
  Foundation.Fluent.REST.Client;

const
  DELPHI_PRAXIS_API = 'http://www.delphipraxis.net/api';
  FORUMS_RESOURCE   = 'forums';
  PASSWORD          = 'text';
  USERNAME          = 'BAAS';

resourcestring
  SFORUM_ITEM       = '%d, ''%s'', %d, %s';
  SFORUMS_COUNT     = '%d Forums found';

function TFluentRestClientForm.FormatJson: Boolean;
begin
  Result := not FormatJsonCheckBox.Checked;
end;

procedure TFluentRestClientForm.JsonEchoParamsButtonClick(Sender: TObject);
begin
  ResponseMemo.Lines.Text := RestBuilder
    .CreateRequest
    .Resource('http://echo.jsontest.com')
    .ResourceParams(['product', 'Delphi', 'version', 'Berlin', 'api', 'RESTClient'])
    .Get
    .ResponseContentAsJson(FormatJson);
end;

procedure TFluentRestClientForm.PraxysObjectListButtonClick(Sender: TObject);
var
  Request: TRestClientRequest;
  ForumList: TObjectList<TForum>;
begin
  UpdateStatus(BeginProcess);
  try
    Request := RestBuilder.CreateRequest;

    Request
      .Resource(DELPHI_PRAXIS_API)
      .ResourceParams([FORUMS_RESOURCE])
      .BasicAuth(USERNAME, PASSWORD)
      .Get;

    ResponseMemo.Lines.Clear;
    ForumList := Request
      .ResponseContentAsObjectList<TForum>;

    if ForumList <> nil then
    begin
      ShowForumList(ForumList);
      ForumList.Free;
    end;
  finally
    UpdateStatus(EndProcess);
  end;
end;

procedure TFluentRestClientForm.PraxysSimpleButtonClick(Sender: TObject);
begin
  UpdateStatus(BeginProcess);
  try
    ResponseMemo.Lines.Text := RestBuilder
      .CreateRequest
      .Resource(DELPHI_PRAXIS_API)
      .ResourceParams([FORUMS_RESOURCE])
      .BasicAuth(USERNAME, PASSWORD)
      .Get
      .ResponseContentAsJson(FormatJson);
  finally
    UpdateStatus(EndProcess);
  end;
end;

procedure TFluentRestClientForm.ShowForumList(const ForumList: TObjectList<TForum>);
var
  Forum: TForum;
  I: Integer;
begin
  ResponseMemo.Lines.BeginUpdate;
  try
    ResponseMemo.Lines.Add(Format(SFORUMS_COUNT, [ForumList.Count]));
    ResponseMemo.Lines.Add('');

    for I := 0 to ForumList.Count -1 do
    begin
      Forum := ForumList[I];
      ResponseMemo.Lines.Add(Format(SFORUM_ITEM, [
        Forum.ID,
        Forum.Title,
        Forum.ThreadCount,
        DateToStr(Forum.LastPost)
      ]));
    end;
  finally
    ResponseMemo.Lines.EndUpdate;
  end;
end;

procedure TFluentRestClientForm.SimpleJsonEchoButtonClick(Sender: TObject);
begin
  ResponseMemo.Lines.Text := RestBuilder
    .CreateRequest
    .Resource('http://echo.jsontest.com/product/Delphi/version/Berlin/api/FluentRESTClient')
    .Get
    .ResponseContent;
end;

procedure TFluentRestClientForm.UpdateStatus(ProcessType: TProcessType);
begin
  case ProcessType of
    TProcessType.BeginProcess:
      Screen.Cursor := crHourGlass;

    TProcessType.EndProcess:
      Screen.Cursor := crDefault;
  end;

  PraxysSimpleButton    .Enabled := ProcessType = TProcessType.EndProcess;
  PraxysObjectListButton.Enabled := ProcessType = TProcessType.EndProcess;
end;

procedure TFluentRestClientForm.WhatIsMyIpButtonClick(Sender: TObject);
begin
  ResponseMemo.Lines.Text := RestBuilder
    .CreateRequest
    .Resource('http://ip.jsontest.com')
    .Get
    .ResponseContent;
end;

end.

