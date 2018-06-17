unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Menus, ExtCtrls, Metadata, Catalog, AccidentReg, Report;

type
  TDBMenuItem = class(TMenuItem)
  private
    fModalWin: TDirectory;
  public
    procedure MenuClick(Sender: TObject);
    constructor CreateMenu(TheOwner: TComponent);
  end;

  { TMainForm }

  TMainForm = class(TForm)
  published
    BackGround: TImage;
    MainMenu: TMainMenu;
    CatalogItem: TMenuItem;
    ActionItem: TMenuItem;
    StatisticsItem: TMenuItem;
    ReportItem: TMenuItem;
    FilledAccident: TMenuItem;
    NewAccident: TMenuItem;
    procedure FilledAccidentClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NewAccidentClick(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

procedure TDBMenuItem.MenuClick(Sender: TObject);
begin
  if not Checked then
  begin
    fModalWin := TDirectory.CreateCatalog(Self);
    Checked := True;
  end;

  fModalWin.ShowOnTop;
end;

constructor TDBMenuItem.CreateMenu(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Tag := TheOwner.Tag;
  Caption := Mdata.Tables[Tag].CaptionTable;
  OnClick := @MenuClick;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to High(Mdata.Tables) do
  begin
    Tag := i;
    if Mdata.Tables[i].ReadOnly then
      StatisticsItem.Add(TDBMenuItem.CreateMenu(Self))
    else
      CatalogItem.Add(TDBMenuItem.CreateMenu(Self));
  end;
end;

procedure TMainForm.FilledAccidentClick(Sender: TObject);
begin
  ReportForm.Show;
end;

procedure TMainForm.NewAccidentClick(Sender: TObject);
begin
  AccidentForm.Show;
end;

end.
