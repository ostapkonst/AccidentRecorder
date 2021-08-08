# AccidentRecorder
Клиентское приложение для БД ГИБДД реализовано на Lazarus версии 1.8.4 с использованием сервисов Google Maps и дополнительных компонентов: fpCEF (для отображения карт) и LazReport (для визуализации формы постановления).
Сама БД была реализована в СУБД SQLite при помощи SQLiteStudio версии 3.1.1.
Для решения задач управления постановлениями о ДТП, создано несколько форм с удобным интерфейсом, позволяющие решать типовые задачи.
Он состоит из таблиц, для вывода данных из БД, элементов управления данными и навигации по таблице.
Каждая форма имеет собственный функциональный набор.
Навигация по существующим формам осуществляется через меню основного окна программы.
## Результат работы
В качестве выходной информации выступает постановление о ДТП, данные в котором формируются в СУБД при помощи представления «ОформленныеПостановления», а отображаются в форме клиентского приложения при помощи компонента LazReport.
