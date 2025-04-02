#include "applicationengine.h"
#include <QDebug>
#include <qsqltablemodel.h>

bool _ApplicationEngine::open = false;

// Конструктор
_ApplicationEngine::_ApplicationEngine()
{

    if(!open){
    //  Создаем соединение
    main_sql = QSqlDatabase::addDatabase("QSQLITE");
    main_sql.setDatabaseName("FineraDB.db");

    // Открываем соединение
    if (!main_sql.open()) {
        qDebug() << "ERROR: Failed to open database:" << main_sql.lastError().text();
        return;
    }


    main_query = new QSqlQuery(main_sql);

    // Создаем таблицы, если они не существуют
    QString income = R"(
        CREATE TABLE IF NOT EXISTS "income" (
            "Id" INTEGER NOT NULL UNIQUE,
            "Year" INTEGER,
            "Month" VARCHAR(15),
            "Day" INTEGER,
            "Total" INTEGER,
            PRIMARY KEY("Id")
        );
    )";

    QString expenses = R"(
        CREATE TABLE IF NOT EXISTS "expenses" (
            "Id" INTEGER NOT NULL UNIQUE,
            "Year" INTEGER,
            "Month" VARCHAR(15),
            "Day" INTEGER,
            "Expenses" INTEGER,
            "About" Text,
            PRIMARY KEY("Id")
        );
    )";

    QString target=R"(
        CREATE TABLE IF NOT EXISTS "target" (
            "Id" INTEGER NOT NULL UNIQUE,
            "Name" TEXT,
            "FinalTotal" VARCHAR(10),
            "CurrentBalance" VARCHAR(10),
            "About" Text,
            PRIMARY KEY("Id")
        );
    )";

    if (!main_query->exec(income)) {
        qDebug() << "ERROR: Failed to create 'income' table: " << main_query->lastError().text();
    }

    if (!main_query->exec(expenses)) {
        qDebug() << "ERROR: Failed to create 'expenses' table:" << main_query->lastError().text();
    }


    if(!main_query->exec(target)){
        qDebug() << "ERROR: Failed to create 'target' table:" << main_query->lastError().text();
    }
        open=true;
    }
}

// Деструктор
_ApplicationEngine::~_ApplicationEngine()
{
    // Закрываем соединение при уничтожении объекта
    if (main_sql.isOpen()) {
        main_sql.close();
        qDebug() << "Database connection closed";
    }
    delete main_query;
}


QVariantMap _ApplicationEngine::getStatisticYearChart(int year, const QString& tableName,const QString colName)
{
    QVariantMap resultMap;
    QSqlQueryModel queryModel; // Автоматическая переменная, чтобы не заботиться об удалении
    QSqlQuery query(main_sql); // Явное указание соединения

    // Формируем SQL-запрос с использованием placeholders
    QString queryRequest = QString(R"(
        SELECT "Month", SUM("%1") AS TotalSum
        FROM "%2"
        WHERE Year = %3
        GROUP BY "Month"
        ORDER BY "Month"
    )").arg(colName).arg(tableName).arg(year);


    query.prepare(queryRequest);

    if (!query.exec()) {
        qDebug() << "ERROR executing query:" << main_query->lastError().text();
        return resultMap;  // Возвращаем пустую карту в случае ошибки
    }

    queryModel.setQuery(std::move(query));


    if (queryModel.lastError().isValid()) {
        qDebug() << "ERROR from QSqlQueryModel:" << queryModel.lastError().text();
    }

    // Проходим по результатам запроса
    for (int i = 0; i < queryModel.rowCount(); ++i) {
        // Получаем данные из модели
        QString month = queryModel.data(queryModel.index(i, 0)).toString();
        int totalSum = queryModel.data(queryModel.index(i, 1)).toInt();

        // Добавляем данные в QVariantMap
        resultMap.insert(month, totalSum);
    }

    return resultMap;
}

QAbstractTableModel *_ApplicationEngine::getTable(const QString request)
{

    qDebug()<<request;
    // Создаем QSqlQuery с существующим соединением
    QSqlQuery query(main_sql);

    // Подготавливаем запрос
    query.prepare(request);

    // Выполняем запрос
    if (!query.exec()) {
        qDebug() << "ERROR: Failed to execute query: " << query.lastError().text();
        return nullptr; // Возвращаем nullptr в случае ошибки
    }

    // Создаем QSqlQueryModel и устанавливаем запрос (передаем владение)
    QSqlQueryModel* queryModel = new QSqlQueryModel();
    queryModel->setQuery(std::move(query));

    // Проверяем на ошибки после setQuery
    if (queryModel->lastError().isValid()) {
        qDebug() << "ERROR in QSqlQueryModel: " << queryModel->lastError().text();
        delete queryModel;
        return nullptr; // Возвращаем nullptr, если в QSqlQueryModel ошибка
    }

    return queryModel; // Возвращаем указатель на QSqlQueryModel
}
