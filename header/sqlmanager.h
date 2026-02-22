#ifndef SQLMANAGER_H
#define SQLMANAGER_H

#include<QSqlQuery>
#include<QSqlDatabase>
#include<QSqlQueryModel>
#include<QSqlError>

class SqlManager
{
public:
    static SqlManager &instance(){
        static SqlManager inst;
        return inst;
    }

    QSqlDatabase &getDatabase(){
        return main_sql;
    }

private:
    SqlManager();

    QSqlDatabase main_sql;
    QSqlQuery *main_query;
};

#endif // SQLMANAGER_H
