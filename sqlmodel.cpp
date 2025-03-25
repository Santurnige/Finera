// sqlmodel.cpp
#include "sqlmodel.h"


//Конструктор
SqlModel::SqlModel(QObject *parent) : QAbstractTableModel(parent)
{

    //Создание и настройка sql
    sql = QSqlDatabase::addDatabase("QSQLITE");
    sql.setDatabaseName("salary.db");
    sql.open();

    query = new QSqlQuery(sql);

    QString createTableQuery = R"(
        CREATE TABLE IF NOT EXISTS "Note" (
            "Id" INTEGER NOT NULL UNIQUE,
            "Year" INTEGER,
            "Month" VARCHAR(15),
            "Day" INTEGER,
            "Total" INTEGER,
            PRIMARY KEY("Id")
        );
    )";

    query->exec(createTableQuery);


    model = new QSqlTableModel(this, sql);
    model->setTable("Note");
    model->select();
}

//получение модели
QAbstractTableModel* SqlModel::getModel() const
{
    return model;
}


//добавление в таблицу
void SqlModel::addNote(int year,QString month,int day,int total)
{
    query->exec(QString("INSERT INTO Note (Year,Month,Day,Total)VALUES('%1','%2','%3','%4')")
                    .arg(year).arg(month).arg(day).arg(total));
    model->select();
}
//удалние элемента по id
bool SqlModel::deleteNote(int id)
{
    bool result = query->exec(QString("DELETE FROM Note WHERE id=%1").arg(id));
    model->select();
    return result;
}
//получает сумму всех total
int SqlModel::getSalaryAllTime()
{
    QSqlQuery *query = new QSqlQuery(sql);

    QString sumQuery = "SELECT SUM(Total) FROM Note";

    query->exec(sumQuery);
    query->next();

    return query->value(0).toInt();
}

QVariantMap SqlModel::getStatisticYearChart(int year)
{
    QSqlQueryModel *queryModel = new QSqlQueryModel(this);

    // Формируем SQL-запрос
    QString queryRequest = QString(R"(
        SELECT "Month", SUM("Total") AS TotalSum
        FROM "Note"
        WHERE Year = %1
        GROUP BY "Month"
        ORDER BY "Month"
    )").arg(year);

    // Выполняем запрос
    queryModel->setQuery(queryRequest);

    // Проверяем на ошибки
    if (queryModel->lastError().isValid()) {
        qDebug() << "ERROR: " << queryModel->lastError().text();
    }

    // Создаем QVariantMap для хранения результатов
    QVariantMap resultMap;

    // Проходим по результатам запроса
    for (int i = 0; i < queryModel->rowCount(); ++i) {
        // Получаем данные из модели
        QString month = queryModel->data(queryModel->index(i, 0)).toString();
        int totalSum = queryModel->data(queryModel->index(i, 1)).toInt();

        // Добавляем данные в QVariantMap
        resultMap.insert(month, totalSum);
    }

    return resultMap;
}


//получаем подробную статистику
QAbstractListModel *SqlModel::getStatistic(int year)
{

    QStringList model;

    QString allTime="Заработано за все время: "+QString::number(getSalaryAllTime());//получаем зарплату за все время
    model.append("<b>"+allTime+"<\b>");

    QString averageValue="Зредняя зарплата за день: "+QString::number(getAverageValue());
    model.append("<b>"+averageValue+"<\b>");


    QVariantMap monthStat=getStatisticYearChart(year);//получаем ключ значение зарплаты за каждый месяц

    for(auto el:monthStat.keys()){//перебираем map
        QString temp = el +": "+ monthStat[el].toString();
        qDebug()<<temp;
        model.append(temp);
    }
    QAbstractListModel *mdl=new listModel(nullptr,model);//создаем модель

    return mdl;
}

//получаем среднее значение
int SqlModel::getAverageValue()
{
    QSqlQuery *query = new QSqlQuery(sql);

    QString sumQuery = "SELECT AVG(Total) FROM Note"; //запрос

    query->exec(sumQuery);
    query->next();

    return query->value(0).toInt();
}

int SqlModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return model->rowCount();
}

int SqlModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return model->columnCount();
}

QVariant SqlModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    return model->data(index, role);
}

QHash<int, QByteArray> SqlModel::roleNames() const
{
    return model->roleNames();
}
