unit AccidentReg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, BufDataset, sqldb, SdfData, memds, FileUtil, Forms,
  Controls, Graphics, Dialogs, DBCtrls, DBGrids, ExtCtrls, PairSplitter,
  StdCtrls, Buttons, FileCtrl, ComCtrls, cef3types, cef3lib, cef3intf, cef3lcl,
  Catalog, cef3gui, Fpjson, jsonparser;

type

  { TAccidentForm }

  TAccidentForm = class(TForm)
    CommitChanges: TBitBtn;
    DTPCustomerDataSource: TDataSource;
    CustomerLookupCB: TDBLookupComboBox;
    CustomerLabel: TLabel;
    NumberEdit: TDBEdit;
    PlaceEdit: TDBEdit;
    LatEdit: TDBEdit;
    LngEdit: TDBEdit;
    DBNavigator: TDBNavigator;
    DTPCustomerSQLQuery: TSQLQuery;
    DescriptionMemo: TDBMemo;
    DTPDataSource: TDataSource;
    GoogleMap: TChromium;
    DTPPanel: TPanel;
    DTPSQLQuery: TSQLQuery;
    DescriptionLabel: TLabel;
    PlaceLabel: TLabel;
    NumberLabel: TLabel;
    LatLabel: TLabel;
    LngLabel: TLabel;
    DTPToolBar: TToolBar;
    CustomersToolButton: TToolButton;
    AutoToolButton: TToolButton;
    SanctionsToolButton: TToolButton;
    procedure CommitChangesClick(Sender: TObject);
    procedure DBNavigatorBeforeAction(Sender: TObject; Button: TDBNavButtonType);
    procedure DTPDataSourceDataChange(Sender: TObject; Field: TField);
    procedure DTPDataSourceStateChange(Sender: TObject);
    procedure DTPDataSourceUpdateData(Sender: TObject);
    procedure DTPSQLQueryAfterDelete(DataSet: TDataSet);
    procedure DTPSQLQueryAfterRefresh(DataSet: TDataSet);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GoogleMapBeforePopup(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
      targetDisposition: TCefWindowOpenDisposition; userGesture: boolean;
      var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var client: ICefClient; var settings: TCefBrowserSettings;
      var noJavascriptAccess: boolean; out Result: boolean);
    procedure GoogleMapConsoleMessage(Sender: TObject;
      const Browser: ICefBrowser; const message, Source: ustring;
      line: integer; out Result: boolean);
    procedure GoogleMapLoadEnd(Sender: TObject; const Browser: ICefBrowser;
      const Frame: ICefFrame; httpStatusCode: integer);
    procedure CustomersToolButtonClick(Sender: TObject);
    procedure AutoToolButtonClick(Sender: TObject);
    procedure SanctionsToolButtonClick(Sender: TObject);
  private
    procedure MoveGoogleMark();
  public

  end;

var
  AccidentForm: TAccidentForm;

implementation

{$R *.lfm}

{ TAccidentForm }

procedure TAccidentForm.MoveGoogleMark();
const
  Coord: string = 'marker.setPosition({lat: %g, lng: %g});';
var
  ds: char;
  c: string;
  flat, flng: TField;
begin
  flat := DTPSQLQuery.FieldByName('Широта');
  flng := DTPSQLQuery.FieldByName('Долгота');
  if (flat.IsNull or flng.IsNull) then
    exit;
  ds := DecimalSeparator;
  DecimalSeparator := '.';
  try
    c := Format(Coord, [flat.AsFloat, flng.AsFloat]);
    GoogleMap.Browser.MainFrame.ExecuteJavaScript(c, 'about:blank', 0);
  finally
    DecimalSeparator := ds;
  end;
end;

procedure TAccidentForm.FormCreate(Sender: TObject);
begin
  {$IFDEF DARWIN}
  // Uncomment for a single process application
  //CefSingleProcess := True;
  {$ELSE}
    {$INFO subprocess is set here, comment out to use the main program as subprocess}
  CefBrowserSubprocessPath := '.' + PathDelim + 'subprocess'
{$IFDEF WINDOWS}
    + '.exe'
{$ENDIF}
  ;
  {$ENDIF}
  GoogleMap.DefaultUrl := GetCurrentDir + PathDelim + 'maps_tamplate.html';
  DTPCustomerSQLQuery.Open;
  DTPSQLQuery.Open;
end;

procedure TAccidentForm.DTPDataSourceDataChange(Sender: TObject; Field: TField);
begin
  if (GoogleMap.Browser <> nil) then
    MoveGoogleMark;
end;

procedure TAccidentForm.DTPDataSourceStateChange(Sender: TObject);
begin
  CommitChanges.Enabled := (DTPSQLQuery.ChangeCount > 0) or
    (DTPSQLQuery.State in [dsEdit, dsInsert]);
end;

procedure TAccidentForm.DTPDataSourceUpdateData(Sender: TObject);
begin
  // TODO: Так лучше не делать
  NumberEdit.Field.Required := False;
end;

procedure TAccidentForm.DTPSQLQueryAfterDelete(DataSet: TDataSet);
begin
  CommitChanges.Enabled := True;
end;

procedure TAccidentForm.DTPSQLQueryAfterRefresh(DataSet: TDataSet);
begin
  CommitChanges.Enabled := False;
end;

procedure TAccidentForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
const
  q = 'Внесенные изменения не будут сохранены, выйти?';
begin
  if (DTPSQLQuery.State = dsBrowse) and (DTPSQLQuery.ChangeCount = 0) then
    CanClose := True
  else
  if MessageDlg(q, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    DTPSQLQuery.CancelUpdates;
    CanClose := True;
  end
  else
    CanClose := False;
end;

procedure TAccidentForm.CommitChangesClick(Sender: TObject);
begin
  try
    DTPSQLQuery.ApplyUpdates;
    DTPSQLQuery.SQLTransaction.CommitRetaining;
    CommitChanges.Enabled := False;
  except
    // TODO: Обработать все исключения
    on e: EDatabaseError do
      MessageDlg('Произошла ошибка при применении изменений', mtError, [mbOK], 0);
  end;
end;

procedure TAccidentForm.DBNavigatorBeforeAction(Sender: TObject;
  Button: TDBNavButtonType);
begin
  case Button of
    nbRefresh:
      DTPSQLQuery.CancelUpdates;
    nbDelete: if MessageDlg(
        'Вы дейтсвительно хотите удалить ДТП?',
        mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        Abort;
  end;
end;

procedure TAccidentForm.FormShow(Sender: TObject);
begin
  DTPCustomerSQLQuery.Refresh;
  DTPSQLQuery.Refresh;
end;

procedure TAccidentForm.GoogleMapBeforePopup(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const targetUrl, targetFrameName: ustring;
  targetDisposition: TCefWindowOpenDisposition; userGesture: boolean;
  var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
  var client: ICefClient; var settings: TCefBrowserSettings;
  var noJavascriptAccess: boolean; out Result: boolean);
begin
  Result := True;
end;

procedure TAccidentForm.GoogleMapConsoleMessage(Sender: TObject;
  const Browser: ICefBrowser; const message, Source: ustring;
  line: integer; out Result: boolean);
var
  J: TJSONData;
  lat, lng: double;
begin
  try
    J := GetJSON(UTF8Encode(message));
    try
      lat := J.FindPath('lat').AsFloat;
      lng := J.FindPath('lng').AsFloat;
    finally
      J.Free;
    end;
    if not (DTPSQLQuery.State in [dsEdit, dsInsert]) then
      DTPSQLQuery.Edit;
    LatEdit.Field.Value := lat;
    LngEdit.Field.Value := lng;
    Result := True;
  except
    // TODO: Обработать исключение
  end;
end;

procedure TAccidentForm.GoogleMapLoadEnd(Sender: TObject;
  const Browser: ICefBrowser; const Frame: ICefFrame; httpStatusCode: integer);
begin
  MoveGoogleMark;
end;

procedure TAccidentForm.CustomersToolButtonClick(Sender: TObject);
var
  cat: TDirectory;
begin
  cat := TDirectory.CreateCatalogByName(Self, 'УчастникиПешеходы');
  cat.Position := poOwnerFormCenter;
  cat.ShowModal;
end;

procedure TAccidentForm.AutoToolButtonClick(Sender: TObject);
var
  cat: TDirectory;
begin
  cat := TDirectory.CreateCatalogByName(Self,
    'УчастникиАвтомобили');
  cat.Position := poOwnerFormCenter;
  cat.ShowModal;
end;

procedure TAccidentForm.SanctionsToolButtonClick(Sender: TObject);
var
  cat: TDirectory;
begin
  cat := TDirectory.CreateCatalogByName(Self, 'Штрафы');
  cat.Position := poOwnerFormCenter;
  cat.ShowModal;
end;

end.
