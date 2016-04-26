import QtQuick 2.5
import Material 0.3

ApplicationWindow {
    id: main

    visible: true
    //visibility: Window.FullScreen

    title: "Material App"

    theme {
        primaryColor: 'blue'
        accentColor: 'red'
        tabHighlightColor: 'white'
    }

    initialPage: Page {
        id: firstPage

        title: qsTr("First Page")

        backAction: Action {
            name: qsTr("Menu")
            iconName: 'navigation/menu'
            onTriggered: console.log("TRIGGERED!");
        }

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
