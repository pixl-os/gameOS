import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.15
Item {
    width: vpx(32)
    height: vpx(26)
    property var percent: api.device ? api.device.batteryPercent : 0
    //for testing purpose
    /*{
        if(isDebugEnv() && false){
            //to simulate 50%, 10%, etc...
            return 0.6;
        }
        else{
            return (api.device ? api.device.batteryPercent : 0);
        }
    }*/

    property var charging: api.device ? api.device.batteryCharging : false
    //for testing purpose
    /*{
        if(isDebugEnv() && false){
            //to simulate charging or not.
            return true
        }
        else{
            return (api.device ? api.device.batteryCharging : false);
        }
    }*/

    Rectangle {
        id: batteryLevel
        anchors.left: iconImage.left
        anchors.leftMargin: vpx(1)
        anchors.rightMargin: vpx(2)
        anchors.top: iconImage.top
        anchors.topMargin: vpx(6)
        anchors.bottom: iconImage.bottom
        anchors.bottomMargin: vpx(5)
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

    Text {
        id: detailsText

        function set() {
            detailsText.text = parseInt(percent*100) + "%"
        }

        Timer {
            id: remainingTimeTimer
            interval: 120000 // Run the timer every 2 minutes
            repeat: true
            running: parent.rotation == 0 ? true : false
            triggeredOnStart: true
            onTriggered: detailsText.set()
        }

        anchors {
            top: batteryLevel.bottom;
            right: parent.right;
            rightMargin: vpx(5);
            topMargin: vpx(2);
        }
        color: "white"
        font.pixelSize: vpx(9)
        font.family: subtitleFont.name
        horizontalAlignment: Text.Right
        verticalAlignment: Text.AlignVCenter
        visible: parent.rotation == 0 ? true : false
    }
}
