import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls


Page {

    id:page

    property var sqlModel: sqlModelIncome

    Material.theme: Material.Light
    Material.accent: Material.Purple

    TableView {
        id:mainTableView
            anchors.fill: parent
            columnSpacing: 1
            rowSpacing: 1
            clip:true

            delegate: Rectangle {
                implicitWidth: 100
                implicitHeight: 30
                border.color: "lightgray"

                Text {
                    font.family: customFont.name
                    text: display.length>10?display.substring(0,4)+"...":display
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        dialogText.text=display
                        tabElDialog.open()
                    }
                }
            }
        }

    Dialog{
        id:tabElDialog
        width: 200
        height:200
        font.family: customFont.name
        anchors.centerIn: parent

        ScrollView{
            anchors.fill: parent
            Text {
                id:dialogText
                font.family: customFont.name
                anchors.centerIn: parent
            }
        }

    }

    Dialog{
        id:aboutDil
        anchors.centerIn: parent
        width:page.width-30
        height:page.height-100

        ScrollView{
            anchors.fill: parent
            Text {
                wrapMode: Text.Wrap
                text: qsTr("<b>Здесть вы можете отправлять sql запросы!</b><br>Программа использует база данных SqlLite<br>
                    <h1>Таблицы</h1><br>
                    <p>Таблица 1: Доход!</p><br>
                    CREATE TABLE IF NOT EXISTS 'income' (<br>
                        'Id' INTEGER NOT NULL UNIQUE,<br>
                        'Year' INTEGER,<br>
                        'Month' VARCHAR(15),<br>
                        'Day' INTEGER,<br>
                        'Total' INTEGER,<br>
                        PRIMARY KEY('Id')<br>
                    );<br>
                    <p>Таблица 2: Расход!</p><br>
                    CREATE TABLE IF NOT EXISTS 'expenses' (<br>
                        'Id' INTEGER NOT NULL UNIQUE,<br>
                        'Year' INTEGER,<br>
                        'Month' VARCHAR(15),<br>
                        'Day' INTEGER,<br>
                        'Expenses INTEGER,<br>
                        'About' Text,<br>
                        'PRIMARY' KEY('Id')<br>
                    );<br>
                ")
                font.pixelSize: 17
                font.family: customFont.name
            }
        }
    }

    footer: Row{
            Button{
                text:"?"
                onClicked: {
                    aboutDil.open()
                }
            }

            TextArea{
                id:textEditRequest
                width: page.width/2
                wrapMode: Text.WrapAnywhere

            }

            Button{
                id:buttonRequest
                text: "send"
                font.family: customFont.name
                onClicked:{
                    mainTableView.model=sqlModel.getTable(textEditRequest.text)
                }
            }
        }
}
