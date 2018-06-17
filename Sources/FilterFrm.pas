unit FilterFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, FileCtrl, Buttons, StdCtrls,
  MiniFilterFrm, NameFrm;

type
  TFilterFrame = class(TNamedFrame)
  published
    FilterVar: TFilterComboBox;
    MiniFilterFrame1: TMiniFilterFrame;
    RemoveFilter: TSpeedButton;
    function CompileFilter: string;
    procedure RemoveFilterClick(Sender: TObject);
  end;

implementation

{$R *.lfm}

function TFilterFrame.CompileFilter: string;
begin
  Result := FilterVar.Mask + MiniFilterFrame1.CompileFilter;
end;

procedure TFilterFrame.RemoveFilterClick(Sender: TObject);
begin
  Free;
end;

end.
