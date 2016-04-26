TARGET = appname
TEMPLATE = app

QT += qml quick
CONFIG += c++11

HEADERS +=

SOURCES += \
    src/main.cpp

RESOURCES += qml.qrc

include(deployment.pri)

OPTIONS += roboto
include(material/material.pri)
