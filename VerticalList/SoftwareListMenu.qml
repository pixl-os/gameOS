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

//restored and adapted by BozoTheGeek 31/07/2022

import QtQuick 2.12
import QtQuick.Layouts 1.12
import "../Global"
import "../GameDetails"
import "../Lists"
import "../utils.js" as Utils
import "qrc:/qmlutils" as PegasusUtils

FocusScope {
    id: root

    property real itemheight: vpx(50)
    property int skipnum: 10

    ListCollectionGames { id: list; }

    Component.onCompleted: {
        //to set game to display
        currentGame = list.currentGame(softwarelist.currentIndex);
    }

    Rectangle {
        id: header
        
        anchors {
            top:    parent.top
            left:   parent.left
            right:  parent.right
        }
        height: vpx(75)
        color: theme.main

        HeaderBar {
            id: headercontainer

            anchors.fill: parent
        }
        Keys.onDownPressed: {
            sfxNav.play();
            softwarelist.focus = true;
            if((softwarelist.currentIndex < softwarelist.count) && (softwarelist.currentIndex >= 0)){
                //do nothing
            } else softwarelist.currentIndex = 0; //set index
        }
    }

    /*Image {
        id: screenshot

        anchors {
            top: header.bottom
            left: softwarelist.right
            right: parent.right
            bottom: parent.bottom; bottomMargin: globalMargin + helpMargin
        }
        asynchronous: true
        source: currentGame && currentGame.assets.screenshots[0] ? currentGame.assets.screenshots[0] : ""
        fillMode: Image.PreserveAspectCrop
        smooth: true

        GameInfo {
            id: info

            anchors {
                left: parent.left; leftMargin: globalMargin
                right: parent.right; rightMargin: globalMargin
                bottom: parent.bottom; bottomMargin: globalMargin + helpMargin
            }
            height: vpx(230)
        }
    }*/
    Rectangle{
        id: gameViewArea
        anchors {
            top: header.bottom; topMargin: - globalMargin + vpx(20)
            left: softwarelist.right
            right: parent.right
            bottom: parent.bottom; //bottomMargin: vpx(10) + helpMargin
        }
        focus: false
        onFocusChanged: {
            if (focus) {
                currentHelpbarModel = verticalListHelpModel;
                softwarelist.focus = false;
            }
        }
        GameView{
            id: gameview
            focus: false
            game: currentGame
            embedded: true
        }
    }

    // Software list
    ListView {
        id: softwarelist

        currentIndex: currentGameIndex
        onCurrentIndexChanged: {
            if (currentIndex != -1){
                currentGameIndex = currentIndex;
                currentGame = list.currentGame(softwarelist.currentIndex)
            }
        }

        focus: true

        anchors {
            top: header.bottom; topMargin: globalMargin
            bottom: parent.bottom; bottomMargin: globalMargin
            left: parent.left
        }
        width: appWindow.width * (parseFloat("30%")/100)

        spacing: vpx(0)
        orientation: ListView.Vertical

        preferredHighlightBegin: softwarelist.height / 2 - itemheight
        preferredHighlightEnd: softwarelist.height / 2
        highlightRangeMode: ListView.ApplyRange
        highlightMoveDuration: 100
        clip: true

        model: list.games
        delegate: softwarelistdelegate

        // List item
        Component {
            id: softwarelistdelegate

            Item {
                id: delegatecontainer

                width: ListView.view.width
                height: itemheight
                property bool selected: ListView.isCurrentItem

                Rectangle {
                    width: vpx(3)
                    anchors {
                        left: parent.left; leftMargin: vpx(11)
                        top: parent.top; topMargin: vpx(5)
                        bottom: parent.bottom; bottomMargin: vpx(5)
                    }
                    color: theme.text
                    visible: selected && !gameview.focus

                }


                // Description
                PegasusUtils.HorizontalAutoScroll
                {
                    id: gameDescription

                    scrollWaitDuration: 1000 // in ms
                    pixelsPerSecond: 20
                    activated: delegatecontainer.selected

                    height: parent.height
                    anchors {
                        left: parent.left; leftMargin: vpx(25)
                        right: parent.right; rightMargin: vpx(25)
                    }

                    Text {
                        id: gametitle

                        text: modelData.title

                        height: parent.height
                        /*anchors {
                            left: parent.left; leftMargin: vpx(25)
                            right: parent.right; rightMargin: vpx(25)
                        }*/

                        color: theme.text
                        font.family: subtitleFont.name
                        font.pixelSize: vpx(20)
                        //elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        opacity: selected ? 1 : 0.2
                    }
                }
                // Mouse/touch functionality
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (selected)
                            launchGame();
                        else
                            softwarelist.currentIndex = index
                    }
                }
            }
        }
    }

    // Handle input
    // Up
    Keys.onUpPressed: {
        if (softwarelist.currentIndex != 0)
            softwarelist.currentIndex--;
        else
            softwarelist.currentIndex = softwarelist.count - 1
    }
    // Down
    Keys.onDownPressed: {
        if (softwarelist.currentIndex != softwarelist.count - 1)
            softwarelist.currentIndex++;
        else
            softwarelist.currentIndex = 0;
    }
    // Left
    Keys.onLeftPressed: {
        /*if (softwarelist.currentIndex > skipnum)
            softwarelist.currentIndex = softwarelist.currentIndex - skipnum;
        else
            softwarelist.currentIndex = 0;*/
    }
    // Right
    Keys.onRightPressed:  {
        /*if (softwarelist.currentIndex < softwarelist.count - skipnum)
            softwarelist.currentIndex = softwarelist.currentIndex + skipnum;
        else
            softwarelist.currentIndex = softwarelist.count - 1*/
        softwarelist.focus = false;
        gameview.focus = true;
    }

    Keys.onPressed: {
        // Accept
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if (!gameview.focus) {
                launchGame();
            }
            //is it really used ?!
            /*else {
                currentGameIndex = 0;
                softwarelist.focus = true;
            }*/
            
        }
        // Back
        if (api.keys.isCancel(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if (softwarelist.focus) {
                previousScreen();
            } else {
                currentGameIndex = 0;
                softwarelist.focus = true;
            }
        }
        // Filters/Search
        if (api.keys.isFilters(event) && !event.isAutoRepeat) {
            event.accepted = true;
            sfxToggle.play();
            softwarelist.focus = false;
            gameview.focus = false;
            gameViewArea.focus = false;
            headercontainer.focus = true;
            return;
        }
        // Toggle favorite
        if (api.keys.isDetails(event) && !event.isAutoRepeat) {
            //if (softwarelist.focus) {
                console.log("Toggle favorite");
                event.accepted = true;
                sfxToggle.play();
                list.currentGame(softwarelist.currentIndex).favorite = !list.currentGame(softwarelist.currentIndex).favorite;
            //}
        }
    }

    // Helpbar buttons
    ListModel {
        id: verticalListHelpModel
        ListElement {
            name: qsTr("Back")
            button: "cancel"
        }
        ListElement {
            name: qsTr("Toggle favorite")
            button: "details"
        }
        ListElement {
            name: qsTr("Filters/Search")
            button: "filters"
        }
        ListElement {
            name: qsTr("Launch")
            button: "accept"
        }
    }
    
    onFocusChanged: {
        //console.log("SoftwareListMenu::onFocusChanged()");
        if (focus) currentHelpbarModel = verticalListHelpModel;
    }
}
