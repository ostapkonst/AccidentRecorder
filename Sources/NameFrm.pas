unit NameFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls;

type
  TNamedFrame = class(TFrame)
  published
    constructor Create(TheOwner: TWinControl);
  end;

implementation

constructor TNamedFrame.Create(TheOwner: TWinControl);
begin
  inherited Create(TheOwner);
  Parent := TheOwner;
  Name := '_' + IntToStr(cardinal(Self));
end;

end.
