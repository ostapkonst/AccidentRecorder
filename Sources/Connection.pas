unit Connection;

{$mode objfpc}{$H+}

interface

uses
  Classes, IBConnection, sqldb, sqlite3conn;

type

  { TSQLite }

  TSQLite = class(TDataModule)
  published
    SQLite3Connection: TSQLite3Connection;
    SQLTransact: TSQLTransaction;
  end;

var
  SQLite: TSQLite;

implementation

{$R *.lfm}

end.
