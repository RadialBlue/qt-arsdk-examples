#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "material/src/plugin.h"

int main(int argc, char **argv)
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setQuitOnLastWindowClosed(true);

    MaterialPlugin material;
    material.registerTypes("Material");

    QQmlApplicationEngine engine;
    engine.addImportPath(":/.");
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
