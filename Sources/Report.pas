unit Report;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, PrintersDlgs, LR_Class, LR_DBSet,
  LR_View, LR_PGrid, Forms, Controls, Graphics, Dialogs,
  StdCtrls, DBGrids, ExtCtrls, DBCtrls;

type

  { TReportForm }

  TReportForm = class(TForm)
    PrintButton: TButton;
    DBReportNavigator: TDBNavigator;
    DBReportGrid: TDBGrid;
    DTPReportDS: TDataSource;
    frDTPDataSetReport: TfrDBDataSet;
    frDTPReport: TfrReport;
    frDTPPreview: TfrPreview;
    ReportPrintDialog: TPrintDialog;
    ReportPanel: TPanel;
    SQLDTPReport: TSQLQuery;
    procedure PrintButtonClick(Sender: TObject);
    procedure DTPReportDSDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  ReportForm: TReportForm;

implementation

{$R *.lfm}

{ TReportForm }

procedure TReportForm.DTPReportDSDataChange(Sender: TObject; Field: TField);
begin
  frDTPReport.ShowReport;
end;

procedure TReportForm.PrintButtonClick(Sender: TObject);
begin
  if frDTPReport.PrepareReport and ReportPrintDialog.Execute then
    frDTPReport.PrintPreparedReport('', 1);
end;

procedure TReportForm.FormCreate(Sender: TObject);
begin
  frDTPReport.LoadFromFile('report.lrf');
end;

procedure TReportForm.FormShow(Sender: TObject);
begin
  SQLDTPReport.Open;
end;

end.
