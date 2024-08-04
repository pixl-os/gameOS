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

import QtQuick 2.15
import QtQuick.Layouts 1.15
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

    function reloadProperties(){
        //console.log("reloadProperties()");
        loadPlatformPageSettings();
    }

    property real itemheight: vpx(50)
    property int skipnum: 10

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
        softwarelist.focus = true;
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
            //console.log("api.launchedgame : ",api.launchedgame);
            //console.log("appWindow.activeFocusItem : ", appWindow.activeFocusItem)
            if((api.launchedgame && !appWindow.activeFocusItem) || gameToLaunched){
                //console.log("api.launchedgame.path : ",api.launchedgame.path);
                //console.log("Block Keys.onDownPressed from header");
                return;
            }                
            sfxNav.play();
            softwarelist.focus = true;
            if((softwarelist.currentIndex < softwarelist.count) && (softwarelist.currentIndex >= 0)){
                //do nothing
            } else softwarelist.currentIndex = 0; //set index
        }
        Keys.onPressed: {
            //console.log("api.launchedgame : ",api.launchedgame);
            //console.log("appWindow.activeFocusItem : ", appWindow.activeFocusItem)
            if((api.launchedgame && !appWindow.activeFocusItem) || gameToLaunched){
                //console.log("api.launchedgame.path : ",api.launchedgame.path);
                //console.log("Block Keys.onUpPressed from header");
                return;
            }                
            // Accept
            if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                //RFU
            }
            // Back
            if (api.keys.isCancel(event) && !event.isAutoRepeat) {
                event.accepted = true;
                softwarelist.focus = true;
            }
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

        onCurrentIndexChanged: {
            //console.log("softwarelist::onCurrentIndexChanged - currentIndex",currentIndex);
            //console.log("softwarelist::onCurrentIndexChanged - headercontainer.focus",headercontainer.focus);
            //we read header "focus" status to restore it later if needed
            //console.log("----- onCurrentIndexChanged before -----");
            //console.log(" headercontainer.searchActive : ", headercontainer.searchActive);
            //console.log(" headercontainer.searchInput.focus : ", headercontainer.searchInput.focus);
            //console.log(" Qt.inputMethod.visible : ", Qt.inputMethod.visible);


            var headerStatus = headercontainer.focus;
            var searchInputStatus = headercontainer.searchInput.focus;
            var searchActiveStatus = headercontainer.searchInput.searchActive;

            if (currentIndex !== -1){
                currentGameIndex = currentIndex;
                currentGame = list.currentGame(softwarelist.currentIndex)
                if(headerStatus === true){
                    //we restore header "focus" status to avoid to focus vertical list during a search/filtering.
                    headercontainer.focus = true;
                }
                if(searchInputStatus === true){
                    //we restore header searchInput "focus" status to avoid to focus vertical list during a search/filtering.
                    headercontainer.searchInput.focus = true;
                }
                if(searchActiveStatus === true){
                    //we restore header searchActive state to keep cursor/edition during a search/filtering.
                    headercontainer.searchInput.searchActive = true;
                }
            }
            //console.log("----- onCurrentIndexChanged after -----");
            //console.log(" headercontainer.searchActive : ", headercontainer.searchActive);
            //console.log(" headercontainer.searchInput.focus : ", headercontainer.searchInput.focus);
            //console.log(" Qt.inputMethod.visible : ", Qt.inputMethod.visible);
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
                    visible: selected && !gameview.focus && !headercontainer.focus

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

                //for icons, we propose to centralize margin and size (calculated depending how many to display)
                property int nb_icons_to_display:  Number(modelData.favorite) + Number((typeof modelData.lightgungame !== "undefined") ? modelData.lightgungame : false) + Number(modelData.RaGameID > 0)
                property int horizontal_margin: nb_icons_to_display <= 2 ? vpx(height*0.0666): vpx(height*0.0333);
                property int vertical_margin: nb_icons_to_display <= 2 ? vpx(height*0.0666): vpx(height*0.0333);
                property int icon_size: nb_icons_to_display <= 2 ? height*0.4 : height*0.3;
                Rectangle {
                    id: favicon

                    anchors {
                        right: parent.right; rightMargin: horizontal_margin;
                        top: parent.top; topMargin: visible ? vertical_margin : vpx(0);
                    }
                    width: visible ? icon_size : vpx(0)
                    height: width
                    radius: width/2
                    color: theme.accent
                    visible: modelData.favorite
                    Image {
                        source: "../assets/images/favicon.svg"
                        asynchronous: true
                        anchors.fill: parent
                        anchors.margins: parent.width / 6
                    }
                }

                Rectangle {
                    id: raicon

                    anchors {
                        right: parent.right; rightMargin: horizontal_margin;
                        top: favicon.bottom; topMargin: visible ? vertical_margin : vpx(0);
                    }
                    width: visible ? icon_size : vpx(0)
                    height: width
                    radius: width/2
                    color: theme.accent
                    visible: (modelData.RaGameID > 0) ? true : false
                    Image {
                        source: "../assets/images/icon_cup.svg"
                        asynchronous: true
                        anchors.fill: parent
                        anchors.margins: parent.width / 6
                        property bool isDestroyed
                        onStatusChanged:{
                            if (Image.Ready && modelData){
                                ra_timer.restart();
                                isDestroyed = false;
                            }
                        }
                        Component.onCompleted: {
                            //console.log("SoftwareListMenu raicon Completed")
                        }
                        Component.onDestruction: {
                            //console.log("SoftwareListMenu racon Destroyed")
                            isDestroyed = true;
                        }
                        Timer {
                            id: ra_timer
                            interval: 1000
                            running: false
                            triggeredOnStart: false
                            repeat: false
                            onTriggered: {
                                //console.log("parent.isDestroyed : ", parent.isDestroyed);
                                 if (modelData){
                                    /*var path = modelData.files.get(0).path;
                                    var word = path.split('/');
                                    console.log("collection : " + modelData.collections.get(0).shortName)
                                    console.log("game : " + modelData.title)
                                    console.log("rom : " + word[word.length-1])*/
                                    if(!Image.isDestroyed){
                                        modelData.checkRetroAchievements();
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: lighgunicon

                    anchors {
                        right: parent.right; rightMargin: horizontal_margin;
                        top: raicon.bottom; topMargin: visible ? vertical_margin : vpx(0);
                    }
                    width: visible ? icon_size : vpx(0)
                    height: width
                    radius: width/2
                    color: theme.accent
                    visible: (typeof modelData.lightgungame !== "undefined") ? modelData.lightgungame : false;
                    Image {
                        source: "../assets/images/icon_zapper.svg"
                        asynchronous: true
                        anchors.fill: parent
                        anchors.margins: parent.width / 6
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
        //console.log("api.launchedgame : ",api.launchedgame);
        //console.log("appWindow.activeFocusItem : ", appWindow.activeFocusItem)
        if((api.launchedgame && !appWindow.activeFocusItem) || gameToLaunched){
            //console.log("api.launchedgame.path : ",api.launchedgame.path);
            //console.log("Block Keys.onUpPressed");
            return;
        }        
        if (softwarelist.currentIndex != 0)
            softwarelist.currentIndex--;
        else
            softwarelist.currentIndex = softwarelist.count - 1
        softwarelist.focus = true;
    }
    // Down
    Keys.onDownPressed: {
        //console.log("api.launchedgame : ",api.launchedgame);
        //console.log("appWindow.activeFocusItem : ", appWindow.activeFocusItem)
        if((api.launchedgame && !appWindow.activeFocusItem) || gameToLaunched){
            //console.log("api.launchedgame.path : ",api.launchedgame.path);
            //console.log("Block Keys.onDownPressed");
            return;
        }        
        if (softwarelist.currentIndex != softwarelist.count - 1)
            softwarelist.currentIndex++;
        else
            softwarelist.currentIndex = 0;
        softwarelist.focus = true;
    }
    // Left
    Keys.onLeftPressed: {
        //console.log("api.launchedgame : ",api.launchedgame);
        //console.log("appWindow.activeFocusItem : ", appWindow.activeFocusItem)
        if((api.launchedgame && !appWindow.activeFocusItem) || gameToLaunched){
            //console.log("api.launchedgame.path : ",api.launchedgame.path);
            //console.log("Block Keys.onLeftPressed");
            return;
        }            
        /*if (softwarelist.currentIndex > skipnum)
            softwarelist.currentIndex = softwarelist.currentIndex - skipnum;
        else
            softwarelist.currentIndex = 0;*/
    }
    // Right
    Keys.onRightPressed:  {
        //console.log("api.launchedgame : ",api.launchedgame);
        //console.log("appWindow.activeFocusItem : ", appWindow.activeFocusItem)
        if((api.launchedgame && !appWindow.activeFocusItem) || gameToLaunched){
            //console.log("api.launchedgame.path : ",api.launchedgame.path);
            //console.log("Block Keys.onRightPressed");
            return;
        }        
        /*if (softwarelist.currentIndex < softwarelist.count - skipnum)
            softwarelist.currentIndex = softwarelist.currentIndex + skipnum;
        else
            softwarelist.currentIndex = softwarelist.count - 1*/
        gameActivated();
        softwarelist.focus = false;
        gameview.focus = true;
    }

    Keys.onReleased: {
        //console.log("api.launchedgame : ",api.launchedgame);
        //console.log("appWindow.activeFocusItem : ", appWindow.activeFocusItem)
        if((api.launchedgame && !appWindow.activeFocusItem) || gameToLaunched){
            //console.log("api.launchedgame.path : ",api.launchedgame.path);
            event.accepted = true;
            //console.log("Block Keys.onReleased on SoftwareListMenu");
            return;
        }
        // Guide
        if (api.keys.isGuide(event) && !event.isAutoRepeat) {
            hotkeyPressed = false;
            event.accepted = true;
        }
        //to ignore keys if hotkey still pressed
        if(hotkeyPressed) return;
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
            reloadProperties();
            return;
        }
        // Previous collection - L2 now
        if (api.keys.isPageUp(event) && !event.isAutoRepeat) {
            event.accepted = true;
            api.internal.system.run("sleep 0.2"); //ad sleep to avoid multievents
            isLeftTriggerPressed = false;
            reloadProperties();
            return;
        }
    }

    //Random Game
    property int maximum: softwarelist.count
    property int minimum: 0

    Keys.onPressed: {
        //console.log("api.launchedgame : ",api.launchedgame);
        //console.log("appWindow.activeFocusItem : ", appWindow.activeFocusItem)
        if((api.launchedgame && !appWindow.activeFocusItem) || gameToLaunched){
            //console.log("api.launchedgame.path : ",api.launchedgame.path);
            event.accepted = true;
            //console.log("Block Keys.onPressed on SoftwareListMenu");
            return;
        }
        //to ignore keys if hotkey still pressed
        if(hotkeyPressed) return;        
        // Guide
        if (api.keys.isGuide(event) && !event.isAutoRepeat) {
            hotkeyPressed = true;
            event.accepted = true;
        }        
        // Accept
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if (!gameview.focus) {
                gameActivated();
                gameToLaunched = true;
                softwarelist.focus = false;
                gameview.focus = true;
            }
        }
        // Back
        if (api.keys.isCancel(event) && !event.isAutoRepeat) {
            event.accepted = true;
            gameActivated();
            previousScreen();
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
            //console.log("Toggle favorite");
            event.accepted = true;
            sfxToggle.play();
            list.currentGame(softwarelist.currentIndex).favorite = !list.currentGame(softwarelist.currentIndex).favorite;
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
        
    onActiveFocusChanged:
    {
        //console.log("onActiveFocusChanged : ", activeFocus);
        if (activeFocus){
            currentHelpbarModel = ""; // to force reload for transkation
            currentHelpbarModel = verticalListHelpModel;
            reloadProperties();
        }
    }
}
