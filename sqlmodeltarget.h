#ifndef SQLMODELTARGET_H
#define SQLMODELTARGET_H

#include<QSqlDatabase>
#include<QSqlQuery>
#include<QSqlQueryModel>
#include<QSqlTableModel>
#include<QAbstractTableModel>
#include"applicationengine.h"

class SqlModelTarget:public _ApplicationEngine
{
    Q_OBJECT
public:
    SqlModelTarget();
    ~SqlModelTarget() override;

    Q_INVOKABLE QAbstractTableModel *getModelTable()const override;
    Q_INVOKABLE bool addSqlRequest(const QString &request) override;


    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
private:
    QSqlQuery *query;
    QSqlTableModel *model;
};

#endif // SQLMODELTARGET_H
