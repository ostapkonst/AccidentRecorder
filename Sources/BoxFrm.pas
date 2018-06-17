unit BoxFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, StdCtrls, DBCtrls,
  NameFrm, Metadata;

type
  TBoxFrame = class(TNamedFrame)
  published
    ListSource: TDataSource;
    DBLComboBox: TDBLookupComboBox;
    FieldName: TLabel;
    SQLQuery: TSQLQuery;
    constructor Create(TheOwner: TWinControl; aColumn: TColumns);
  end;

implementation

{$R *.lfm}

constructor TBoxFrame.Create(TheOwner: TWinControl; aColumn: TColumns);
const
  CQuary = 'SELECT %s, %s FROM %s';
begin
  inherited Create(TheOwner);
  with aColumn do
  begin
    FieldName.Caption := CaptionField;
    DBLComboBox.DataField := DataField;
    DBLComboBox.KeyField := KeyField;
    DBLComboBox.ListField := ListField;
    SQLQuery.SQL.Append(Format(CQuary, [KeyField, ListField, KeyTable]));
  end;
  SQLQuery.Open;
end;

end.
