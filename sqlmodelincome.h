#ifndef SQLMODELINCOME_H
#define SQLMODELINCOME_H

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlTableModel>
#include <QSqlRecord>
#include <QSqlError>
#include "listmodel.h"
#include "applicationengine.h"

class SqlModelIncome : public _ApplicationEngine
{
    Q_OBJECT
public:
    SqlModelIncome();
    ~SqlModelIncome() override;

    Q_INVOKABLE QAbstractTableModel *getModelTable() const override;
    Q_INVOKABLE bool addSqlRequest(const QString& request) override;
    Q_INVOKABLE int getIncomeAllTime(); // плучить сумму всех total
    Q_INVOKABLE QAbstractListModel *getStatistic(int year); // получение подробной статистики
    Q_INVOKABLE int getAverageValue(); // получаем среднюю зарплату за день

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

protected:
    QSqlTableModel *model;
    QSqlQuery *query;
};

#endif
