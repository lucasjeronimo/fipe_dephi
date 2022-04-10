Delphi Fluent REST Client
=================

* Interface Based
* Uses Delphi REST Components 
* Uses Json Data Objects
* Flexible and extensible
* Very easy to use
* MIT License (MIT)
* Tested only in Delphi Seattle and Berlin, should work for Delphi XE5, XE6, XE7 and better after XE8

[CodeRage XI presentation](http://www.slideshare.net/CesarRomero42/fluent-rest-client-interface-using-delphi-rest-client-components)


Clone with Mercurial
--------------
```
> hg clone https://bitbucket.org/cesarliws/delphi-fluent-rest-client
```
or use [TortoiseHg](http://tortoisehg.bitbucket.org/)

Usage
-----
Simple example
```Delphi

uses
  Foundation.Fluent.REST.Client;

procedure TFluentRestClientForm.WhatIsMyIpButtonClick(Sender: TObject);
begin
  ResponseMemo.Lines.Text := RestBuilder
    .CreateRequest
    .Resource('http://ip.jsontest.com')
    .Get
    .ResponseContent;
end;
```

```JSON
{	
	"ip": "170.190.222.104"
}
```
