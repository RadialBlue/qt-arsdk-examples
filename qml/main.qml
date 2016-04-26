import QtQuick 2.5
import Material 0.3

ApplicationWindow {
    id: main

    visible: true

    initialPage: Page {
        id: firstPage

        title: qsTr("First Page")

        Label {
            anchors.centerIn: parent

            style: 'title'
            text: qsTr("Hello, world!")
        }

        MouseArea {
            anchors.fill: parent
            onClicked: Qt.quit();
        }
    }
}
