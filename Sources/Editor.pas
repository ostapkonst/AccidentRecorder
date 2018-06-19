unit Editor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, Forms, Dialogs, StdCtrls, Buttons, Metadata,
  EditFrm, BoxFrm;

type

  { TCellEditor }

  TCellEditor = class(TForm)
    SQLTransaction: TSQLTransaction;
  private
    fSQLQuery: TSQLQuery;
  published
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DataSource: TDataSource;
    EditPanel: TGroupBox;
    ControlPanel: TGroupBox;
    Save: TSpeedButton;
    Cancel: TSpeedButton;
    SQLQuery: TSQLQuery;
    procedure CancelBtnClick(Sender: TObject);
    constructor CreateOnly(TheOwner: TComponent; aTable: TTable;
      aSQLQuery: TSQLQuery);
    constructor CreateAndAdd(TheOwner: TComponent; aTable: TTable;
      aSQLQuery: TSQLQuery);
    constructor CreateAndEdit(TheOwner: TComponent; aTable: TTable;
      aSQLQuery: TSQLQuery);
    constructor CreateAndDel(TheOwner: TComponent; aTable: TTable;
      aSQLQuery: TSQLQuery);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure SaveBtnClick(Sender: TObject);
  end;

implementation

{$R *.lfm}

function GenSelectSQL(aTable: TTable): string;
var
  i: integer;
begin
  Result := 'SELECT ';
  with aTable do
    for i := 0 to High(Columns) do
    begin
      if i > 0 then
        Result += ', ';
      Result += Columns[i].DataField;
    end;
end;

function GenWhereSQL(aTable: TTable; aSQLQuery: TSQLQuery): string;
const
  CQuery = ' %s = ''%s''';
  CNullQuery = ' %s IS NULL';
var
  i: integer;
  fl: TField;
begin
  Result := 'WHERE';
  with aTable do
    for i := 0 to High(Columns) do
    begin
      if i > 0 then
        Result += ' AND';
      with Columns[i] do
      begin
        fl := aSQLQuery.FieldByName(DataField);
        if fl.IsNull then
          Result += Format(CNullQuery, [DataField])
        else
          Result += Format(CQuery, [DataField, fl.Text]);
      end;
    end;
end;

function GenFromSQL(aTable: TTable): string;
begin
  Result := 'FROM ' + aTable.NameTable;
end;

constructor TCellEditor.CreateOnly(TheOwner: TComponent; aTable: TTable;
  aSQLQuery: TSQLQuery);
var
  i: integer;
begin
  inherited Create(TheOwner);
  fSQLQuery := aSQLQuery;

  with aTable do
  begin
    Caption := 'Редактор таблицы "' + CaptionTable + '"';
    for i := 0 to High(Columns) do
      if Columns[i].Primary then
        TBoxFrame.Create(EditPanel, Columns[i])
      else
        TEditFrame.Create(EditPanel, Columns[i]);
  end;

  // TODO: Разобраться с транзакциями
  //SQLQuery.SQLTransaction.StartTransaction;
  SQLQuery.SQL.Append(GenSelectSQL(aTable));
  SQLQuery.SQL.Append(GenFromSQL(aTable));
  SQLQuery.SQL.Append(GenWhereSQL(aTable, aSQLQuery));
  // Текст запроса
  //Dialogs.ShowMessage(SQLQuery.SQL.Text);
  SQLQuery.Open;
end;

constructor TCellEditor.CreateAndAdd(TheOwner: TComponent; aTable: TTable;
  aSQLQuery: TSQLQuery);
begin
  CreateOnly(TheOwner, aTable, aSQLQuery);
  SQLQuery.Insert;
end;

constructor TCellEditor.CreateAndEdit(TheOwner: TComponent; aTable: TTable;
  aSQLQuery: TSQLQuery);
begin
  CreateOnly(TheOwner, aTable, aSQLQuery);
end;

constructor TCellEditor.CreateAndDel(TheOwner: TComponent; aTable: TTable;
  aSQLQuery: TSQLQuery);
begin
  CreateOnly(TheOwner, aTable, aSQLQuery);
  try
    SQLQuery.Delete;
  except
    // TODO: Обработать все исключения
    on e: EDatabaseError do
      MessageDlg('Не удалось удалить выбранную запись',
        mtError, [mbOK], 0);
  end;
  SaveBtnClick(Self);
end;

procedure TCellEditor.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TCellEditor.SaveBtnClick(Sender: TObject);
begin
  try
    SQLQuery.ApplyUpdates;
    // Если через Commit, то закрыватеся TSQLQuery
    SQLQuery.SQLTransaction.CommitRetaining;
    fSQLQuery.Refresh;
    Close;
  except
    // TODO: Обработать все исключения
    on e: EDatabaseError do
      MessageDlg('Произошла ошибка при применении изменений', mtError, [mbOK], 0);
  end;
end;

procedure TCellEditor.CancelBtnClick(Sender: TObject);
begin
  SQLQuery.SQLTransaction.RollbackRetaining;
  fSQLQuery.Refresh;
  Close;
end;

end.
