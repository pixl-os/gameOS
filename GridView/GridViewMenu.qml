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

import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12
import "../Global"
import "../Lists"
import "../utils.js" as Utils

FocusScope {
    id: root
    // While not necessary to do it here, this means we don't need to change it in both
    // touch and gamepad functions each time
    function gameActivated() {
        //console.log("list.currentGame(gamegrid.currentIndex) : ",list.currentGame(gamegrid.currentIndex));
        //check added when search is empty and we try to launch a game in all cases
        if(list.currentGame(gamegrid.currentIndex) !== null){
            storedCollectionGameIndex = gamegrid.currentIndex
            gameDetails(list.currentGame(gamegrid.currentIndex));
        }
    }

    property var sortedGames: null;
    property bool isLeftTriggerPressed: false;
    property bool isRightTriggerPressed: false;
    property bool hotkeyPressed: false;

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

        var currentIndex = gamegrid.currentIndex;
        if (currentIndex === -1) {
            gamegrid.currentIndex = 0;
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

            gamegrid.currentIndex = nextIndex;

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

        gamegrid.focus = true;
        sfxToggle.play();

        return true;
    }

    ListCollectionGames { id: list; }

    // Load settings
    property bool showBoxes: settings.GridThumbnail === "Box Art"
    property int numColumns: settings.GridColumns ? settings.GridColumns : 6
    property int titleMargin: settings.AlwaysShowTitles === "Yes" ? vpx(30) : 0

    GridSpacer {
        id: fakebox

        width: vpx(100); height: vpx(100)
        games: list.games
    }

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

    Rectangle {
        id: header

        anchors {
            top:    parent.top
            left:   parent.left
            right:  parent.right
        }
        height: vpx(75)
        color: theme.main
        z: 5

        HeaderBar {
            id: headercontainer

            anchors.fill: parent
        }
        Keys.onDownPressed: {
            sfxNav.play();
            gamegrid.focus = true;
            if(storedCollectionGameIndex < gamegrid.count){
                gamegrid.currentIndex = storedCollectionGameIndex;
            } else gamegrid.currentIndex = 0; //set index
        }
    }

    Item {
        id: gridContainer

        anchors {
            top: header.bottom; topMargin: globalMargin
            left: parent.left; leftMargin: globalMargin
            right: parent.right; rightMargin: globalMargin
            bottom: parent.bottom; bottomMargin: globalMargin
        }

        GridView {
            id: gamegrid

            // Figuring out the aspect ratio for box art
            property real cellHeightRatio: fakebox.paintedHeight / fakebox.paintedWidth
            property real savedCellHeight: {
                if (settings.GridThumbnail === "Tall") {
                    return cellWidth / settings.TallRatio;
                } else if (settings.GridThumbnail === "Square") {
                    return cellWidth;
                } else {
                    return cellWidth * settings.WideRatio;
                }
            }
            property var sourceThumbnail: showBoxes ? "BoxArtGridItem.qml" : "../Global/DynamicGridItem.qml"

            Component.onCompleted: {
                currentIndex = storedCollectionGameIndex;
                positionViewAtIndex(currentIndex, ListView.Visible);
            }

            populate: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
            }

            anchors {
                top: parent.top; left: parent.left; right: parent.right;
                bottom: parent.bottom; bottomMargin: helpMargin + vpx(40)
            }
            cellWidth: width / numColumns
            cellHeight: ((showBoxes) ? cellWidth * cellHeightRatio : savedCellHeight) + titleMargin
            preferredHighlightBegin: vpx(0)
            preferredHighlightEnd: gamegrid.height - helpMargin - vpx(40)
            highlightRangeMode: GridView.ApplyRange
            highlightMoveDuration: 200
            highlight: highlightcomponent
            keyNavigationWraps: false
            displayMarginBeginning: cellHeight * 2
            displayMarginEnd: cellHeight * 2

            model: list.games
            delegate: (showBoxes) ? boxartdelegate : dynamicDelegate

            Component {
                id: boxartdelegate

                BoxArtGridItem {
                    selected: GridView.isCurrentItem && root.focus
                    gameData: modelData

                    width:      GridView.view.cellWidth
                    height:     GridView.view.cellHeight - titleMargin
                    
                    onActivate: {
                        if (selected)
                            gameActivated();
                        else
                            gamegrid.currentIndex = index;
                    }
                    onHighlighted: {
                        gamegrid.currentIndex = index;
                    }
                    Keys.onPressed: {
                        // Toggle favorite
                        if (api.keys.isDetails(event) && !event.isAutoRepeat) {
                            event.accepted = true;
                            sfxToggle.play();
                            modelData.favorite = !modelData.favorite;
                        }
                    }
                }
            }

            Component {
                id: dynamicDelegate

                DynamicGridItem {
                    id: dynamicdelegatecontainer

                    selected: GridView.isCurrentItem && root.focus

                    width:      GridView.view.cellWidth
                    height:     GridView.view.cellHeight - titleMargin
                    
                    onActivated: {
                        if (selected)
                            gameActivated();
                        else
                            gamegrid.currentIndex = index;
                    }
                    onHighlighted: {
                        gamegrid.currentIndex = index;
                    }
                    Keys.onPressed: {
                        // Toggle favorite
                        if (api.keys.isDetails(event) && !event.isAutoRepeat) {
                            event.accepted = true;
                            sfxToggle.play();
                            modelData.favorite = !modelData.favorite;
                        }
                    }
                }
            }

            Component {
                id: highlightcomponent

                ItemHighlight {
                    width: gamegrid.cellWidth
                    height: gamegrid.cellHeight
                    game: list.currentGame(gamegrid.currentIndex)
                    selected: gamegrid.focus
                    boxArt: showBoxes
                }
            }

            // Manually set the navigation this way so audio can play without performance hits
            Keys.onUpPressed: {
                sfxNav.play();
                if (currentIndex < numColumns) {
                    headercontainer.focus = true;
                    storedCollectionGameIndex = gamegrid.currentIndex;
                    gamegrid.currentIndex = -1;
                } else {
                    moveCurrentIndexUp();
                }
            }
            Keys.onDownPressed:     { sfxNav.play(); moveCurrentIndexDown() }
            Keys.onLeftPressed:     { sfxNav.play(); moveCurrentIndexLeft() }
            Keys.onRightPressed:    { sfxNav.play(); moveCurrentIndexRight() }
        }
    }

    Keys.onReleased: {
        //console.log("GridViewMenu Keys.onReleased");
        // Guide
        if (api.keys.isGuide(event) && !event.isAutoRepeat) {
            hotkeyPressed = false;
            event.accepted = true;
        }
        //to ignore keys if hotkey still pressed
        if(hotkeyPressed === true) return;
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
    property int maximum: gamegrid.count
    property int minimum: 0

    Keys.onPressed: {
        //console.log("GridViewMenu Keys.onPressed");
        //to ignore keys if hotkey still pressed
        if(hotkeyPressed === true) return;
        // Guide
        if (api.keys.isGuide(event) && !event.isAutoRepeat) {
            hotkeyPressed = true;
            event.accepted = true;
        }
        // Accept
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if (gamegrid.focus) {
                gameActivated();
            } else {
                gamegrid.currentIndex = 0;
                gamegrid.focus = true;
            }
            return;
        }
        // Back
        if (api.keys.isCancel(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if (gamegrid.focus) {
                storedCollectionGameIndex = gamegrid.currentIndex;
                previousScreen();
            } else {
                //what provide focus on back ?!
                gamegrid.currentIndex = storedCollectionGameIndex;
                gamegrid.focus = true;
            }
            return;
        }
        // Details
        if (api.keys.isFilters(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if(gamegrid.currentIndex !== -1){
                sfxToggle.play();
                gamegrid.focus = false;
                headercontainer.focus = true;
                storedCollectionGameIndex = gamegrid.currentIndex;
                gamegrid.currentIndex = -1;
            }
            return;
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
                gamegrid.currentIndex = randomGame
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
                gamegrid.currentIndex = randomGame
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

            gamegrid.currentIndex = 0;
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

            gamegrid.currentIndex = 0;
            sfxToggle.play();

            // Reset our cached sorted games
            sortedGames = null;
            return;
        }
    }

    // Helpbar buttons
    ListModel {
        id: gridviewHelpModel

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
            name: qsTr("View details")
            button: "accept"
        }
        ListElement {
          name: qsTr("random game (L1+R1)")
          button: "random"
        }
    }

    onFocusChanged: {
        if (focus) {
            currentHelpbarModel = gridviewHelpModel;
            gamegrid.focus = true;
        }
    }

    onActiveFocusChanged:
    {
        //console.log("onActiveFocusChanged : ", activeFocus);
        if (activeFocus){
            currentHelpbarModel = ""; // to force reload for transkation
            currentHelpbarModel = gridviewHelpModel;
        }
    }
}
