unit Foundation.Fluent.REST.Client;

{******************************************************************************}
{                                                                              }
{ Foundation Framework                                                         }
{                                                                              }
{ The MIT License (MIT)                                                        }
{                                                                              }
{ Copyright (c) 2015-2016                                                      }
{   Cesar Romero <cesarliws@gmail.com>                                         }
{                                                                              }
{ Permission is hereby granted, free of charge, to any person obtaining a copy }
{ of this software and associated documentation files (the "Software"), to deal}
{ in the Software without restriction, including without limitation the rights }
{ to use, copy, modify, merge, publish, distribute, sublicense, and/or sell    }
{ copies of the Software, and to permit persons to whom the Software is        }
{ furnished to do so, subject to the following conditions:                     }
{                                                                              }
{ The above copyright notice and this permission notice shall be included in   }
{ all copies or substantial portions of the Software.                          }
{                                                                              }
{ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR   }
{ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     }
{ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  }
{ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER       }
{ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,}
{ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE}
{ SOFTWARE.                                                                    }
{******************************************************************************}

interface

uses
  IPPeerClient,
  REST.Authenticator.Basic,
  REST.Client,
  REST.Types,
  REST.Utils,
  Rest.Json,
  System.Json,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils;

type
  TRestClientRequest = class;
  TRestRequest = REST.Client.TRESTRequest;

  IRestClientBuilder = interface(IInterface)
    ['{39F74C5C-BDAD-4F75-B75F-B690DB3B78C7}']
    function CreateRequest: TRestClientRequest;
    function Request: TRestClientRequest;
  end;

  TRestClientBuilder = class(TInterfacedObject, IRestClientBuilder)
  strict private
    FRestClientRequest: TRestClientRequest;
  public
    destructor Destroy; override;
    function CreateRequest: TRestClientRequest;
    function Request: TRestClientRequest;
  end;

  TRestClientRequest = class(TComponent)
  strict private
    FBasicAuthenticator: THTTPBasicAuthenticator;
    FRequestError: Boolean;
    FRequestErrorMessage: string;
    FResource: string;
    FRestClient: TRESTClient;
    FRestClientExecuteRaiseException: Boolean;
    FRestClientRequestLowerCamelCase: Boolean;
    FRestClientResponseCaseSensitive: Boolean;
    FRestRequest: TRESTRequest;
    FRestResponse: TRESTResponse;
  private
    constructor Create; reintroduce;
  protected
    function GetBasicAuthenticator: THTTPBasicAuthenticator;
    procedure Execute;
    procedure CreateComponents;
    procedure FreeComponents;
  public
    function AcceptContentType(const Value: string): TRestClientRequest;
    function AcceptCharset(const Value: string): TRestClientRequest;

    function BasicAuth(const UserName, Password: string): TRestClientRequest;

    function Body(const Value: string; ContentType: TRESTContentType): TRestClientRequest; overload;
    function Body(const Value: string; ContentType: TRESTContentType; Options: TRESTRequestParameterOptions): TRestClientRequest; overload;
    function Body<T: class, constructor>(Entity: T; ContentType: TRESTContentType; Options: TRESTRequestParameterOptions): TRestClientRequest; overload;

    function HeaderParam(const Name, Value: string): TRestClientRequest; overload;
    function HeaderParam(const Name, Value: string; ContentType: TRESTContentType; Options: TRESTRequestParameterOptions): TRestClientRequest; overload;

    function Param(const Name, Value: string; Kind: TRESTRequestParameterKind; ContentType: TRESTContentType): TRestClientRequest; overload;
    function Param(const Name, Value: string; Kind: TRESTRequestParameterKind; ContentType: TRESTContentType; Options: TRESTRequestParameterOptions): TRestClientRequest; overload;

    function Resource(const Value: string): TRestClientRequest;
    function ResourceParams(const Params: TArray<string>; Encode: Boolean = False): TRestClientRequest;
    ///
    function ClearParams: TRestClientRequest;
    function RequestError: Boolean;
    function RequestErrorMessage: string;
    function RecreateComponents: TRestClientRequest;
    ///
    function Get: TRestClientRequest; overload;
    function Get<T: class, constructor>: T; overload;

    function Post(Entity: TObject): TRestClientRequest; overload;
    function Post: TRestClientRequest; overload;
    function Post<T: class, constructor>(Entity: TObject): T; overload;

    function Patch(Entity: TObject): TRestClientRequest; overload;
    function Patch: TRestClientRequest; overload;
    function Patch<T: class, constructor>(Entity: TObject): T; overload;

    function Put(Entity: TObject): TRestClientRequest; overload;
    function Put: TRestClientRequest; overload;
    function Put<T: class, constructor>(Entity: TObject): T; overload;

    function Delete(Entity: TObject): TRestClientRequest; overload;
    function Delete: TRestClientRequest; overload;
    ///
    function ResponseContent: string;
    function ResponseContentAs<T>: T;
    function ResponseContentAsJson(Compact: Boolean = True): string;
    function ResponseContentAsObject<T: class, constructor>: T;
    function ResponseContentAsObjectList<T: class, constructor>: TObjectList<T>;

    function ResponseStatusCode: Integer;
    function ResponseStatusText: string;
    /// <summary>
    ///   Access to internal TRESTRequest component
    /// </summary>
    function RestRequest(Proc: TProc<TRESTRequest>): TRestClientRequest;
    /// <summary>
    ///   <para>
    ///     Define if Exception is raised in requests.
    ///   </para>
    ///   <para>
    ///     Default True
    ///   </para>
    ///   <para>
    ///     If False, use RequestError and RequestErrorMessage to check for
    ///     Exceptions.
    ///   </para>
    /// </summary>
    function ExecuteRaiseException(Value : Boolean): TRestClientRequest;
    /// <summary>
    ///   If True first letter of JSON members will be converted to lower case
    /// </summary>
    /// <example>
    ///   {
    ///    "name":"Configuration",
    ///    "value":"30",
    ///    "targetAddress":"Target Address Value",
    ///    "configurationGroup":null,
    ///    "systemId":1,
    ///    "active":true
    ///   }
    /// </example>
    function RequestLowerCamelCase(Value : Boolean): TRestClientRequest;
    /// <summary>
    ///   If False JSON Response will be case insensitive when mapping values to object
    /// </summary>
    function ResponseCaseSensitive(Value : Boolean): TRestClientRequest;
  end;

function RestBuilder: IRestClientBuilder;

var
  DefaultRestClientExecuteRaiseException: Boolean = True;
  DefaultRestClientRequestLowerCamelCase: Boolean = True;
  DefaultRestClientResponseCaseSensitive: Boolean = False;

implementation

uses
  System.Rtti;
  //Foundation.JsonUtils;

const
  REQUEST_BODY_PARAM_NAME  = 'body';
  REST_ACCEPT_CHARSET      = 'UTF-8, *;q=0.8';
  REST_ACCEPT_CONTENT_TYPE = 'application/json,application/xml,text/plain;q=0.9,text/html;q=0.8,';

function RestBuilder: IRestClientBuilder;
begin
  Result := TRestClientBuilder.Create;
end;

{ TRestClientProvider }

destructor TRestClientBuilder.Destroy;
begin
  FRestClientRequest.Free;
  inherited;
end;

function TRestClientBuilder.CreateRequest: TRestClientRequest;
begin
  FRestClientRequest.Free;
  FRestClientRequest := TRestClientRequest.Create;
  Result := FRestClientRequest;
end;

function TRestClientBuilder.Request: TRestClientRequest;
begin
  Assert(FRestClientRequest <> nil);
  Result := FRestClientRequest;
end;

{ TResourceBuilder }

constructor TRestClientRequest.Create;
begin
  inherited Create(nil);
  RecreateComponents;
end;

function TRestClientRequest.AcceptContentType(const Value: string): TRestClientRequest;
begin
  FRestClient.Accept := Value;
  Result := Self;
end;

function TRestClientRequest.AcceptCharset(const Value: string): TRestClientRequest;
begin
  FRestClient.AcceptCharset := Value;
  Result := Self;
end;

function TRestClientRequest.BasicAuth(const UserName, Password: string): TRestClientRequest;
begin
  if (Username <> '') and (Password <> '') then
  begin
    FRestClient.Authenticator    := GetBasicAuthenticator;
    FBasicAuthenticator.Username := Username;
    FBasicAuthenticator.Password := Password;
  end
  else
    FRestClient.Authenticator := nil;

  Result := Self;
end;

function TRestClientRequest.Body(const Value: string; ContentType: TRESTContentType): TRestClientRequest;
begin
  Result := Body(Value, ContentType, []);
end;

function TRestClientRequest.Body(const Value: string; ContentType: TRESTContentType; Options: TRESTRequestParameterOptions): TRestClientRequest;
begin
  Result := Param(REQUEST_BODY_PARAM_NAME, Value, pkREQUESTBODY, ContentType, Options);
end;

function TRestClientRequest.Body<T>(Entity: T; ContentType: TRESTContentType; Options: TRESTRequestParameterOptions): TRestClientRequest;
var
  Value: string;
begin
  //Value := TJson.ObjectToJson(Entity, FRestClientRequestLowerCamelCase);
  Value := TJson.ObjectToJsonString(Entity);//, FRestClientRequestLowerCamelCase);
  Body(Value, TRESTContentType.ctAPPLICATION_JSON, [poDoNotEncode]);
  Result := Self;
end;

function TRestClientRequest.ClearParams: TRestClientRequest;
begin
  FRestRequest.Params.Clear;
  Result := Self.Resource(FResource);
end;

function TRestClientRequest.Delete: TRestClientRequest;
begin
  Result := Self;
  FRestRequest.Method := TRESTRequestMethod.rmDELETE;
  Execute;
end;

function TRestClientRequest.Delete(Entity: TObject): TRestClientRequest;
begin
  Result := Body(Entity, TRESTContentType.ctAPPLICATION_JSON, [poDoNotEncode]);
  Delete;
end;

procedure TRestClientRequest.Execute;
begin
  try
    FRequestError := False;
    FRequestErrorMessage := '';
    FRestRequest.Execute;
  except
    on E: Exception do
    begin
      FRequestError := True;
      FRequestErrorMessage := E.ClassName + ' - ' + E.Message;

      if FRestClientExecuteRaiseException then
      begin
        Raise;
      end;
    end;
  end;
end;

function TRestClientRequest.Get: TRestClientRequest;
begin
  Result := Self;
  FRestRequest.Method := TRESTRequestMethod.rmGET;
  Execute;
end;

function TRestClientRequest.Get<T>: T;
begin
  Get;
  Result := ResponseContentAsObject<T>;
end;

function TRestClientRequest.GetBasicAuthenticator: THTTPBasicAuthenticator;
begin
  if FBasicAuthenticator = nil then
  begin
    FBasicAuthenticator := THTTPBasicAuthenticator.Create(Self);
  end;
  Result := FBasicAuthenticator;
end;

function TRestClientRequest.HeaderParam(const Name, Value: string): TRestClientRequest;
begin
  Result := HeaderParam(Name, Value, TRESTContentType.ctNone, []);
end;

function TRestClientRequest.HeaderParam(const Name, Value: string; ContentType: TRESTContentType; Options: TRESTRequestParameterOptions): TRestClientRequest;
begin
  Result := Param(Name, Value, pkHTTPHEADER, ContentType, Options);
end;

function TRestClientRequest.Param(const Name, Value: string; Kind: TRESTRequestParameterKind; ContentType: TRESTContentType): TRestClientRequest;
begin
  Result := Param(Name, Value, Kind, ContentType, []);
end;

function TRestClientRequest.Param(const Name, Value: string; Kind: TRESTRequestParameterKind; ContentType: TRESTContentType; Options: TRESTRequestParameterOptions): TRestClientRequest;
var
  RequestParam: TRestRequestParameter;
begin
  Result := Self;
  RequestParam := FRestRequest.Params.ParameterByName(Name);
  if RequestParam = nil then
  begin
    RequestParam := FRestRequest.Params.Add as TRestRequestParameter;
  end;

  RequestParam.Name        := Name;
  RequestParam.Value       := Value;
  RequestParam.Kind        := Kind;
  RequestParam.Options     := Options;
  RequestParam.ContentType := ContentType;
end;

function TRestClientRequest.Patch: TRestClientRequest;
begin
  Result := Self;
  FRestRequest.Method := TRESTRequestMethod.rmPATCH;
  Execute;
end;

function TRestClientRequest.Patch(Entity: TObject): TRestClientRequest;
begin
  Result := Body(Entity, TRESTContentType.ctAPPLICATION_JSON, [poDoNotEncode]);
  Patch;
end;

function TRestClientRequest.Patch<T>(Entity: TObject): T;
begin
  Patch(Entity);
  Result := ResponseContentAsObject<T>;
end;

function TRestClientRequest.Post: TRestClientRequest;
begin
  FRestRequest.Method := TRESTRequestMethod.rmPOST;
  Result := Self;
  Execute;
end;

function TRestClientRequest.Post(Entity: TObject): TRestClientRequest;
begin
  Result := Body(Entity, TRESTContentType.ctAPPLICATION_JSON, [poDoNotEncode]);
  Post;
end;

function TRestClientRequest.Post<T>(Entity: TObject): T;
begin
  Post(Entity);
  Result := ResponseContentAsObject<T>;
end;

function TRestClientRequest.Put: TRestClientRequest;
begin
  Result := Self;
  FRestRequest.Method := TRESTRequestMethod.rmPUT;
  Execute;
end;

function TRestClientRequest.Put(Entity: TObject): TRestClientRequest;
begin
  Result := Body(Entity, TRESTContentType.ctAPPLICATION_JSON, [poDoNotEncode]);
  Put;
end;

function TRestClientRequest.Put<T>(Entity: TObject): T;
begin
  Put(Entity);
  Result := ResponseContentAsObject<T>;
end;

function TRestClientRequest.RequestError: Boolean;
begin
  Result := FRequestError;
end;

function TRestClientRequest.RequestErrorMessage: string;
begin
  Result := FRequestErrorMessage;
end;

function TRestClientRequest.RecreateComponents: TRestClientRequest;
begin
  Result := Self;
  FreeComponents;
  CreateComponents;
end;

function TRestClientRequest.Resource(const Value: string): TRestClientRequest;
begin
  Result := Self;
  FResource := Value;
  FRestClient.BaseURL := FResource;
end;

function TRestClientRequest.ResourceParams(const Params: TArray<string>; Encode: Boolean = False): TRestClientRequest;
var
  I: Integer;
  Param: string;
  ParamValues: TArray<string>;
begin
  Assert(FResource <> '');
  Result := Self;

  if Encode then
  begin
    SetLength(ParamValues, Length(Params));
    for I := Low(Params) to High(Params) do
    begin
      ParamValues[I] := URIEncode(Params[I]);
    end;
  end
  else
    ParamValues := Params;

  for Param in ParamValues do
  begin
    if Param = '' then
      Continue;

    if (FResource[Length(FResource)] <> '=') and (Param[1] <> '/') then
    begin
      FResource := FResource + '/';
    end;
    FResource := FResource + Param;
  end;

  FRestClient.BaseURL := FResource;
end;

function TRestClientRequest.ResponseContentAsJson(Compact: Boolean = True): string;
var
  tmpJson: TJsonValue;
begin
  tmpJson := TJSONObject.ParseJSONValue(ResponseContent);
  if Compact then
     Result := tmpJson.ToString
     //Result := tmpJson.ToJson// Retorna caracter   :"Ararangu\u00E1"
  else
    Result := TJson.Format(tmpJson);
  FreeAndNil(tmpJson);
end;


function TRestClientRequest.ResponseContent: string;
begin
  Result := FRestResponse.Content;
end;

function TRestClientRequest.ResponseStatusCode: Integer;
begin
  if FRestResponse <> nil then
    Result := FRestResponse.StatusCode
  else
    Result := 0;
end;

function TRestClientRequest.ResponseStatusText: string;
begin
  Result := FRestResponse.StatusText
end;

function TRestClientRequest.RestRequest(Proc: TProc<TRESTRequest>): TRestClientRequest;
begin
  Proc(FRestRequest);
  Result := Self;
end;

function TRestClientRequest.ResponseContentAs<T>: T;
begin
  // TODO -oCesar -cConverter : Use Spring4d Converters
  if TypeInfo(T) = TypeInfo(Boolean) then
    Result := TValue.From<Boolean>(StrToBool(ResponseContent)).AsType<T>
  else
    Result := TValue.From<string>(ResponseContent).AsType<T>;
end;

function TRestClientRequest.ResponseContentAsObject<T>: T;
begin
  if (not RequestError) and (ResponseContent <> '') then
  begin
    //Result := TClass(T).Create as T;
    //TJson.JsonToObject(ResponseContent, Result, FRestClientResponseCaseSensitive);
    Result := TJson.JsonToObject<T>(ResponseContent)
  end
  else
    Result := nil;
end;

function TRestClientRequest.ExecuteRaiseException(Value: Boolean): TRestClientRequest;
begin
  Result := Self;
  FRestClientExecuteRaiseException := Value;
end;

function TRestClientRequest.RequestLowerCamelCase(Value: Boolean): TRestClientRequest;
begin
  Result := Self;
  FRestClientRequestLowerCamelCase := Value;
end;

function TRestClientRequest.ResponseCaseSensitive(Value: Boolean): TRestClientRequest;
begin
  Result := Self;
  FRestClientResponseCaseSensitive := Value;
end;

procedure TRestClientRequest.FreeComponents;
begin
  FreeAndNil(FRestClient);
  FreeAndNil(FRestRequest);
  FreeAndNil(FRestResponse);
  FreeAndNil(FBasicAuthenticator);
end;

procedure TRestClientRequest.CreateComponents;
begin
  FRestClientExecuteRaiseException   := DefaultRestClientExecuteRaiseException;
  FRestClientRequestLowerCamelCase   := DefaultRestClientRequestLowerCamelCase;
  FRestClientResponseCaseSensitive := DefaultRestClientResponseCaseSensitive;

  FRestClient   := TRESTClient.Create(Self);
  FRestRequest  := TRESTRequest.Create(Self);
  FRestResponse := TRESTResponse.Create(Self);

  FRestClient.Accept              := REST_ACCEPT_CONTENT_TYPE;
  FRestClient.AcceptCharset       := REST_ACCEPT_CHARSET;
  FRestClient.BaseURL             := '';
  FRestClient.HandleRedirects     := True;
  FRestClient.RaiseExceptionOn500 := False;

  FRestRequest.Client             := FRestClient;
  FRestRequest.Response           := FRestResponse;
  FRestRequest.SynchronizedEvents := False;

  FRestClient.Params.Clear;
  FRestRequest.Params.Clear;
end;

function TRestClientRequest.ResponseContentAsObjectList<T>: TObjectList<T>;
begin
  if (not RequestError) and (ResponseContent <> '') then
  begin
    //Result := TObjectList<T>.Create(True);
    //TJsonOld.JsonToObjectList<T>(ResponseContent, Result, FRestClientResponseCaseSensitive);
    Result := TJson.JsonToObject<T>(ResponseContent) as TObjectList<T>;
  end
  else
    Result := nil;
end;

end.

