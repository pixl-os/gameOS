import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.15
Item {
    width: 26
    height: 14

    property bool lightStyle : false

    property var percent: {
        api.device ? api.device.batteryPercent : 0
    }

    Image {
        id: iconImage
        source: lightStyle ? "../assets/images/battery.png" : "../assets/images/battery-dark.png"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
    
    Rectangle {
        anchors.leftMargin: 3
        anchors.topMargin: 3
        anchors.top: iconImage.top
        anchors.left: iconImage.left
        anchors.verticalCenter: iconImage.verticalCenter
        color: lightStyle ? "#ffffff" : "#000000"
        radius: 2
        width: Math.max(percent * 17.6, 2)
        height: 8
    }
}
