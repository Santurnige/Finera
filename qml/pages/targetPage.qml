import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
Page {
    id:page

    property var sqlTarget: sqlModelTarget

    Material.theme: Material.Light
    Material.accent: Material.Purple

    function updateTargets(){




        for(var i=0;i<mainColumn.children.length;i++){
           mainColumn.children[i].destroy()
        }

        var model=sqlTarget.getModelTable()

        for(var i=0;i<model.rowCount();i++){
            var idModel=model.data(model.index(i,0))
            var nameModel=model.data(model.index(i,1))
            var FinalTModel=model.data(model.index(i,2))
            var CurrentBModel=model.data(model.index(i,3))
            var AboutModel=model.data(model.index(i,4))

            var elementQML=`
            import QtQuick
            import QtQuick.Controls

            TargetElement{


                ptargetId: '${idModel}'
                ptargetName: '${nameModel}'
                pfinalTotal: ${FinalTModel}
                pcurrentBalance: ${CurrentBModel}
                pabout: '${AboutModel}'
                width: ${parent.width-20}

                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        editTargetName.text='${nameModel}'
                        idElement.text='${idModel}'
                        finalTotal.text='${FinalTModel}'
                        diffBalance.text='${FinalTModel-CurrentBModel}'
                        currentBalance.text='${CurrentBModel}'
                        dialogMoreInfo.open()
                    }
                }

            }`

            var newElement = Qt.createQmlObject(elementQML,mainColumn)
        }
    }

    Dialog{
        id:dialogMoreInfo
        anchors.centerIn: parent
        width: parent.width-50
        height:parent.height-50



        Text {
                id: idElement
                font.bold: true
                font.family: customFont.name
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 20
                text: ""
                topPadding: 10
            }

            ColumnLayout {
                id: mainLayout
                anchors.top: idElement.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: deleteButton.top
                anchors.margins: 10

                spacing: 10

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Название"
                    font.pixelSize: 18
                    font.family: customFont.name
                }

                RowLayout {
                    Layout.fillWidth: true
                    TextField {
                        id: editTargetName
                        Layout.fillWidth: true
                        font.family: customFont.name
                        placeholderText: "Введите название"
                    }

                    Button {
                        id: saveName
                        font.family: customFont.name
                        highlighted: true
                        text: "Сохранить"
                        onClicked: {
                            console.log(sqlTarget.addSqlRequest(`UPDATE target SET Name = '${editTargetName.text}'WHERE Id = '${idElement.text}'`))
                            updateTargets()
                            dialogMoreInfo.close()
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: "Цена Цели:"
                        font.family: customFont.name
                    }
                    Text {
                        id: finalTotal
                        font.family: customFont.name
                        color:"#d90000"
                        text: "0.00"
                        font.pixelSize: 20
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: "Осталось:"
                        font.family: customFont.name
                    }
                    Text {
                        id: diffBalance
                        font.family: customFont.name
                        text: "0.00"
                        font.pixelSize: 20
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: "Добавлено: "
                        font.family: customFont.name
                    }
                    Text {
                        id: currentBalance
                        font.family: customFont.name
                        color: "#00db00"
                        text: "0.00"
                        font.pixelSize: 20
                    }
                }

                ColumnLayout{
                    Layout.fillWidth: true
                    Text{
                        text:"Добавить к цели"
                    }
                    RowLayout {
                        Layout.fillWidth: true



                        SpinBox {
                            id: addTargetSpin
                            from: 1
                            to: Number(finalTotal.text)
                            value: Number(finalTotal.text)
                            font.family: customFont.name
                            editable: true

                        }

                        Button {
                            id: buttonAddTarget
                            icon.source: "icon/add.png"
                            highlighted: true
                            font.family: customFont.name
                            onClicked: {
                                sqlTarget.addSqlRequest(`UPDATE target SET CurrentBalance = '${(Number(currentBalance.text)+addTargetSpin.value)}' WHERE Id = '${idElement.text}'`)
                                updateTargets()
                                dialogMoreInfo.close()
                            }
                        }
                    }
                }

            }

            Button {
                id: deleteButton
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 10
                font.family: customFont.name
                highlighted: true
                text: "Удалить!"
                onClicked: {
                    console.log(sqlTarget.addSqlRequest(`DELETE FROM target WHERE Id = '${idElement.text}'`))
                    updateTargets()
                    dialogMoreInfo.close()
                }
            }

    }

    Component.onCompleted: {
        updateTargets()
    }

    ScrollView{
        id:mainScrollView
        anchors.fill: parent
        Column{
            id:mainColumn
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5
        }
    }

    Dialog{
        id:dialogAddNote
        anchors.centerIn: parent
        width: parent.width
        height: parent.height/2

        Column{
            anchors.centerIn: parent
            Text {
                text: qsTr("Добавить цель!")
                font.bold: true
                font.family: customFont.name
                font.pixelSize: 14
            }
            TextField{
                id:addName
                width: parent.width
                placeholderText: "Название цели"
            }

            Text {
                text: qsTr("Цена цели")
                font.family: customFont.name
                font.pixelSize: 12
            }
            SpinBox{
                id:addtotal
                editable: true
                to:100
                from: 100000000
            }
            Text {
                text: qsTr("О цели")
                font.family: customFont.name
                wrapMode: Text.WrapAnywhere
                font.pixelSize: 12
            }
            TextArea{
                id:addAbout
                wrapMode: Text.WrapAnywhere
            }
        }

        standardButtons: Dialog.Cancel|Dialog.Save

        onAccepted: {
            sqlTarget.addSqlRequest(`INSERT INTO target (Name,FinalTotal,CurrentBalance,About)VALUES('${addName.text}','${addtotal.value}','${0}','${addAbout.text}')`)
            updateTargets()
            dialogMoreInfo.close()
        }
    }


    footer: Button{
        text: "Добавить цель!"
        font.pixelSize: 20
        highlighted: true
        onClicked:{
            dialogAddNote.open()
        }
    }
}
