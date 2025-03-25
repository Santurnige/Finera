#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include<QQmlContext>
#include<QtQml>
#include"sqlmodel.h"
#include<QApplication>
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);


    QQmlApplicationEngine engine;


    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);


    qmlRegisterType<SqlModel>("SqlModel", 1, 0, "SqlModel");

    engine.loadFromModule("Finera", "Main");


    return app.exec();
}
