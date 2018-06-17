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
end;

procedure TAccidentForm.DTPDataSourceDataChange(Sender: TObject; Field: TField);
begin
  if not (GoogleMap.Browser.IsLoading) then
    MoveGoogleMark;
end;

procedure TAccidentForm.CommitChangesClick(Sender: TObject);
begin
  DTPSQLQuery.ApplyUpdates;
  DTPSQLQuery.SQLTransaction.CommitRetaining;
  AccidentForm.Close;
end;

procedure TAccidentForm.DBNavigatorBeforeAction(Sender: TObject;
  Button: TDBNavButtonType);
begin
  case Button of
    nbRefresh: if (DTPSQLQuery.State in [dsEdit, dsInsert]) then
        DTPSQLQuery.CancelUpdates;
    nbDelete: if MessageDlg(
        'Вы дейтсвительно хотите удалить ДТП?',
        mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        Abort;
  end;
end;

procedure TAccidentForm.FormShow(Sender: TObject);
begin
  DTPCustomerSQLQuery.Open;
  DTPSQLQuery.Open;
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
  J := GetJSON(UTF8Encode(message));
  lat := J.FindPath('lat').AsFloat;
  lng := J.FindPath('lng').AsFloat;
  J.Free;
  if not (DTPSQLQuery.State in [dsEdit, dsInsert]) then
    DTPSQLQuery.Edit;
  LatEdit.Field.Value := lat;
  LngEdit.Field.Value := lng;
  Result := True;
end;

procedure TAccidentForm.GoogleMapLoadEnd(Sender: TObject;
  const Browser: ICefBrowser; const Frame: ICefFrame; httpStatusCode: integer);
begin
  MoveGoogleMark;
end;

procedure TAccidentForm.CustomersToolButtonClick(Sender: TObject);
begin
  TDirectory.CreateCatalogByName(Self, 'УчастникиПешеходы').ShowModal;
end;

procedure TAccidentForm.AutoToolButtonClick(Sender: TObject);
begin
  TDirectory.CreateCatalogByName(Self,
    'УчастникиАвтомобили').ShowModal;
end;

procedure TAccidentForm.SanctionsToolButtonClick(Sender: TObject);
begin
  TDirectory.CreateCatalogByName(Self, 'Штрафы').ShowModal;
end;

end.
