unit EditFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, DBCtrls, NameFrm,
  Metadata;

type
  TEditFrame = class(TNamedFrame)
  published
    FieldEditor: TDBEdit;
    FieldName: TLabel;
    constructor Create(TheOwner: TWinControl; aColumn: TColumns);
  end;

implementation

{$R *.lfm}

constructor TEditFrame.Create(TheOwner: TWinControl; aColumn: TColumns);
begin
  inherited Create(TheOwner);
  FieldName.Caption := aColumn.CaptionField;
  FieldEditor.DataField := aColumn.DataField;
end;

end.
