#include <QQmlApplicationEngine>
#include<QQmlContext>
#include<QtQml>
#include"sqlmodelincome.h"
#include"sqlmodelexpenses.h"
#include<QApplication>
#include<QFont>
#include<QFontDatabase>
#include"sqlmodeltarget.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    app.setApplicationDisplayName("Finera");
    app.setApplicationName("Finera");


    QQmlApplicationEngine engine;


    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);




    qmlRegisterType<SqlModelIncome>("SqlModelIncome", 1, 0, "SqlModelIncome");
    qmlRegisterType<SqlModelExpenses>("SqlModelExpenses",1,0,"SqlModelExpenses");
    qmlRegisterType<SqlModelTarget>("SqlModelTarget",1,0,"SqlModelTarget");


    engine.loadFromModule("Finera", "Main");




    return app.exec();
}
