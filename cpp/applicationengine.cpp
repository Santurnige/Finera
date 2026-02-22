#include "header/applicationengine.h"
#include <QDebug>
#include <qsqltablemodel.h>

// Конструктор
_ApplicationEngine::_ApplicationEngine()
{
    SqlManager sqlManager=SqlManager::instance();
    main_sql=sqlManager.getDatabase();

}

// Деструктор
_ApplicationEngine::~_ApplicationEngine()
{
    // Закрываем соединение при уничтожении объекта
    if (main_sql.isOpen()) {
        main_sql.close();
        qDebug() << "Database connection closed";
    }
}

QVariantMap _ApplicationEngine::getStatisticYearChart(int year,
                                                      const QString &tableName,
                                                      const QString &colName)
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
    )")
                               .arg(colName)
                               .arg(tableName)
                               .arg(year);

    query.prepare(queryRequest);

    if (!query.exec()) {
        qDebug() << "ERROR executing query:" << query.lastError().text();
        return resultMap; // Возвращаем пустую карту в случае ошибки
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

QAbstractTableModel *_ApplicationEngine::getTable(const QString &request)
{
    QSqlQuery query(main_sql);

    // Подготавливаем запрос
    query.prepare(request);

    // Выполняем запрос
    if (!query.exec()) {
        qDebug() << "ERROR: Failed to execute query: " << query.lastError().text();
        return nullptr; // Возвращаем nullptr в случае ошибки
    }

    // Создаем QSqlQueryModel и устанавливаем запрос (передаем владение)
    QSqlQueryModel *queryModel = new QSqlQueryModel();
    queryModel->setQuery(std::move(query));

    // Проверяем на ошибки после setQuery
    if (queryModel->lastError().isValid()) {
        qDebug() << "ERROR in QSqlQueryModel: " << queryModel->lastError().text();
        delete queryModel;
        return nullptr; // Возвращаем nullptr, если в QSqlQueryModel ошибка
    }

    return queryModel;
}
