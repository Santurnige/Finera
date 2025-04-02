import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Item {
    id:root

    property string ptargetId: ""
    property string ptargetName: ""
    property int pfinalTotal: 0
    property int pcurrentBalance: 0
    property int pdiffBalance: 0
    property string pabout: ""

    height:85

    Rectangle {

        anchors.fill: parent

        border.width: 2
        border.color: "#bbbbbb"
        radius: 10

        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10
            spacing: 10

            Text {
                id: idElement
                font.family: customFont.name
                font.pixelSize: 16
                text: ptargetId
            }

            Text {
                id: targetName
                font.family: customFont.name
                font.pixelSize: 18
                text: ptargetName
            }
        }

        Column {
            spacing: 5
            anchors.rightMargin:5
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: finalTotal
                font.pixelSize: 20
                font.family: customFont.name
                text: pfinalTotal
                color: "#d90000"
            }

            Text {
                id: currentBalance
                font.family: customFont.name
                font.pixelSize: 16
                text: pcurrentBalance
                color: "#0df90d"
            }

            Text {
                id: diffBalance
                text: pfinalTotal - pcurrentBalance
                font.family: customFont.name
                font.pixelSize: 12
                color: "#8b8b8b"
            }
        }
    }


}
