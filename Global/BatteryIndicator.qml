import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.15
Item {
    width: vpx(32)
    height: vpx(26)
    property var percent: {
        if(isDebugEnv() && false){
            //to simulate 50%, 10%, etc...
            return 0.6;
        }
        else{
            return (api.device ? api.device.batteryPercent : 0);
        }
    }

    property var charging: {
        if(isDebugEnv() && false){
            //to simulate charging or not.
            return true
        }
        else{
            return (api.device ? api.device.batteryCharging : false);
        }
    }
    
    Rectangle {
        anchors.left: iconImage.left
        anchors.leftMargin: vpx(1)
        anchors.rightMargin: vpx(2)
        anchors.top: iconImage.top
        anchors.topMargin: vpx(6)
        anchors.bottom: iconImage.bottom
        anchors.bottomMargin: vpx(6)
        anchors.verticalCenter: iconImage.verticalCenter
        color: percent >= 0.50 ? "green" : (percent >= 0.30 ? "yellow" : ( percent > 0.10 ? "orange" : "red"))
        width: Math.max(percent * (iconImage.width), 2) - (anchors.leftMargin + anchors.rightMargin)
    }

    Image {
        id: iconImage
        width: parent.width - vpx(2)
        height: parent.height - vpx(2)
        fillMode: Image.Stretch
        source: "../assets/images/battery-empty-white.svg"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible:!charging
    }

    Image {
        id: iconImageCharging
        width: parent.width - vpx(2)
        height: parent.height - vpx(2)
        fillMode: Image.Stretch
        source: "../assets/images/battery-charging-white.svg"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible:charging
    }

}
