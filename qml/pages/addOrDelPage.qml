import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Page {
    id:mainRectangle

    property var sqlIncome: sqlModelIncome


    Material.theme: Material.Light
    Material.accent: Material.Purple

    SwipeView{
        id:mainSwipeView
        anchors.fill: parent

        Rectangle{
            id:page1

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
                        font.family: customFont.name
                        font.pixelSize: 25
                    }

                    SpinBox{
                        id:addDay
                        font.family: customFont.name
                        from: 1
                        to:31
                        font.pixelSize: 20
                        editable: true
                        value: new Date().getDate()
                    }

                    Text {
                        font.family: customFont.name
                        text: qsTr("Месяц")
                        font.pixelSize: 25
                    }

                    ComboBox {
                        font.family: customFont.name
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
                        font.family: customFont.name
                        font.pixelSize: 25
                    }

                    SpinBox{
                        id:addYear
                        font.family: customFont.name
                        value:new Date().getFullYear()
                        from: 2025
                        to:2100
                        font.pixelSize: 20
                        editable: true
                    }

                    Text {
                        font.family: customFont.name
                        text: qsTr("Плата")
                        font.pixelSize: 25
                    }

                    SpinBox{
                        id:addSalary
                        font.family: customFont.name
                        value:2000
                        from: 0
                        to:1000000
                        font.pixelSize: 20
                        editable: true
                    }

                }
                Button {
                    id: addNote
                    width: 100
                    font.family: customFont.name
                    icon.source: "icon/add.png"
                    highlighted: true

                    onClicked:{
                        dialogAdd.open()
                    }
                }

                Button{
                    width: 100
                    font.family: customFont.name
                    icon.source: "icon/trash.png"
                    highlighted: true
                    onClicked: dialogDel.open()
                }

                Dialog {
                    id: dialogAdd
                    font.family: customFont.name
                    modal: true
                    title: "Добавить"
                    standardButtons: Dialog.No | Dialog.Yes

                    anchors.centerIn: parent

                    onAccepted: {
                        sqlIncome.addSqlRequest(`INSERT INTO income (Year,Month,Day,Total)VALUES('${addYear.value}','${addMonth.currentText}','${addDay.value}','${addSalary.value}')`)
                    }

                    Text {
                        text: qsTr("Вы точно хотите добавить запись!?")
                    }
                }

                Dialog{
                    anchors.centerIn: parent
                    font.family: customFont.name
                    id:dialogDel
                    title: "Удалить Элемент!"
                    modal:true


                    Column{
                        Text {
                            font.family: customFont.name
                            text: qsTr("Введите Id Элемента\n Который Будет Удален!")
                            font.bold: true
                            font.pixelSize: 16

                        }
                        SpinBox{
                            font.family: customFont.name
                            id:idDelete
                            editable: true;
                            from:1
                            to:30000
                            value: 1

                        }

                        Row{
                            Button{
                                font.family: customFont.name
                                text: "Отмена"
                                highlighted: true
                                onClicked: dialogDel.close()
                            }
                            Button{
                                font.family: customFont.name
                                text:"Удалить"
                                highlighted: true
                                onClicked: {
                                    if(sqlIncome.addSqlRequest(`DELETE FROM income WHERE Id = ${idDelete.value}`)){
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

                }
        }
            Dialog{
                id:dialogTrue
                font.family: customFont.name
                title: "Успешно!"

                Text {
                    font.family: customFont.name
                    text: qsTr("Запись Успешно Удалено")
                }
            }
            Dialog{
                font.family: customFont.name
                id:dialogFalse
                title: "Ошибка!"
                Text {
                    font.family: customFont.name
                    text: qsTr("Введите Правилное ID!")
                }
            }
        }
    }
}

