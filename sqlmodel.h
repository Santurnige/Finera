#ifndef SQLMODEL_H
#define SQLMODEL_H

#include<QSqlDatabase>
#include<QSqlQuery>
#include<QSqlTableModel>
#include<QSqlRecord>
#include<QtCharts/QtCharts>
#include<QtCharts/QPieSlice>
#include<QtCharts/QPieSeries>
#include<QSqlError>
#include"listmodel.h"

class SqlModel : public QAbstractTableModel
{
    Q_OBJECT
public:
    SqlModel(QObject *parent = nullptr);
    Q_INVOKABLE QAbstractTableModel* getModel() const;//Получить QSqlTableModel
    Q_INVOKABLE void addNote(int year,QString month,int day,int total);//добавить запись
    Q_INVOKABLE bool deleteNote(int id);//удалить объект по id
    Q_INVOKABLE int getSalaryAllTime();//плучить сумму всех total
    Q_INVOKABLE QVariantMap getStatisticYearChart(int year);//получить график-статистику всего года
    Q_INVOKABLE QAbstractListModel *getStatistic(int year);//получение подробной статистики
    Q_INVOKABLE int getAverageValue();//получаем среднюю зарплату за день


    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

private:
    QSqlDatabase sql;
    QSqlQuery *query;
    QSqlTableModel *model;
};

#endif
