#include <QApplication>
#include <QFont>
#include <QFontDatabase>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>
#include "header/sqlmodelincome.h"
#include "header/sqlmodeltarget.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setWindowIcon(QIcon("icon/appIcon.png"));

    QQmlApplicationEngine engine;

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    qmlRegisterType<SqlModelIncome>("SqlModelIncome", 1, 0, "SqlModelIncome");
    qmlRegisterType<SqlModelTarget>("SqlModelTarget", 1, 0, "SqlModelTarget");

    engine.loadFromModule("Finera", "Main");

    return app.exec();
}
