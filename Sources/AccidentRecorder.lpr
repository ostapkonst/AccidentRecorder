program AccidentRecorder;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  lazcontrols,
  sdflaz,
  memdslaz, printer4lazarus,
  Main,
  Connection,
  Metadata,
  Catalog,
  Editor,
  MiniFilterFrm,
  NameFrm,
  EditFrm,
  BoxFrm,
  FilterFrm,
  AccidentReg,
  Report;

{$R *.res}

begin
  Application.Title := 'Регистрация ДТП (Курсовая '
    + 'работа)';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSQLite, SQLite);
  Application.CreateForm(TAccidentForm, AccidentForm);
  Application.CreateForm(TReportForm, ReportForm);
  Application.Run;
end.
