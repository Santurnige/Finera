#include "sqlmodelexpenses.h"
#include <QDebug>

// Конструктор
SqlModelExpenses::SqlModelExpenses() : _ApplicationEngine()
{
    query=new  QSqlQuery(main_sql);

    model = new QSqlTableModel(this, main_sql); // Используем существующее соединение
    model->setTable("expenses");
    model->select();
}

SqlModelExpenses::~SqlModelExpenses() {
    delete model;
    delete query;
}

QAbstractTableModel *SqlModelExpenses::getModelTable() const
{
    return model;
}

bool SqlModelExpenses::addSqlRequest(const QString& request)
{

    query->prepare(request); // Используем существующий QSqlQuery
    bool result = query->exec();
    if(!result){
        qDebug() << "ERROR SQL query:"<< query->lastError().text();
    }
    model->select();

    return result;
}

int SqlModelExpenses::getExpensesAllTime()
{
    QSqlQuery query(main_sql); // Локальный QSqlQuery
    query.exec("SELECT SUM(Expenses) FROM expenses");

    if (query.next()) {
        return query.value(0).toInt();
    } else {
        qDebug() << "ERROR: Failed to get total expenses:" << query.lastError().text();
        return 0;
    }
}

// получаем подорбную статистику
QAbstractListModel *SqlModelExpenses::getStatistic(int year)
{
    QStringList listStat;

    QString st_AllTime = "Затрачено за все время: " + QString::number(getExpensesAllTime());
    listStat.append(st_AllTime);

    QString st_AvgTime = "Средняя затрата за день: " + QString::number(getAverageValue());
    listStat.append(st_AvgTime);


    QVariantMap monthStat = getStatisticYearChart(year, "expenses","Expenses"); // получаем ключ значение зарплаты за каждый месяц

    for (const QString& el : monthStat.keys()) { // перебираем map
        QString temp = el + ": " + monthStat[el].toString();
        listStat.append(temp);
    }


    QAbstractListModel *modelList = new listModel(listStat);

    return modelList;
}

// получаем среднее значене(трат)
int SqlModelExpenses::getAverageValue()
{
    QSqlQuery query(main_sql);  // Локальный QSqlQuery

    query.exec("SELECT AVG(Expenses) FROM expenses");

    if (query.next()) {
        return query.value(0).toInt();
    } else {
        qDebug() << "ERROR: Failed to get average expenses:" << query.lastError().text();
        return 0;
    }
}

int SqlModelExpenses::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return model->rowCount();
}

int SqlModelExpenses::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return model->columnCount();
}

QVariant SqlModelExpenses::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    return model->data(index, role);
}

QHash<int, QByteArray> SqlModelExpenses::roleNames() const
{
    return model->roleNames();
}
