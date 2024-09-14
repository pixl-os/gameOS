// gameOS theme
// Copyright (C) 2018-2020 Seth Powell 
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: root

    // Load settings
    property alias choosenMedia: screenshot.choosenMedia

    // NOTE: This is technically duplicated from utils.js but importing that file into every delegate causes crashes
    function steamAppID (gameData) {
        var str = gameData.assets.boxFront.split("header");
        return str[0];
    }

    function steamBoxArt(gameData) {
        return steamAppID(gameData) + '/library_600x900_2x.jpg';
    }

    function chooseMedia(data,asset) {
      if (data !== null && (asset !== null || asset !== "")) {
        switch (asset) {
          case "boxFront":
            if (data.assets.boxFront !== "")
              return data.assets.boxFront;
            break
          case "box2d":
            if (data.assets.box2d !== "")
              return data.assets.box2d;
            break
          case "box3d":
            if (data.assets.box3d !== "")
              return data.assets.box3d;
            break
          case "boxBack":
            if (data.assets.boxBack !== "")
              return data.assets.boxBack;
            break
          case "boxSpine":
            if (data.assets.boxSpine !== "")
              return data.assets.boxSpine;
            break
          case "boxFull":
            if (data.assets.boxFull !== "")
              return data.assets.boxFull;
            break
          case "cartridge":
            if (data.assets.cartridge !== "")
              return data.assets.cartridge;
            break
          case "cartridgetexture":
            if (data.assets.cartridgetexture !== "")
              return data.assets.cartridgetexture;
            break
          case "logo":
            if (data.assets.logo !== "")
              return data.assets.logo;
            break
          case "wheel":
            if (data.assets.wheel !== "")
              return data.assets.wheel;
            break
          case "wheelcarbon":
            if (data.assets.wheelcarbon !== "")
              return data.assets.wheelcarbon;
            break
          case "wheelsteel":
            if (data.assets.wheelsteel !== "")
              return data.assets.wheelsteel;
            break
          case "poster":
            if (data.assets.poster !== "")
              return data.assets.poster;
            break
          case "fanart":
            if (data.assets.fanart !== "")
              return data.assets.fanart;
            break
          case "marquee":
            if (data.assets.marquee !== "")
              return data.assets.marquee;
            break
          case "bezel":
            if (data.assets.bezel !== "")
              return data.assets.bezel;
            break
          case "panel":
            if (data.assets.panel !== "")
              return data.assets.panel;
            break
          case "cabinetLeft":
            if (data.assets.cabinetLeft !== "")
              return data.assets.cabinetLeft;
            break
          case "cabinetRight":
            if (data.assets.cabinetRight !== "")
              return data.assets.cabinetRight;
            break
          case "screenmarquee":
            if (data.assets.screenmarquee !== "")
              return data.assets.screenmarquee;
            break
          case "screenmarqueesmall":
            if (data.assets.screenmarqueesmall !== "")
              return data.assets.screenmarqueesmall;
            break
          case "tile":
            if (data.assets.tile !== "")
              return data.assets.tile;
            break
          case "banner":
            if (data.assets.banner !== "")
              return data.assets.banner;
            break
          case "steam":
            if (data.assets.steam !== "")
              return data.assets.steam;
            break
          case "background":
            if (data.assets.background !== "")
              return data.assets.background;
            break
          case "music":
            if (data.assets.music !== "")
              return data.assets.music;
            break
          case "image":
            if (data.assets.image !== "")
              return data.assets.image;
            break
          case "screenshot":
            if (data.assets.screenshot !== "")
              return data.assets.screenshot;
            break
          case "screenshot_bis":
            if (data.assets.screenshot_bis !== "")
              return data.assets.screenshot_bis;
            break
          case "thumbnail":
            if (data.assets.thumbnail !== "")
              return data.assets.thumbnail;
            break
          case "titlescreen":
            if (data.assets.titlescreen !== "")
              return data.assets.titlescreen;
            break
          case "video":
            if (data.assets.video !== "")
              return data.assets.video;
            break
          case "videomix":
            if (data.assets.videomix !== "")
              return data.assets.videomix;
            break
          case "manual":
            if (data.assets.manual !== "")
              return data.assets.manual;
            break
          case "maps":
            if (data.assets.maps !== "")
              return data.assets.maps;
            break
          case "extra1":
            if (data.assets.extra1 !== "")
              return data.assets.extra1;
            break
          case "mix":
            if (data.assets.mix !== "")
              return data.assets.mix;
            break
          case "fullmedia":
            if (data.assets.fullmedia !== "")
              return data.assets.fullmedia;
            break
          default:
              console.log("Unknown asset");
        }
      }
      return "";
    }

    function boxArt(data, media) {
      if (data !== null) {
        if (media !== ""){
          return chooseMedia(data,media);
        }
        if (data.assets.boxFront.includes("/header.jpg")) 
          return steamBoxArt(data);
        else {
          if (data.assets.boxFront !== "")
            return data.assets.boxFront;
          else if (data.assets.poster !== "")
            return data.assets.poster;
          else if (data.assets.banner !== "")
            return data.assets.banner;
          else if (data.assets.tile !== "")
            return data.assets.tile;
          else if (data.assets.cartridge !== "")
            return data.assets.cartridge;
          else if (data.assets.logo !== "")
            return data.assets.logo;
          else if (data.assets.wheel !== "")
            return data.assets.wheel;
          else if (data.assets.wheelcarbon !== "")
            return data.assets.wheelcarbon;
          else if (data.assets.wheelsteel !== "")
            return data.assets.wheelsteel;
        }
      }
      return "";
    }

    property bool selected
    Behavior on scale { NumberAnimation { duration: 100 } }
    property var gameData
    property int columns: 6

    scale: selected ? 1.1 : 1
    z: selected ? 10 : 1

    signal activate()
    signal highlighted()

    Component.onCompleted: {
        //console.log("BoxArtGridIem root Completed")
    }
    
    Component.onDestruction: {
        //console.log("BoxArtGridIem root Destroyed")
    }
    
    Item
    {
        id: container

        anchors.fill: parent
        anchors.margins: vpx(6)
        Behavior on opacity { NumberAnimation { duration: 200 } }

        Image {
            id: screenshot
            property string choosenMedia: ""

            anchors.fill: parent
            anchors.margins: vpx(2)
            asynchronous: true
            source: boxArt(gameData, choosenMedia)
            sourceSize { width: root.width; height: root.height }
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            property bool isDestroyed 
            onStatusChanged:{
                if (screenshot.status == Image.Ready && gameData){
                    ra_timer.restart();
                    isDestroyed = false;
                }
            }
            Component.onCompleted: {
                //console.log("BoxArtGridIem screenshot Completed")
            }
            Component.onDestruction: {
                //console.log("BoxArtGridIem screenshot Destroyed")
                isDestroyed = true;
            }
            // NOTE: Fade out the bg so there is a smooth transition into the video
            Timer {
                id: ra_timer
                interval: 1000
                running: false
                triggeredOnStart: false
                repeat: false
                onTriggered: {
                    //console.log("parent.isDestroyed : ", parent.isDestroyed);
                     if (gameData){
                        /*var path = gameData.files.get(0).path;
                        var word = path.split('/');
                        console.log("collection : " + gameData.collections.get(0).shortName)
                        console.log("game : " + gameData.title)
                        console.log("rom : " + word[word.length-1])*/
                        if(!screenshot.isDestroyed){
                            gameData.checkRetroAchievements();
                        }
                    }
                }
            }
            Rectangle {
                id: favicon

                anchors {
                    left: parent.left; leftMargin: vpx(4);
                    top: parent.top; topMargin: visible ? vpx(4) : vpx(0);
                }
                width: visible ? vpx(20) : vpx(0)
                height: width
                radius: width/2
                color: theme.accent
                visible: gameData.favorite
                Image {
                    source: "../assets/images/favicon.svg"
                    asynchronous: true
                    anchors.fill: parent
                    anchors.margins: vpx(4)
                }
            }
            Rectangle {
                id: raicon

                anchors {
                    left: parent.left; leftMargin: vpx(4);
                    top: favicon.bottom; topMargin: visible ? vpx(4) : vpx(0);
                }
                width: visible ? vpx(20) : vpx(0)
                height: width
                radius: width/2
                color: theme.accent
                visible: (gameData.RaGameID > 0) ? true : false
                Image {
                    source: "../assets/images/icon_cup.svg"
                    asynchronous: true
                    anchors.fill: parent
                    anchors.margins: vpx(4)
                }
            }
            Rectangle {
                id: lighgunicon

                anchors {
                    left: parent.left; leftMargin: vpx(4);
                    top: raicon.bottom; topMargin: visible ? vpx(4) : vpx(0);
                }
                width: visible ? vpx(20) : vpx(0)
                height: width
                radius: width/2
                color: theme.accent
                visible: typeof gameData.lightgungame !== "undefined" ? gameData.lightgungame : false;
                Image {
                    source: "../assets/images/icon_zapper.svg"
                    asynchronous: true
                    anchors.fill: parent
                    anchors.margins: vpx(4)
                }
            }
        }

        Rectangle {
            id: regborder

            anchors.fill: parent
            color: "transparent"
            border.width: vpx(1)
            border.color: "white"
            opacity: 0.1
            visible: false
        }

        Rectangle {
            id: overlay

            width: screenshot.paintedWidth
            height: screenshot.paintedHeight
            anchors.centerIn: screenshot
            color: screenshot.source == "" ? theme.secondary : "black"
            opacity: screenshot.source == "" ? 1 : selected ? 0.0 : 0.2
            visible: false
        }

        
    }

    Loader {
        active: selected
        anchors.fill: container
        sourceComponent: border
        asynchronous: true
    }

    Component {
        id: border

        ItemBorder { }
    }

    Text {
        id: title

        text: modelData ? modelData.title : ''
        color: theme.text
        font {
            family: subtitleFont.name
            pixelSize: vpx(12)
            bold: true
        }

        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        anchors {
            top: container.bottom; topMargin: vpx(8)
            left: parent.left; right: parent.right
        }

        opacity: 0.5
        visible: settings.AlwaysShowTitles === "Yes" && !selected
    }

    Text {
        id: platformname

        text: modelData.title
        anchors { fill: parent; margins: vpx(10) }
        color: "white"
        scale: selected ? 1.1 : 1
        Behavior on opacity { NumberAnimation { duration: 100 } }
        font.pixelSize: vpx(18)
        font.family: subtitleFont.name
        font.bold: true
        style: Text.Outline; styleColor: theme.main
        visible: screenshot.status === Image.Null || screenshot.status === Image.Error
        anchors.centerIn: parent
        elide: Text.ElideRight
        wrapMode: Text.WordWrap
        lineHeight: 0.8
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
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
            sourceSize { width: vpx(50); height: vpx(50) }
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
            activate();
        }
    }

    // Mouse/touch functionality
    MouseArea {
        anchors.fill: parent
        hoverEnabled: settings.MouseHover === "Yes"
        onEntered: { sfxNav.play(); highlighted(); }
        onClicked: {
            sfxNav.play();
            activate();
        }
    }
    
    /*// Mouse/touch functionality
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {}
        onExited: {}
        onClicked: {
            if (selected)
            {
                activate();
            }
            else
            {
                currentGameIndex = index
            }
        }
    }*/
}
