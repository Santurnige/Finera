import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt.labs.qmlmodels
import "." as App
import SqlModelIncome
import SqlModelExpenses
import SqlModelTarget


ApplicationWindow {

    id: mainWindow
    width: 360
    height: 820
    visible: true
    title: "Зарплата"
    FontLoader { id: customFont; source: "font/Montserrat-Regular.ttf" }
    font.family: customFont.name

    property alias mainWindow:mainWindow


    SqlModelIncome{
        id:sqlModelIncome
    }

    SqlModelExpenses{
        id:sqlModelExpenses
    }
    SqlModelTarget{
        id:sqlModelTarget
    }


    property alias sqlModelIncome:sqlModelIncome
    property alias sqlModelExpenses:sqlModelExpenses
    property alias sqlModelTarget:sqlModelTarget

    property alias customFont:customFont


    property bool menuStatus: true

    Material.theme: Material.Light
    Material.accent: Material.Purple

    Rectangle{
        id:topMenu
        color:"#c86cf0"
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
            font.pixelSize: 20
            font.family: customFont.name
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
                    color:"#c86cf0"



                    height:90
                    width: parent.width
                    radius: 20
                    Text{
                        anchors.centerIn: parent
                        font.pixelSize: 15
                        font.family: customFont.name
                        text: qsTr("Заработано За Все Время\n"+sqlModelIncome.getIncomeAllTime());
                    }
                }

                Rectangle{
                    id:widgetMonth
                    color:"#c86cf0"
                    height:90
                    width:parent.width
                    radius: 20
                    Text {
                        anchors.centerIn: parent
                        font.pixelSize: 15
                        font.family: customFont.name
                        text: qsTr("Зредняя зарплата за день - \n"+sqlModelIncome.getAverageValue())
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
                    title:qsTr("Доходы")
                    iconButton:"pages/icon/income.png"
                    source:"pages/statisticIncomePage.qml"
                }

                ListElement{
                    title:qsTr("Расходы")
                    iconButton:"pages/icon/expenses.png"
                    source:"pages/statisticExpensesPage.qml"
                }
                ListElement{
                    title:qsTr("Цели")
                    iconButton:"pages/icon/note.png"
                    source:"pages/targetPage.qml"
                }

                /*ListElement{
                    title:qsTr("Настройки")
                    iconButton:"icon/settings.png"
                    source:"pages/settingsPage.qml"
                }*/
                ListElement{
                    title:qsTr("Для Разработчиков")
                    iconButton:"icon/dev.png"
                    source:"pages/devPage.qml"
                }
                /*ListElement{
                    title:qsTr("О")
                    iconButton:"icon/about.png"
                    source:"pages/aboutPage.qml"
                }*/
            }

            delegate: ItemDelegate{
                font.pixelSize: 16
                font.family: customFont.name
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




