import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

GridLayout {
    id: buttonsGrid
    x: 102
    y: 54
    width: 209
    height: 139
    rowSpacing: 30
    columnSpacing: 20

    anchors.fill: parent

    Button {
        id: lookup
        text: qsTr("Lookup tables")
        Layout.row: 0
        Layout.column: 0
        Layout.fillWidth: true
        Layout.fillHeight: true

        onClicked: container.state = "tables"
    }

    Button {
        id: query
        text: qsTr("Perform query")
        Layout.row: 0
        Layout.column: 1
        Layout.fillWidth: true
        Layout.fillHeight: true

        onClicked: container.state = "query"
    }

    Button {
        id: insert
        text: qsTr("Insert a row")
        Layout.row: 1
        Layout.column: 0
        Layout.fillWidth: true
        Layout.fillHeight: true

        onClicked: container.state = "insert"
    }

    Button {
        id: about
        text: qsTr("About program")
        Layout.row: 1
        Layout.column: 1
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
