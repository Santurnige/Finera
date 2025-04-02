#ifndef SQLMODELEXPENSES_H
#define SQLMODELEXPENSES_H

#include <QAbstractTableModel>
#include <QSqlTableModel>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QSqlError>
#include "listmodel.h"
#include "applicationengine.h"

class SqlModelExpenses : public _ApplicationEngine
{
    Q_OBJECT

public:
    SqlModelExpenses();
    ~SqlModelExpenses() override;

    Q_INVOKABLE QAbstractTableModel* getModelTable() const override; // Получить QSqlTableModel
    Q_INVOKABLE bool addSqlRequest(const QString& request) override; // добавить запись
    Q_INVOKABLE int getExpensesAllTime(); // плучить сумму всех expenses
    Q_INVOKABLE QAbstractListModel *getStatistic(int year); // получение подробной статистики
    Q_INVOKABLE int getAverageValue(); // получаем среднюю затрату за день

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

private:
    QSqlTableModel *model;
    QSqlQuery *query;
};

#endif // SQLMODELEXPENSES_H
