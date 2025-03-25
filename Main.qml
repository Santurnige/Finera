import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt.labs.qmlmodels
import "." as App
import SqlModel


Window {
    id: mainWindow
    width: 360
    height: 820
    visible: true
    title: "Зарплата"


    SqlModel{
        id:sqlModel
    }

    property alias sqlMdl:sqlModel

    property bool menuStatus: true

    Material.theme: Material.Light
    Material.accent: Material.Red

    Rectangle{
        id:topMenu
        color:"#00ffa7"
        anchors.top: parent.top
        width:parent.width
        height:60

        Button {
            id: menuButton
            icon.source:"icon/menu.png";
            onClicked:{
                if(menuStatus==true){
                    menuDrawer.open()
                }
                else{
                    currentPage.text="Зарплата"
                    stackView.pop();
                    menuStatus=true
                    icon.source="icon/menu.png"
                }
            }
            anchors.left: parent.left
            height: parent.height
            background: null
        }

        Text {
            id:currentPage
            text: qsTr("Зарплата")
            font.pixelSize: 24
            anchors.centerIn: topMenu
        }


    }


    Rectangle{
        anchors.top: topMenu.bottom
        width: mainWindow.width
        height: mainWindow.height-topMenu.height

        StackView{
            id:stackView
            anchors.fill: parent

            initialItem: mainView
        }

        Rectangle{
            id:mainView

            Column{
                width: mainView.width-30
                spacing: 10
                anchors.centerIn: mainView
                anchors.margins: 15
                Rectangle{
                    id:widgetAll
                    color:"#00ffa7"
                    height:90
                    width: parent.width
                    radius: 20
                    Text{
                        anchors.centerIn: parent
                        font.pixelSize: 15
                        text: qsTr("Заработано За Все Время\n"+sqlModel.getSalaryAllTime());
                    }
                }

                Rectangle{
                    id:widgetMonth
                    color:"#00ffa7"
                    height:90
                    width:parent.width
                    radius: 20
                    Text {
                        anchors.centerIn: parent
                        font.pixelSize: 15
                        text: qsTr("Зредняя зарплата за день - \n"+sqlModel.getAverageValue())
                    }

                }
            }
        }
    }




    Drawer {
        id: menuDrawer
        width: Math.min(mainWindow.width, mainWindow.height) / 3 * 2
        height: mainWindow.height
        edge: Qt.LeftEdge

        ListView{
            anchors.fill: parent
            id:listMenu
            focus: true

            model:ListModel{
                ListElement{
                    title:qsTr("Управление Записями")
                    iconButton:"icon/addOrDel.png"
                    source:"pages/addOrDelPage.qml"
                }
                ListElement{
                    title:qsTr("Статистика")
                    iconButton:"icon/statistic.png"
                    source:"pages/statisticPage.qml"
                }
                ListElement{
                    title:qsTr("Настройки")
                    iconButton:"icon/settings.png"
                    source:"pages/settingsPage.qml"
                }
                ListElement{
                    title:qsTr("Для Разработчиков")
                    iconButton:"icon/dev.png"
                    source:"pages/devPage.qml"
                }
                ListElement{
                    title:qsTr("О")
                    iconButton:"icon/about.png"
                    source:"pages/aboutPage.qml"
                }
            }

            delegate: ItemDelegate{
                font.pixelSize: 16
                width:listMenu.width
                icon.source: iconButton
                text: title
                onClicked: {
                    menuDrawer.close()

                    stackView.push(source)
                    currentPage.text=title
                    menuStatus=false
                    menuButton.icon.source="icon/home.png"
                }
            }
        }
    }
}
