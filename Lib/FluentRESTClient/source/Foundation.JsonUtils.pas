unit Foundation.JsonUtils;

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

// TODO -oCesar -cDataSet ; Implement JsonArray to/from DataSet
// TODO -oCesar -cToObject; Implement ToObject recursive

interface

uses
  System.Generics.Collections;

type
  TJson = record
  public
    class function JsonToObject(const Value: string; const Instance: TObject; CaseSensitive: Boolean): TObject; static;
    class function JsonToObjectList<T: class>(const Value: string; ObjectList: TObjectList<T>; CaseSensitive: Boolean): Integer; static;
    class function ObjectToJson(const Instance: TObject; LowerCamelCase: Boolean): string; static;
    class function Parse(const Value: string; Compact: Boolean = True): string; static;
    class function Format(const Value: string): string; static;
  end;

implementation

uses
  JsonDataObjects;

{ TJson }

class function TJson.JsonToObject(const Value: string; const Instance: TObject; CaseSensitive: Boolean): TObject;
var
  JsonObject: TJsonObject;
  JsonValue: TJsonBaseObject;
begin
  JsonObject := TJsonObject.Create;
  try
    JsonValue := JsonObject.Parse(Value);
    try
      JsonObject.ToSimpleObject(Instance, CaseSensitive);
    finally
      JsonValue.Free;
      Result := Instance;
    end;
  finally
    JsonObject.Free;
  end;
end;

class function TJson.ObjectToJson(const Instance: TObject; LowerCamelCase: Boolean): string;
var
  JsonObject: TJsonObject;
begin
  JsonObject := TJsonObject.Create;
  try
    JsonObject.FromSimpleObject(Instance, LowerCamelCase);
    Result := JsonObject.ToString;
  finally
    JsonObject.Free;
  end;
end;

class function TJson.Parse(const Value: string; Compact: Boolean = True): string;
var
  JsonObject: TJsonObject;
  JsonValue: TJsonBaseObject;
begin
  JsonObject := TJsonObject.Create;
  try
    JsonValue := JsonObject.Parse(Value);
    try
      if JsonValue is TJsonObject then
        Result := (JsonValue as TJsonObject).ToJSON(Compact)
      else
      if JsonValue is TJsonArray then
        Result := (JsonValue as TJsonArray).ToJSON(Compact)
    finally
      JsonValue.Free;
    end;
  finally
    JsonObject.Free;
  end;
end;

class function TJson.Format(const Value: string): string;
const
  JSON_FORMATTED = False;
begin
  Result := TJson.Parse(Value, JSON_FORMATTED);
end;

class function TJson.JsonToObjectList<T>(const Value: string; ObjectList: TObjectList<T>; CaseSensitive: Boolean): Integer;
var
  JsonObject: TJsonObject;
  JsonParsed: TJsonBaseObject;
  JsonArray: TJsonArray;
  Item: T;
  I: Integer;
begin
  Result := 0;
  JsonObject := TJsonObject.Create;
  try
    JsonParsed := JsonObject.Parse(Value);
    try
      if (JsonParsed is TJsonArray) then
      begin
        JsonArray := JsonParsed as TJsonArray;
        for I := 0 to JsonArray.Count -1 do
        begin
          Item := TClass(T).Create as T;
          JsonArray.Items[I].ObjectValue.ToSimpleObject(Item, CaseSensitive);
          ObjectList.Add(Item)
        end;
        Result := JsonArray.Count;
      end;
    finally
      JsonParsed.Free;
    end;
  finally
    JsonObject.Free;
  end;
end;

end.
