unit MiniFilterFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ShortPathEdit, Forms, Controls, StdCtrls,
  FileCtrl, Metadata;

type
  TMiniFilterFrame = class(TFrame)
  published
    FilterEdit: TEdit;
    FilterWay: TFilterComboBox;
    FilterField: TFilterComboBox;
    constructor Create(TheOwner: TComponent); override;
    function CompileFilter: string;
  end;

implementation

{$R *.lfm}

function GetFilterFields(aTable: TTable): string;
const
  CQuery = '%s| %s.%s |';
var
  i: integer;
begin
  Result := '';
  with aTable do
    for i := 0 to High(Columns) do
      with Columns[i] do
        if Primary then
          Result += Format(CQuery, [CaptionField, KeyTable, ListField])
        else
          Result += Format(CQuery, [CaptionField, NameTable, DataField]);

  Result := LeftStr(Result, Length(Result) - 1);
end;

constructor TMiniFilterFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FilterField.Filter := GetFilterFields(Mdata.Tables[TheOwner.Tag]);
end;

function TMiniFilterFrame.CompileFilter: string;
begin
  Result := FilterField.Mask + FilterWay.Mask + '''' + FilterEdit.Text + '''';
end;

end.
