#ifndef APPLICATIONENGINE_H
#define APPLICATIONENGINE_H

#include <QAbstractTableModel>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include"sqlmanager.h"

class _ApplicationEngine : public QAbstractTableModel
{
    Q_OBJECT

public:
    _ApplicationEngine();
    ~_ApplicationEngine() override;

    virtual QAbstractTableModel *getModelTable() const = 0; // Получить QSqlTableModel
    virtual bool addSqlRequest(const QString &request) = 0; // запрос в sql

    Q_INVOKABLE QVariantMap getStatisticYearChart(int year,
                                                  const QString &tableName,
                                                  const QString &colName);
    Q_INVOKABLE QAbstractTableModel *getTable(const QString &request);
protected:
    QSqlDatabase main_sql;
};

#endif // APPLICATIONENGINE_H
