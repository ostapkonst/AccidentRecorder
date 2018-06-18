--
-- Файл сгенерирован с помощью SQLiteStudio v3.1.1 в Пн июн 18 22:56:15 2018
--
-- Использованная кодировка текста: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Таблица: Водитель
CREATE TABLE Водитель (Паспорт VARCHAR PRIMARY KEY REFERENCES ФизическоеЛицо (Паспорт) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL, ВодительскиеПрава VARCHAR UNIQUE);

-- Таблица: ДТП
CREATE TABLE ДТП (Постановление VARCHAR PRIMARY KEY NOT NULL, НомерСотрудника VARCHAR REFERENCES Сотрудник (НомерСотрудника) ON DELETE CASCADE ON UPDATE CASCADE, МестоПроисшествия VARCHAR, Описание VARCHAR, Дата VARCHAR DEFAULT (strftime('%d.%m.%Y', 'now')), Широта REAL, Долгота REAL);

-- Таблица: Машина
CREATE TABLE Машина (ПТС VARCHAR PRIMARY KEY NOT NULL, НомерМодели INTEGER REFERENCES Модель (НомерМодели) ON DELETE CASCADE ON UPDATE CASCADE, НомерЦвета INTEGER REFERENCES Цвет (НомерЦвета) ON DELETE CASCADE ON UPDATE CASCADE, VIN VARCHAR UNIQUE, НомерКузова VARCHAR UNIQUE, НомерДвигателя VARCHAR UNIQUE, ГодВыпуска VARCHAR);

-- Таблица: Модель
CREATE TABLE Модель (НомерМодели INTEGER NOT NULL PRIMARY KEY, Наименование VARCHAR UNIQUE, Категория VARCHAR);

-- Таблица: СвидетельствоТС
CREATE TABLE СвидетельствоТС (Госномер VARCHAR PRIMARY KEY, Паспорт VARCHAR REFERENCES ФизическоеЛицо (Паспорт) ON DELETE CASCADE ON UPDATE CASCADE, ПТС VARCHAR REFERENCES Машина (ПТС) ON DELETE CASCADE ON UPDATE CASCADE, ДатаРегистрации VARCHAR);

-- Таблица: Сотрудник
CREATE TABLE Сотрудник (НомерСотрудника INTEGER PRIMARY KEY NOT NULL, ФИО VARCHAR, Должность VARCHAR, Звание VARCHAR);

-- Таблица: ТипНарушения
CREATE TABLE ТипНарушения (НомерТипаНарушения INTEGER NOT NULL PRIMARY KEY, Название VARCHAR, РазмерШтрафа INTEGER, КоАП VARCHAR);

-- Таблица: ТипУчастника
CREATE TABLE ТипУчастника (НомерТипаУчастника INTEGER PRIMARY KEY NOT NULL, Статус VARCHAR UNIQUE);

-- Таблица: УчастникиАвтомобили
CREATE TABLE УчастникиАвтомобили (Постановление VARCHAR REFERENCES ДТП (Постановление) ON DELETE CASCADE ON UPDATE CASCADE, Госномер VARCHAR REFERENCES СвидетельствоТС (Госномер) ON DELETE CASCADE ON UPDATE CASCADE, Паспорт VARCHAR REFERENCES ФизическоеЛицо (Паспорт) ON DELETE CASCADE ON UPDATE CASCADE, НомерТипаУчастника INTEGER REFERENCES ТипУчастника (НомерТипаУчастника) ON DELETE CASCADE ON UPDATE CASCADE);

-- Таблица: УчастникиПешеходы
CREATE TABLE УчастникиПешеходы (Постановление VARCHAR REFERENCES ДТП (Постановление) ON DELETE CASCADE ON UPDATE CASCADE, Паспорт VARCHAR REFERENCES ФизическоеЛицо (Паспорт) ON DELETE CASCADE ON UPDATE CASCADE, НомерТипаУчастника INTEGER REFERENCES ТипУчастника (НомерТипаУчастника) ON DELETE CASCADE ON UPDATE CASCADE);

-- Таблица: ФизическоеЛицо
CREATE TABLE ФизическоеЛицо (Паспорт VARCHAR PRIMARY KEY NOT NULL, ФИО VARCHAR, АдресПроживания VARCHAR, ДатаРождения VARCHAR);

-- Таблица: Цвет
CREATE TABLE Цвет (НомерЦвета INTEGER NOT NULL PRIMARY KEY, Название VARCHAR UNIQUE);

-- Таблица: Штрафы
CREATE TABLE Штрафы (Постановление VARCHAR REFERENCES ДТП (Постановление) ON DELETE CASCADE ON UPDATE CASCADE, НомерТипаНарушения INTEGER REFERENCES ТипНарушения (НомерТипаНарушения) ON DELETE CASCADE ON UPDATE CASCADE);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
