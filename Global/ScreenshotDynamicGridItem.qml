// gameOS theme
// created by BozoTheGeek 11/09/2023 to manage "screenshots" in this theme

import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: root
    
    // NOTE: This is technically duplicated from utils.js but importing that file into every delegate causes crashes
    function steamAppID (gameData) {
        var str = gameData.assets.boxFront.split("header");
        return str[0];
    }

    function steamLogo(gameData) {
        return steamAppID(gameData) + "/logo.png"
    }


    function logo(data) {
        if (data !== null) {
            if (data.assets.boxFront.includes("header.jpg"))
                return steamLogo(data);
            else {
                if (data.assets.logo !== "")
                    return data.assets.logo;
            }
        }
        return "";
    }

    signal activated
    signal highlighted
    signal unhighlighted

    property bool selected
    property var gameData: modelData


    // In order to use the retropie icons here we need to do a little collection specific hack
    property bool playVideo: gameData ? gameData.assets.videoList.length && (settings.AllowThumbVideo === "Yes") : ""
    scale: selected ? 1 : 0.95
    Behavior on scale { NumberAnimation { duration: 100 } }
    z: selected ? 10 : 1


    property bool validated: videoToStop || demoLaunched

    onValidatedChanged:
    {
        if(detailed_debug) {
            console.log("DynamicGridItem.onValidatedChanged - validated :", validated);
            console.log("DynamicGridItem.onValidatedChanged - selected :", selected);
            console.log("DynamicGridItem.onValidatedChanged - videoToStop : ", videoToStop);
            console.log("DynamicGridItem.onValidatedChanged - demoLaunched :", demoLaunched);
        }
        if (selected && validated)
        {
            fadescreenshot.stop();
            screenshot.opacity = 1;
            container.opacity = 1;
        }
    }

    onSelectedChanged: {
        if(detailed_debug) {
            console.log("DynamicGridItem.onSelectedChanged - validated :", validated);
            console.log("DynamicGridItem.onSelectedChanged - selected :", selected);
            console.log("DynamicGridItem.onSelectedChanged - videoToStop : ", videoToStop);
            console.log("DynamicGridItem.onSelectedChanged - demoLaunched : ",demoLaunched);
        }
        if (selected && playVideo && !validated)
            fadescreenshot.restart();
        else {
            fadescreenshot.stop();
            screenshot.opacity = 1;
            container.opacity = 1;
        }
    }

    // NOTE: Fade out the bg so there is a smooth transition into the video
    Timer {
        id: fadescreenshot

        interval: 1200
        onTriggered: {
            if (settings.HideLogo === "Yes")
                container.opacity = 0;
            else
                screenshot.opacity = 0;
        }
    }

    Item
    {
        id: container

        anchors.fill: parent
        Behavior on opacity { NumberAnimation { duration: 200 } }

        Image {
            id: screenshot

            anchors.fill: parent
            anchors.margins: vpx(2)
            source: modelData ? modelData.files.get(0).path : ""
            fillMode: Image.PreserveAspectCrop
            sourceSize: Qt.size(screenshot.width, screenshot.height)
            smooth: false
            asynchronous: true
            Behavior on opacity { NumberAnimation { duration: 200 } }
        }

        Image {
            id: favelogo

            anchors.fill: parent
            anchors.centerIn: parent
            anchors.margins: root.width/10
            property var logoImage: (gameData && gameData.collections.get(0).shortName === "retropie") ? gameData.assets.boxFront : (gameData.collections.get(0).shortName === "steam") ? logo(gameData) : gameData.assets.logo
            source: modelData ? logoImage || "" : ""
            sourceSize: Qt.size(favelogo.width, favelogo.height)
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            smooth: true
            scale: selected ? 1.1 : 1
            Behavior on scale { NumberAnimation { duration: 100 } }
            z: 10
        }

        Rectangle {
            id: overlay

            anchors.fill: parent
            color: screenshot.source == "" ? theme.secondary : "black"
            opacity: screenshot.source == "" ? 1 : selected ? 0.1 : 0.2
        }
        
        Rectangle {
            id: regborder

            anchors.fill: parent
            color: "transparent"
            border.width: vpx(1)
            border.color: "white"
            opacity: 0.1
        }
        
    }

    Loader {
        id: borderloader

        active: selected
        anchors.fill: parent
        sourceComponent: border
        asynchronous: true
    }

    Component {
        id: border

        ItemBorder { }
    }

    Rectangle {
        id: favicon

        anchors {
            right: parent.right; rightMargin: vpx(10);
            top: parent.top; topMargin: vpx(10)
        }
        width: parent.width / 12
        height: width
        radius: width/2
        color: theme.accent
        visible: gameData.favorite
        Image {
            source: "../assets/images/favicon.svg"
            asynchronous: true
            anchors.fill: parent
            anchors.margins: parent.width / 6
        }
    }

    Loader {
        id: spinnerloader

        anchors.centerIn: parent
        active: screenshot.status === Image.Loading
        sourceComponent: loaderspinner
    }

    Component {
        id: loaderspinner

        Image {
            source: "../assets/images/loading.png"
            width: vpx(50)
            height: vpx(50)
            asynchronous: true
            sourceSize: Qt.size(width, height)
            RotationAnimator on rotation {
                loops: Animator.Infinite;
                from: 0;
                to: 360;
                duration: 500
            }
        }
    }
    
    // List specific input
    Keys.onPressed: {
        // Accept
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            activated();
        }
    }

    // Mouse/touch functionality
    MouseArea {
        anchors.fill: parent
        hoverEnabled: settings.MouseHover === "Yes"
        onEntered: { sfxNav.play(); highlighted(); }
        onExited: { unhighlighted(); }
        onClicked: {
            sfxNav.play();
            activated();
        }
    }
}
