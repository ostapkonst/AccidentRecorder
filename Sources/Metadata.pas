unit Metadata;

{$mode objfpc}{$H+}

interface

type
  TColumns = record
    DataField: string;
    CaptionField: string;
    ListField: string;
    KeyTable: string;
    KeyField: string;
    Primary: boolean;
  end;

  TTable = record
    NameTable: string;
    CaptionTable: string;
    ReadOnly: boolean;
    Columns: array of TColumns;
  end;

  DBMetadata = class
  public
    Tables: array of TTable;
  private
    procedure AddTable(aNameTable, aCaptionTable: string);
    procedure AddStatics(aNameTable, aCaptionTable: string);
    procedure AddColumn(aDataField, aCaptionField: string);
    procedure AddKey(aDataField, aCaptionField, aListField, aKeyTable,
      aKeyField: string);
  end;

var
  Mdata: DBMetadata;

implementation

procedure DBMetadata.AddTable(aNameTable, aCaptionTable: string);
begin
  SetLength(Tables, Length(Tables) + 1);
  with Tables[High(Tables)] do
  begin
    NameTable := aNameTable;
    CaptionTable := aCaptionTable;
  end;
end;

procedure DBMetadata.AddStatics(aNameTable, aCaptionTable: string);
begin
  SetLength(Tables, Length(Tables) + 1);
  with Tables[High(Tables)] do
  begin
    NameTable := aNameTable;
    CaptionTable := aCaptionTable;
    ReadOnly := True;
  end;
end;

procedure DBMetadata.AddColumn(aDataField, aCaptionField: string);
begin
  with Tables[High(Tables)] do
  begin
    SetLength(Columns, Length(Columns) + 1);
    with Columns[High(Columns)] do
    begin
      DataField := aDataField;
      CaptionField := aCaptionField;
      Primary := False;
    end;
  end;
end;

procedure DBMetadata.AddKey(aDataField, aCaptionField, aListField,
  aKeyTable, aKeyField: string);
begin
  with Tables[High(Tables)] do
  begin
    SetLength(Columns, Length(Columns) + 1);
    with Columns[High(Columns)] do
    begin
      DataField := aDataField;
      CaptionField := aCaptionField;
      ListField := aListField;
      KeyTable := aKeyTable;
      KeyField := aKeyField;
      Primary := True;
    end;
  end;
end;

initialization

  Mdata := DBMetadata.Create;
  with Mdata do
  begin
    AddTable('Модель', 'Модели автомобилей');
    AddColumn('Категория', 'Категория');
    AddColumn('Наименование', 'Наименование');

    AddTable('Цвет', 'Цвета автомобилей');
    AddColumn('Название', 'Название');

    AddTable('Машина', 'Машины с ПТС');
    AddColumn('ПТС', 'ПТС');
    AddKey('НомерМодели', 'Номер модели',
      'Наименование', 'Модель', 'НомерМодели');
    AddKey('НомерЦвета', 'Номер цвета', 'Название',
      'Цвет', 'НомерЦвета');
    AddColumn('VIN', 'VIN');
    AddColumn('НомерКузова', 'Номер кузова');
    AddColumn('НомерДвигателя', 'Номер двигателя');
    AddColumn('ГодВыпуска', 'Год выпуска');

    AddTable('ФизическоеЛицо', 'Физические лица');
    AddColumn('Паспорт', 'Паспорт');
    AddColumn('ФИО', 'Ф.И.О.');
    AddColumn('АдресПроживания', 'Адрес проживания');
    AddColumn('ДатаРождения', 'Дата рожения');

    AddTable('Сотрудник', 'Сотрудники');
    AddColumn('ФИО', 'Ф.И.О.');
    AddColumn('Должность', 'Должность');
    AddColumn('Звание', 'Звание');

    AddTable('Водитель', 'Водители');
    AddKey('Паспорт', 'Ф.И.О', 'ФИО', 'ФизическоеЛицо',
      'Паспорт');
    AddColumn('ВодительскиеПрава',
      'ВодительскиеПрава');

    AddTable('СвидетельствоТС',
      'Свидетельство о регистрации ТС');
    AddColumn('Госномер', 'Госномер');
    AddKey('Паспорт', 'Ф.И.О', 'ФИО', 'ФизическоеЛицо',
      'Паспорт');
    AddKey('ПТС', 'VIN', 'VIN', 'Машина', 'ПТС');
    AddColumn('ДатаРегистрации', 'Дата регистрации');

    AddTable('ТипНарушения', 'Типы нарушений');
    AddColumn('Название', 'Название');
    AddColumn('РазмерШтрафа', 'Размер штрафа');

    AddTable('ТипУчастника', 'Типы участников');
    AddColumn('Статус', 'Статус');

    AddTable('ДТП', 'Дорожно-транспортные происшествия');
    AddColumn('Протокол', 'Протокол');
    AddKey('НомерСотрудника', 'Ф.И.О Сотрудника',
      'ФИО', 'Сотрудник', 'НомерСотрудника');
    AddColumn('МестоПроисшествия',
      'Место происшествия');
    AddColumn('Описание', 'Описание');
    AddColumn('Дата', 'Дата');
    // TODO: Нужно модифицировать процедуру генерации запроса
    //AddColumn('Широта', 'Широта');
    //AddColumn('Долгота', 'Долгота');

    AddTable('УчастникиПешеходы',
      'Участвующие в ДТП пешеходы');
    AddKey('Протокол', 'Протокол', 'Протокол',
      'ДТП', 'Протокол');
    AddKey('Паспорт', 'Ф.И.О', 'ФИО', 'ФизическоеЛицо',
      'Паспорт');
    AddKey('НомерТипаУчастника', 'Статус',
      'Статус', 'ТипУчастника',
      'НомерТипаУчастника');

    AddTable('УчастникиАвтомобили',
      'Участвующие в ДТП автомобили');
    AddKey('Протокол', 'Протокол', 'Протокол',
      'ДТП', 'Протокол');
    AddKey('Госномер', 'Госномер', 'Госномер',
      'СвидетельствоТС', 'Госномер');
    AddKey('Водитель', 'Ф.И.О Водителя', 'ФИО',
      'ФизическоеЛицо', 'Паспорт');
    AddKey('НомерТипаУчастника', 'Статус',
      'Статус', 'ТипУчастника',
      'НомерТипаУчастника');

    AddTable('Штрафы', 'Штрафы за ДТП');
    AddKey('Протокол', 'Протокол', 'Протокол',
      'ДТП', 'Протокол');
    AddKey('НомерТипаНарушения', 'Тип нарушения',
      'Название', 'ТипНарушения',
      'НомерТипаНарушения');

    AddStatics('РейтингСотрудников',
      'Рейтинг сотрудников');
    AddColumn('Сотрудник', 'Ф.И.О Сотрудника');
    AddColumn('ВсегоПротоколов', 'Всего протоколов');
    AddColumn('СуммаШтрафов', 'Сумма штрафов');


    AddStatics('РейтингВиновников',
      'Рейтинг виновников');
    AddColumn('Виновник', 'Ф.И.О Виновника');
    AddColumn('Паспорт', 'Паспорт');
    AddColumn('ВодительскиеПрава',
      'Водительские права');
    AddColumn('КоличествоДТП', 'Всего совершено ДТП');
    AddColumn('ШтрафовНаСумму', 'Сумма штрафов');
  end;

end.
