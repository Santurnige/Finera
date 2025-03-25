import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Page {
    id:mainRectangle

    property var sqlModel: sqlMdl

    Material.theme: Material.Light
    Material.accent: Material.Red

    Column{
        id:mainLayout
        anchors.centerIn: parent
        spacing: 15

        GridLayout
        {

            columns: 2
            rows: 4


            Text {
                text: qsTr("День")
                font.pixelSize: 25
            }

            SpinBox{
                id:addDay
                from: 1
                to:31
                font.pixelSize: 20
                editable: true
                value: new Date().getDate()
            }

            Text {
                text: qsTr("Месяц")
                font.pixelSize: 25
            }

            ComboBox {
                id:addMonth
                model: [
                    "Январь",
                    "Февраль",
                    "Март",
                    "Апрель",
                    "Май",
                    "Июнь",
                    "Июль",
                    "Август",
                    "Сентябрь",
                    "Октябрь",
                    "Ноябрь",
                    "Декабрь"
                ]
                font.pixelSize: 15

                currentIndex: new Date().getMonth()
            }

            Text {
                text: qsTr("Год")
                font.pixelSize: 25
            }

            SpinBox{
                id:addYear
                value:new Date().getFullYear()
                from: 2025
                to:2100
                font.pixelSize: 20
                editable: true
            }

            Text {
                text: qsTr("Плата")
                font.pixelSize: 25
            }

            SpinBox{
                id:addSalary
                value:2000
                from: 0
                to:1000000
                font.pixelSize: 20
                editable: true
            }

        }
        Button {
            id: addNote
            text: "Добавить"
            icon.source: "icon/add.png"
            highlighted: true

            onClicked:{
                dialogAdd.open()
            }
        }

        Button{
            text: "Удалить"
            icon.source: "icon/trash.png"
            highlighted: true
            onClicked: dialogDel.open()
        }

        Dialog {
            id: dialogAdd

            modal: true
            title: "Добавить"
            standardButtons: Dialog.No | Dialog.Yes

            anchors.centerIn: parent

            onAccepted: {
                sqlModel.addNote(addYear.value,addMonth.currentText,addDay.value,addSalary.value)
            }

            Text {
                text: qsTr("Вы точно хотите добавить запись!?")
            }
        }

        Dialog{
            anchors.centerIn: parent
            id:dialogDel
            title: "Удалить Элемент!"
            modal:true


            Column{
                Text {
                    text: qsTr("Введите Id Элемента\n Который Будет Удален!")
                }
                SpinBox{
                    id:idDelete
                    editable: true;
                    from:1
                    to:30000
                    value: 1
                }

                Row{
                    Button{
                        text: "Отмена"
                        onClicked: dialogDel.close()
                    }
                    Button{
                        text:"Удалить"
                        onClicked: {
                            if(sqlModel.deleteNote(idDelete.value)){
                                dialogTrue.open()
                                dialogDel.close()
                            }
                            else{
                                dialogFalse.open()
                                dialogDel.close();
                            }
                        }
                    }
                }
            }

            Dialog{
                id:dialogTrue

                title: "Успешно!"

                Text {
                    text: qsTr("Запись Успешно Удалено")
                }
            }
            Dialog{
                id:dialogFalse
                title: "Ошибка!"
                Text {
                    text: qsTr("Введите Правилное ID!")
                }
            }
        }
    }
}

