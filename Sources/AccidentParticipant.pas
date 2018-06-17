unit AccidentParticipant;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Catalog;

type

  { TParticipants }

  TParticipants = class(TForm)
    ListOfCarsButton: TButton;
    ListOfPeopleButton: TButton;
    DescriptionLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ListOfCarsButtonClick(Sender: TObject);
    procedure ListOfPeopleButtonClick(Sender: TObject);
  private
    fModalWin: TDirectory;
  public
    { public declarations }
  end;

var
  Participants: TParticipants;

implementation

{$R *.lfm}

{ TParticipants }

procedure TParticipants.ListOfCarsButtonClick(Sender: TObject);
begin
  fModalWin := TDirectory.CreateCatalogByName(Self,
    'УчастникиАвтомобили');
  fModalWin.ShowModal;
end;

procedure TParticipants.FormCreate(Sender: TObject);
begin

end;

procedure TParticipants.ListOfPeopleButtonClick(Sender: TObject);
begin
  fModalWin := TDirectory.CreateCatalogByName(Self,
    'УчастникиПешеходы');
  fModalWin.ShowModal;
end;

end.
