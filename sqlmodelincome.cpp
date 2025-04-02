#include "sqlmodelincome.h"
#include <QDebug>

SqlModelIncome::SqlModelIncome() :_ApplicationEngine()
{
    query=new QSqlQuery(main_sql);

    model = new QSqlTableModel(this, main_sql);
    model->setTable("income");
    model->select();
}

SqlModelIncome::~SqlModelIncome(){
    delete model;
    delete query;
}

QAbstractTableModel *SqlModelIncome::getModelTable() const
{
    return model;
}

bool SqlModelIncome::addSqlRequest(const QString& request)
{
    bool result = query->exec(request);
    if(!result){
        qDebug() << "ERROR SQL query:"<< query->lastError().text();
    }
    model->select();
    return result;
}

// получает сумму всех total
int SqlModelIncome::getIncomeAllTime()
{
    QSqlQuery query(main_sql);
    query.exec("SELECT SUM(Total) FROM income");

    if (query.next()) {
        return query.value(0).toInt();
    } else {
        qDebug() << "ERROR: Failed to get total income:" << query.lastError().text();
        return 0;
    }
}

// получаем подробную статистику
QAbstractListModel *SqlModelIncome::getStatistic(int year)
{

    QStringList listModel;

    QString allTime = "Заработано за все время: " + QString::number(getIncomeAllTime()); // получаем зарплату за все время
    listModel.append("<b>" + allTime + "<\\b>");

    QString averageValue = "Зредняя зарплата за день: " + QString::number(getAverageValue());
    listModel.append("<b>" + averageValue + "<\\b>");

    QVariantMap monthStat = getStatisticYearChart(year, "income","Total"); // получаем ключ значение зарплаты за каждый месяц

    for (const QString& el : monthStat.keys()) { // перебираем map
        QString temp = el + ": " + monthStat[el].toString();
        listModel.append(temp);
    }

    QAbstractListModel *mdl = new class listModel(listModel); // создаем модель
    return mdl;
}

// получаем среднее значение
int SqlModelIncome::getAverageValue()
{
    QSqlQuery query(main_sql);
    query.exec("SELECT AVG(Total) FROM income");

    if (query.next()) {
        return query.value(0).toInt();
    } else {
        qDebug() << "ERROR: Failed to get average income:" << query.lastError().text();
        return 0;
    }
}

int SqlModelIncome::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return model->rowCount();
}

int SqlModelIncome::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return model->columnCount();
}

QVariant SqlModelIncome::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    return model->data(index, role);
}

QHash<int, QByteArray> SqlModelIncome::roleNames() const
{
    return model->roleNames();
}
