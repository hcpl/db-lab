import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: window
    title: qsTr("Lab 1.0")
    width: 600
    height: 500
    visible: true

    toolBar: ToolBar {
        id: bar
        visible: false

        Button {
            id: returnToMenu
            text: qsTr("Return to menu")
            onClicked: container.state = ""
        }
    }

    Item {
        id: container
        anchors.fill: parent

        Loader {
            id: loader
            anchors.fill: parent
            source: "Menu.qml"
        }

        states: [
            State {
                name: ""
                PropertyChanges { target: loader; source: "Menu.qml" }
                PropertyChanges { target: bar; visible: false }
            },

            State {
                name: "tables"
                PropertyChanges { target: loader; source: "Tables.qml" }
                PropertyChanges { target: bar; visible: true }
            },

            State {
                name: "query"
                PropertyChanges { target: loader; source: "Query.qml" }
                PropertyChanges { target: bar; visible: true }
            },

            State {
                name: "insert"
                PropertyChanges { target: loader; source: "Insert.qml" }
                PropertyChanges { target: bar; visible: true }
            }
        ]
    }
}
