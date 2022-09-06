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
import "qrc:/qmlutils" as PegasusUtils
import "../Global"
import "../GameDetails"
import "../Lists"
import "../utils.js" as Utils

FocusScope {
    id: root

    // While not necessary to do it here, this means we don't need to change it in both
    // touch and gamepad functions each time
    function gameActivated() {
        //console.log("list.currentGame(gamegrid.currentIndex) : ",list.currentGame(gamegrid.currentIndex));
        //check added when search is empty and we try to launch a game in all cases
        if(list.currentGame(softwarelist.currentIndex) !== null){
            storedCollectionGameIndex = softwarelist.currentIndex
            //gameDetails(list.currentGame(gamegrid.currentIndex));
        }
    }

    property real itemheight: vpx(50)
    property int skipnum: 10

    property var sortedGames: null;
    property bool isLeftTriggerPressed: false;
    property bool isRightTriggerPressed: false;

    property real lastL1PressedTimestamp: 0
    property real lastR1PressedTimestamp: 0
    property int nextLetterDirection

    //Timer to launch nextLetterDirection after 250 ms (to let detection of L1+R1)
    Timer {
        id: navigateToNextLetterTimer
        running: false
        triggeredOnStart: false
        repeat: false
        interval: 200
        onTriggered: {
            if ((lastL1PressedTimestamp !== 0) || (lastR1PressedTimestamp !== 0)) {
                navigateToNextLetter(nextLetterDirection)
            }
        }
    }

    function nextChar(c, modifier) {
        const firstAlpha = 97;
        const lastAlpha = 122;

        var charCode = c.charCodeAt(0) + modifier;

        if (modifier > 0) { // Scroll down
            if (charCode < firstAlpha || isNaN(charCode)) {
                return 'a';
            }
            if (charCode > lastAlpha) {
                return '';
            }
        } else { // Scroll up
            if (charCode === firstAlpha - 1) {
                return '';
            }
            if (charCode < firstAlpha || charCode > lastAlpha || isNaN(charCode)) {
                return 'z';
            }
        }

        return String.fromCharCode(charCode);
    }

    function navigateToNextLetter(modifier) {
        if (sortByFilter[sortByIndex].toLowerCase() !== "title") {
            return false;
        }

        var currentIndex = softwarelist.currentIndex;
        if (currentIndex === -1) {
            softwarelist.currentIndex = 0;
        }
        else {
            // NOTE: We should be using the scroll proxy here, but this is significantly faster.
            if (sortedGames === null) {
                sortedGames = list.collection.games.toVarArray().map(g => g.title.toLowerCase()).sort((a, b) => a.localeCompare(b));
            }

            var currentGameTitle = sortedGames[currentIndex];
            var currentLetter = currentGameTitle.toLowerCase().charAt(0);

            const firstAlpha = 97;
            const lastAlpha = 122;

            if (currentLetter.charCodeAt(0) < firstAlpha || currentLetter.charCodeAt(0) > lastAlpha) {
                currentLetter = '';
            }

            var nextIndex = currentIndex;
            var nextLetter = currentLetter;

            do {
                do {
                    nextLetter = nextChar(nextLetter, modifier);

                    if (currentLetter === nextLetter) {
                        break;
                    }

                    if (nextLetter === '') {
                        if (sortedGames.some(g => g.toLowerCase().charCodeAt(0) < firstAlpha || g.toLowerCase().charCodeAt(0) > lastAlpha)) {
                            break;
                        }
                    }
                    else if (sortedGames.some(g => g.charAt(0) === nextLetter)) {
                        break;
                    }
                } while (true)

                nextIndex = sortedGames.findIndex(g => g.toLowerCase().localeCompare(nextLetter) >= 0);
            } while(nextIndex === -1)

            softwarelist.currentIndex = nextIndex;

            nextLetter = sortedGames[nextIndex].toLowerCase().charAt(0);
            var nextLetterCharCode = nextLetter.charCodeAt(0);
            if (nextLetterCharCode < firstAlpha || nextLetterCharCode > lastAlpha) {
                nextLetter = '#';
            }

            navigationLetterOpacityAnimator.running = false
            navigationLetter.text = nextLetter.toUpperCase();
            navigationOverlay.opacity = 0.8;
            navigationLetterOpacityAnimator.running = true
        }

        softwarelist.focus = true;
        sfxToggle.play();

        return true;
    }

    ListCollectionGames { id: list; }

    Rectangle {
        id: navigationOverlay
        anchors.fill: parent;
        color: theme.main
        opacity: 0
        z: 10

        Text {
            id: navigationLetter
            antialiasing: true
            renderType: Text.NativeRendering
            font.hintingPreference: Font.PreferNoHinting
            font.family: titleFont.name
            font.capitalization: Font.AllUppercase
            font.pixelSize: vpx(200)
            color: "white"
            anchors.centerIn: parent
        }

        SequentialAnimation {
            id: navigationLetterOpacityAnimator
            PauseAnimation { duration: 500 }
            OpacityAnimator {

                target: navigationOverlay
                from: navigationOverlay.opacity
                to: 0;
                duration: 500
            }
        }
    }

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

        Component.onCompleted: {
            currentIndex = storedCollectionGameIndex;
            positionViewAtIndex(currentIndex, ListView.Visible);
        }

        populate: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
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
                        if (selected){
                            gameActivated();
                            launchGame();
                        }
                        else{
                            softwarelist.currentIndex = index
                        }
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
        gameActivated();
        softwarelist.focus = false;
        gameview.focus = true;
    }

    Keys.onReleased: {
        // Scroll Down - use R1 now
        if (api.keys.isNextPage(event) && !event.isAutoRepeat) {
            event.accepted = true;
            //to reset demo
            resetDemo();
            return;
        }

        // Scroll Up - use L1 now
        if (api.keys.isPrevPage(event) && !event.isAutoRepeat) {
            event.accepted = true;
            return;
        }

        // Next collection - R2 now
        if (api.keys.isPageDown(event) && !event.isAutoRepeat) {
            event.accepted = true;
            api.internal.system.run("sleep 0.2"); //ad sleep to avoid multievents
            isRightTriggerPressed = false;
            return;
        }

        // Previous collection - L2 now
        if (api.keys.isPageUp(event) && !event.isAutoRepeat) {
            event.accepted = true;
            api.internal.system.run("sleep 0.2"); //ad sleep to avoid multievents
            isLeftTriggerPressed = false;
            return;
        }
    }

    //Random Game
    property int maximum: softwarelist.count
    property int minimum: 0

    Keys.onPressed: {
        // Accept
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if (!gameview.focus) {
                gameActivated();
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
                gameActivated();
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

        // Random Game math here for best refresh
        var randomGame = Math.floor(Math.random() * (maximum - minimum + 1)) + minimum;

        // Scroll Up - use R1 now
        if (api.keys.isNextPage(event) && !event.isAutoRepeat) {
            event.accepted = true;
            lastR1PressedTimestamp = Date.now();
            //console.log("lastR1PressedTimestamp : ", lastR1PressedTimestamp);
            if(lastL1PressedTimestamp !== 0 && ((lastR1PressedTimestamp - lastL1PressedTimestamp) <= 100)){
                //press L1+R1 detected
                //console.log("press L1+R1 detected");
                //launch action here
                softwarelist.currentIndex = randomGame
                sfxToggle.play();
                gameActivated();
                //console.log("ramdom game selected");
                //reset timestamps
                lastR1PressedTimestamp = 0;
                lastL1PressedTimestamp = 0;
            }
            else{
                //launch potential navigation to next letter using timer now
                nextLetterDirection = +1
                navigateToNextLetterTimer.start();
            }
            return;
        }

        // Scroll Down - use L1 now
        if (api.keys.isPrevPage(event) && !event.isAutoRepeat) {
            event.accepted = true;
            lastL1PressedTimestamp = Date.now();
            //console.log("lastL1PressedTimestamp : ", lastL1PressedTimestamp);
            if(lastR1PressedTimestamp !== 0 && ((lastL1PressedTimestamp - lastR1PressedTimestamp) <= 100)){
                //press L1+R1 detected
                //console.log("press L1+R1 detected");
                //launch action here
                softwarelist.currentIndex = randomGame
                sfxToggle.play();
                gameActivated();
                //console.log("ramdom game selected");
                //reset timestamps
                lastR1PressedTimestamp = 0;
                lastL1PressedTimestamp = 0;
            }
            else{
                //launch potential navigation to previous letter using timer now
                nextLetterDirection = -1
                navigateToNextLetterTimer.start();
            }
            return;
        }

        // Next collection - R2 now
        if (api.keys.isPageDown(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if (isRightTriggerPressed) {
                return;
            }
            else isRightTriggerPressed = true;
            if (currentCollectionIndex < api.collections.count-1)
                currentCollectionIndex++;
            else
                currentCollectionIndex = 0;

            softwarelist.currentIndex = 0;
            //set currentgame also
            currentGameIndex = softwarelist.currentIndex;
            currentGame = list.currentGame(softwarelist.currentIndex)

            sfxToggle.play();

            // Reset our cached sorted games
            sortedGames = null;
            return;
        }

        // Previous collection - use L2 now
        if (api.keys.isPageUp(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if (isLeftTriggerPressed) {
                return;
            }
            else isLeftTriggerPressed = true;

            if (currentCollectionIndex > 0)
                currentCollectionIndex--;
            else
                currentCollectionIndex = api.collections.count-1;

            softwarelist.currentIndex = 0;
            //set currentgame also
            currentGameIndex = softwarelist.currentIndex;
            currentGame = list.currentGame(softwarelist.currentIndex)

            sfxToggle.play();

            // Reset our cached sorted games
            sortedGames = null;
            return;
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
        ListElement {
            name: qsTr("random game (L1+R1)")
            button: "random"
        }
    }
    
    onFocusChanged: {
        //console.log("SoftwareListMenu::onFocusChanged()");
        if (focus) currentHelpbarModel = verticalListHelpModel;
    }
}
