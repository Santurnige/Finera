import QtQuick
import QtQuick.Controls 2.12
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt.labs.qmlmodels
import QtCharts
Page {
    id: page

    property var sqlModel: sqlMdl


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
                    model: sqlModel.getModel()

                    delegate: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 30
                        border.color: "lightgray"

                        Text {
                            text: display
                            anchors.centerIn: parent
                        }
                    }
                }
        }
        Rectangle{
            id:page2

            Rectangle{
                anchors.top: parent.top
                height:70
                anchors.topMargin: 15
                width: parent.width
                Row{
                    spacing: 10
                    anchors.centerIn: parent
                    TextField{
                        id:dateTo
                        inputMask: "99.99.9999"
                        text: "01.01."+new Date().getFullYear()
                        font.pixelSize: 15
                    }
                    TextField{
                        id:dateAfter
                        inputMask: "99.99.9999"
                        text: "31.12."+new Date().getFullYear()
                        font.pixelSize: 15
                    }
                }
            }






            ChartView {
                    id: chartView
                    rotation: 90
                    title: "Статистика за 2025"
                    dropShadowEnabled: true
                    antialiasing: true
                    legend.alignment: Qt.AlignBottom
                    legend.markerShape: Legend.MarkerShapeCircle
                    height: parent.width
                    width: parent.height
                    anchors.centerIn: parent
                    theme: ChartView.ChartThemeBrownSand
                    PieSeries{
                        id:pSeries
                    }
                    Component.onCompleted: {
                      var map=sqlModel.getStatisticYearChart(2025)
                        for(var el in map){
                            pSeries.append(el,map[el])
                        }
                    }
            }
        }

        Rectangle{
            id:page3
            ListView{
                id:list
                anchors.fill: parent
                model:sqlModel.getStatistic(2025)
                anchors.leftMargin: 10

                delegate: Text{
                    font.pixelSize: 22
                    anchors.margins: 7
                    text:model.display
                    width: list.width
                }

            }
        }
    }


    footer: TabBar {
        id: tabBar
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
