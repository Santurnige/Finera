#include "header/sqlmanager.h"

SqlManager::SqlManager() {
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

    QString target = R"(
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
        qDebug() << "ERROR: Failed to create 'income' table: "
                 << main_query->lastError().text();
        return;
    }

    if (!main_query->exec(target)) {
        qDebug() << "ERROR: Failed to create 'target' table:" << main_query->lastError().text();
        return;
    }
    delete main_query;
}
