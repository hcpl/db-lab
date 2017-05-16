import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.LocalStorage 2.0

TabView {
    id: tables

    anchors.fill: parent

    /*function mapObjectValues(obj, func) {
        return Object.keys(obj).reduce(function(accum, key) {
            accum[key] = func(key, obj[key]);
            return accum;
        }, {});
    }

    function mapObject(obj, func) {
        return Object.keys(obj).map(function(key) {
            return func(key, obj[key]);
        });
    }*/

    function mapPairsValues(pairs, func) {
        return pairs.reduce(function(accum, pair) {
            accum[pair[0]] = func(pair);
            return accum;
        }, {});
    }

    function loadSql(model, name, scheme) {
        var db = LocalStorage.openDatabaseSync("Lab", "", "Lab SQL Table", 1000000);

        db.transaction(function(tx) {
            var columns = scheme.map(function(pair) { return pair[0] + ' ' + pair[1] }).join(', ');
            tx.executeSql('CREATE TABLE IF NOT EXISTS %1 (%2)'.arg(name).arg(columns));
        });

        db.readTransaction(function(tx) {
            var results = tx.executeSql('SELECT * FROM %1'.arg(name));

            model.clear();

            for (var i = 0; i < results.rows.length; ++i) {
                var row = results.rows.item(i);

                model.append(mapPairsValues(scheme, function(pair) { return row[pair[0]]; }));
            }
        });
    }

    Component { id: tableViewColumnComponent; TableViewColumn {} }

    function addColumns(table, tableData) {
        for (var i = 0; i < tableData.length; ++i) {
            table.addColumn(tableViewColumnComponent.createObject(table, {
                "role": tableData[i][0],
                "title": tableData[i][1],
                "width": tableData[i][3],
            }));
        }
    }

    Component {
        id: tableView

        TableView {
            id: view
            model: model

            ListModel {
                id: model
                Component.onCompleted: loadSql(model, title, tableData.map(function(col) { return [col[0], col[2]] }))
            }

            onActivated: {
                var r = model.get(row);

                var rowInfo = [];
                for (var i = 0; i < view.columnCount; ++i) {
                    var column = view.getColumn(i);
                    if (column.role !== "id" ) {
                        rowInfo.push([column.title, r[column.role]]);
                    }
                }

                edittingRowInfo = rowInfo;
                parent.state = "edit";
            }

            Component.onCompleted: {
                addColumns(view, tableData);
                view.focus = true;
            }
        }
    }

    Component { id: textFieldComponent; TextField {} }

    function addTextFields(parent, edittingRowInfo) {
        for (var i = 0; i < edittingRowInfo.length; ++i) {
            textFieldComponent.createObject(parent, {
                "placeholderText": edittingRowInfo[i][0],
                "text": edittingRowInfo[i][1],
                "Layout.fillWidth": true,
            });
        }
    }

    Component {
        id: rowEdit

        Item {
            id: form

            ColumnLayout {
                id: formInputs
                anchors.centerIn: parent

                Text {
                    id: header
                    text: title
                    font.pointSize: 14
                    Layout.alignment: Qt.AlignCenter
                }

                Component {
                    id: buttonRow

                    RowLayout {
                        Button {
                            text: "Save"
                        }

                        Button {
                            text: "Cancel"

                            onClicked: {
                                parent.parent.parent.parent.state = "";
                            }
                        }
                    }
                }

                Component.onCompleted: {
                    addTextFields(formInputs, edittingRowInfo);
                    buttonRow.createObject(formInputs);
                }
            }
        }
    }

    Tab {
        id: users
        title: "Users"
        sourceComponent: tableView
        property var tableData: [
            ["id", "User ID", "INTEGER PRIMARY KEY", 75],
            ["email", "E-Mail", "TEXT", 250]
        ]

        property var edittingRowInfo

        states: [
            State {
                name: ""
                PropertyChanges { target: users; sourceComponent: tableView }
            },

            State {
                name: "edit"
                PropertyChanges { target: users; sourceComponent: rowEdit }
            }
        ]
    }

    Tab {
        id: macros
        title: "Macros"
        sourceComponent: tableView
        property var tableData: [
            ["id", "Macro ID", "INTEGER PRIMARY KEY", 75],
            ["contents", "Contents", "TEXT", 250]
        ]
    }
}
