#include "sqlmodeltarget.h"



SqlModelTarget::SqlModelTarget() {


    query=new QSqlQuery(main_sql);

    model=new QSqlTableModel(this,main_sql);
    model->setTable("target");

    model->select();
}

SqlModelTarget::~SqlModelTarget()
{
    delete model;
    delete query;
}

QAbstractTableModel *SqlModelTarget::getModelTable() const
{
    return model;
}

bool SqlModelTarget::addSqlRequest(const QString &request)
{
    bool result = query->exec(request);
    if(!result){
        qDebug() << "ERROR SQL query:"<< query->lastError().text();
    }
    model->select();
    return result;
}

int SqlModelTarget::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return model->rowCount();
}

int SqlModelTarget::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return model->columnCount();
}

QVariant SqlModelTarget::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    return model->data(index, role);
}

QHash<int, QByteArray> SqlModelTarget::roleNames() const
{
    return model->roleNames();
}

