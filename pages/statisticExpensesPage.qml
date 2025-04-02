import QtQuick
import QtQuick.Controls 2.12
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt.labs.qmlmodels
import QtCharts

Page {
    id: page


    property var sqlExpenses: sqlModelExpenses


    function updateChart(){
        chartView.title="Статистика за "+yearToChart.text
        pSeries.clear()

        var map = sqlExpenses.getStatisticYearChart(Number(yearToChart.text),"expenses","Expenses")
        for(var el in map) {
            var slice = pSeries.append(el+"-"+map[el], map[el])

            slice.labelVisible = pSeries.allLabelsVisible
            slice.labelPosition = pSeries.allLabelPosition
            slice.labelArmLengthFactor = pSeries.allLabelArmLength
            slice.borderWidth = pSeries.allBorderWidth
            slice.borderColor = pSeries.allBorderColor
            slice.color = "#dca1f6"

            slice.exploded = false
            slice.labelFont.pixelSize = 15
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Rectangle{
            id:page1

            HorizontalHeaderView {
                    id: horizontalHeader
                    anchors.left: tableSql.left
                    anchors.top: parent.top
                    syncView: tableSql
                }

            TableView {
                id:tableSql
                    anchors.top: horizontalHeader.bottom
                    anchors.topMargin: 25
                    height: parent.height-horizontalHeader.height-30
                    width: parent.width
                    columnSpacing: 1
                    rowSpacing: 1
                    model: sqlExpenses.getModelTable()

                    delegate: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 30


                        MouseArea{
                            anchors.fill:parent
                            onClicked: {
                                dialogText.text=display
                                tabElDialog.open()
                            }

                        }

                        Text {
                            text: display.length>10?display.substring(0,4)+"...":display
                            font.family: customFont.name
                            anchors.centerIn: parent
                            font.pixelSize: 16
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
        }
        Rectangle{
            id:page2



            Rectangle{
                id:yearFilter

                anchors.top: parent.top
                height:70
                anchors.topMargin: 15
                width: parent.width
                Row{
                    spacing: 10
                    anchors.centerIn: parent
                    TextField{
                        font.family: customFont.name
                        id:yearToChart
                        inputMask: "9999"
                        text:new Date().getFullYear()
                        font.pixelSize: 15
                    }
                    Button{
                        font.family: customFont.name
                        id:buttonYearChange
                        text: "Применить"
                        highlighted: true
                        onClicked: {
                            updateChart()
                        }
                    }

                }
            }






            ChartView {
                id: chartView
                animationOptions: ChartView.AllAnimations
                dropShadowEnabled: true
                antialiasing: true
                height: parent.height-yearFilter.height
                width: parent.width
                legend.visible: false
                anchors.bottom: parent.bottom
                titleFont.family:  customFont.name
                theme: ChartView.ChartThemeBlueNcs

                PieSeries {
                    id: pSeries

                    size: 1
                    holeSize: 0

                    property bool allLabelsVisible: true
                    property int allLabelPosition: PieSlice.LabelInsideNormal
                    property real allLabelArmLength: 0
                    property real allBorderWidth: 2
                    property color allBorderColor: "#c86cf0"

                }

                Component.onCompleted: {
                    updateChart()
                }
            }
        }

        Rectangle{
            id:page3

            Rectangle{
                id:yearFilterList

                anchors.top: parent.top
                height:70
                anchors.topMargin: 15
                width: parent.width
                Row{
                    spacing: 10
                    anchors.centerIn: parent
                    TextField{
                        font.family: customFont.name
                        id:yearToList
                        inputMask: "9999"
                        text: new Date().getFullYear()
                        font.pixelSize: 20
                    }
                    Button{
                        id:buttonYearList
                        font.family: customFont.name
                        text:"Применить"
                        highlighted: true
                        onClicked: {
                            list.model=sqlExpenses.getStatistic(Number(yearToList.text))
                        }
                    }
                }
            }

            ListView{
                id:list
                height: parent.height-yearFilterList.height-30
                width: parent.width
                anchors.bottom: parent.bottom
                anchors.leftMargin: 30
                model:sqlExpenses.getStatistic(Number(yearToList.text))

                delegate: Text{
                    font.family: customFont.name
                    font.pixelSize: 17
                    anchors.margins: 7
                    text:model.display
                    width: list.width
                }

            }
        }
    }


    footer: TabBar {
        id: tabBar
        font.family: customFont.name
        currentIndex: swipeView.currentIndex

        TabButton {
            icon.source: "icon/table.png"
        }
        TabButton {
            icon.source: "icon/chart.png"
        }
        TabButton {
            icon.source: "icon/rept.png"
        }

    }
}
