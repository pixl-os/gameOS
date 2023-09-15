// gameOS theme
// created by BozoTheGeek 11/09/2023 to manage "screenshots" in this theme
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import SortFilterProxyModel 0.2
import QtQml.Models 2.15
import QtMultimedia 5.15
import "qrc:/qmlutils" as PegasusUtils
import "../utils.js" as Utils
import "../Global"
import "../GridView"
import "../Lists"
import "../Search"

FocusScope {
    id: root

    property var game: api.allGames.get(0)
    property bool embedded : false
    property bool readyForNeplay: isReadyForNetplay(game)
    property string favIcon: game && game.favorite ? "../assets/images/icon_unheart.svg" : "../assets/images/icon_heart.svg"
    property string collectionName: game ? game.collections.get(0).name : ""
    property string collectionShortName: game ? game.collections.get(0).shortName : ""
    property bool iamsteam: game ? (collectionShortName === "steam") : false
    property bool canPlayVideo: ((settings.VideoPreview === "Yes") && (appWindow.activeFocusItem !== null)) ? true : false
    property bool hotkeyPressed: false;
    
    //clipping activated especially for embedded mode
    clip: embedded

    property real detailsOpacity: ((settings.DetailsDefault === "Yes") && (demoLaunched !== true)) || ((settings.DemoShowFullDetails === "Yes") && (demoLaunched === true)) ? 1 : 0

    //function used by mediaArray() to add only new assets in mediaList
    function addNewAssetOnly(asset,mediaList){
        asset.forEach(function(v){
            const found = mediaList.indexOf(v);
            if(found === -1) mediaList.push(v);
        });
    }

/*     // Combine the video and the screenshot arrays into one
    function mediaArray() {
        let mediaList = [];
        //To add other assets as visible in media list if possible (verify to avoid dooblons display also)
        if (game) {
            addNewAssetOnly(game.assets.videoList,mediaList);
            addNewAssetOnly(game.assets.manualList,mediaList);
            addNewAssetOnly(game.assets.marqueeList,mediaList);
            addNewAssetOnly(game.assets.bezelList,mediaList);
            addNewAssetOnly(game.assets.cartridgeList,mediaList);
            addNewAssetOnly(game.assets.boxFrontList,mediaList);
            addNewAssetOnly(game.assets.boxBackList,mediaList);
            addNewAssetOnly(game.assets.boxFullList,mediaList);
            addNewAssetOnly(game.assets.boxSpineList,mediaList);
            addNewAssetOnly(game.assets.logoList,mediaList);
            addNewAssetOnly(game.assets.backgroundList,mediaList);
            addNewAssetOnly(game.assets.titlescreenList,mediaList);
            addNewAssetOnly(game.assets.mapsList,mediaList);
            addNewAssetOnly(game.assets.musicList,mediaList);
        }
        return mediaList;
    } */

    // Reset the screen to default state
    function reset(){
        content.currentIndex = 0;
        menu.currentIndex = 0;
        //media.savedIndex = 0;
        //list1.savedIndex = 0;
        //list2.savedIndex = 0;
        screenshot.opacity = 1;
        //mediaScreen.opacity = 0;
        if(!embedded){
        }
        else{
            //to be sure to stop video in all cases -> improve really performance of scrolling !!!
            fadescreenshot.stop();
            //to avoid issue with retroachievements loading
            root.focus = false;
            root.parent.focus = true;
        }

    }

    // Show/hide the details overlay
    function showDetails() {
        if (detailsOpacity === 1) {
            detailsOpacity = 0;
        }
        else {
            detailsOpacity = 1;
            content.focus = true;
        }
    }

    // Show/hide the media view
    function showMedia(index) {
        sfxAccept.play();
        mediaScreen.mediaIndex = index;
        mediaScreen.focus = true;
        mediaScreen.opacity = 1;
    }

    function closeMedia() {
        sfxBack.play();
        mediaScreen.opacity = 0;
        content.focus = true;
        currentHelpbarModel = gameviewHelpModel;
    }

    onGameChanged: {
        //console.log("GameView - onGameChanged");
        //reset default value for a new game loading
        reset();
    }

    anchors.fill: parent

    // NOTE: Next fade out the bg so there is a smooth transition into the video
    Timer {
        id: fadescreenshot
        running: false
        triggeredOnStart: false
        repeat: false
        interval: 1000
        onTriggered: {
            screenshot.opacity = 0;
            if (blurBG)
                blurBG.opacity = 0;
        }
    }

    Rectangle{
        id:background
        anchors.fill: parent
        opacity: screenshot.opacity

        // Background (screenshot and/or fanart)
        Image {
            id: screenshot

            height: parent.height
            width: parent.width

            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.verticalCenter:parent.verticalCenter

            asynchronous: true
            property var actualBackground:{
                console.log("game.files.get(0).path : ", game.files.get(0).path);
                return game.files.get(0).path;
            }
            source: actualBackground || ""

            fillMode: Image.PreserveAspectCrop
            smooth: true
            Behavior on opacity { NumberAnimation { duration: 500 } }
            visible: true
        }
    }

    // Gradient
    LinearGradient {
        id: bggradient
        visible: (demoLaunched !== true)
        width: parent.width
        height: parent.height/2
        start: Qt.point(0, 0)
        end: Qt.point(0, height*1.50) //updated to reduce gradient effect on background screenshot/fanart or video
        gradient: Gradient {
            GradientStop { position: 0.0; color: theme.gradientstart }
            GradientStop { position: 0.7; color: theme.gradientend }
        }
        y: (content.currentIndex == 0) ? height : -height
        Behavior on y { NumberAnimation { duration: 200 } }
    }

    Rectangle {
        id: overlay

        color: theme.gradientend
        anchors {
            left: parent.left; right: parent.right
            top: bggradient.bottom; bottom: parent.bottom
        }
    }

    // Details screen
    Item {
        id: detailsScreen

        anchors.fill: parent
        visible: opacity !== 0
        opacity: (content.currentIndex !== 0) ? 0 : detailsOpacity
        Behavior on opacity { NumberAnimation { duration: 200 } }

        Rectangle {
            anchors.fill: parent
            color: theme.main
            opacity: 0.7
        }

        Item {
            id: details

            anchors {
                top: parent.top; topMargin: parent.height * (parseFloat("15%")/100) //vpx(100)
                left: parent.left; leftMargin: parent.width * (parseFloat("3%")/100) //vpx(70)
                right: parent.right; rightMargin: parent.width * (parseFloat("3%")/100) //vpx(70)
            }
            height: (parent.height * (parseFloat("70%")/100)) - header.height //vpx(450)

/*             Image {
                id: boxart

                source: Utils.boxArt(game);
                width: embedded ? (parent.width * (parseFloat("25%")/100)) : (parent.width * (parseFloat("30%")/100))
                height: parent.height * (parseFloat("95%")/100)
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                smooth: true
            } */

            FileInfo {
                id: info
                anchors {
                    left: parent.left; leftMargin: parent.width * (parseFloat("3%")/100); //vpx(30)
                    right: parent.right;
                    top: parent.top; bottom: parent.bottom;
                }
            }
        }
    }

    // Header
    Item {
        id: header

        anchors {
            left: parent.left;
            right: parent.right
        }
        height: vpx(75)

        // Platform logo
        Image {
            id: logobg

            anchors.fill: platformlogo
            source: "../assets/images/gradient.png"
            asynchronous: true
            visible: false
        }

        Image {
            id: platformlogo

            anchors {
                top: parent.top; topMargin: vpx(10)
                bottom: parent.bottom; bottomMargin: vpx(10)
                left:{
                    if (settings.SystemLogoPosition === "Left") return parent.left;
                }
                leftMargin: (settings.SystemLogoPosition === "Left") ? globalMargin : 0
                right:{
                    if (settings.SystemLogoPosition === "Right") return parent.right;
                }
                rightMargin: (settings.SystemLogoPosition === "Right") ? globalMargin : 0
            }
            fillMode: Image.PreserveAspectFit
            source: {
                if(settings.SystemLogoStyle === "White")
                {
                    return "../assets/images/logospng/" + Utils.processPlatformName(game.collections.get(0).shortName) + ".png";
                }
                else
                {
                    return "../assets/images/logospng/" + Utils.processPlatformName(game.collections.get(0).shortName) + "_" + settings.SystemLogoStyle.toLowerCase() + ".png";
                }
            }
            // sourceSize: vpx(25)
            smooth: true
            visible: ((settings.SystemLogo === "Show") || ((settings.SystemLogo === "Show if no overlay") && (overlay_exists !== true))) ? true : false
            asynchronous: true
        }

        OpacityMask {
            anchors.fill: logobg
            source: logobg
            maskSource: platformlogo
            visible: settings.SystemLogoGradientEffect === "Yes" ? true : false
        }

        // Mouse/touch functionality
        MouseArea {
            anchors.fill: parent
            hoverEnabled: settings.MouseHover === "Yes"
            onClicked: previousScreen();
        }


        // Platform title
        Text {
            id: softwareplatformtitle

            text: game.collections.get(0).name

            anchors {
                top:    parent.top;
                left:   parent.left;    leftMargin: globalMargin
                right:  parent.right
                bottom: parent.bottom
            }

            color: theme.text
            font.family: titleFont.name
            font.pixelSize: vpx(30)
            font.bold: true
            horizontalAlignment: Text.AlignHLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            visible: platformlogo.status == Image.Error

            // Mouse/touch functionality
            MouseArea {
                anchors.fill: parent
                hoverEnabled: settings.MouseHover === "Yes"
                onClicked: previousScreen();
            }
        }
        z: 10
    }

    // Game menu
    ObjectModel {
        id: menuModel

/*         Button {
            id: button1

            text: qsTr("Launch viewer") + api.tr
            height: parent.height
            selected: (demoLaunched !== true) && ListView.isCurrentItem && menu.focus && (root.embedded ? root.focus : true)
            onHighlighted: { menu.currentIndex = ObjectModel.index; content.currentIndex = 0; }
            property var launchedGame: api.launchedgame
            property var selectedGame : game
            property bool canLoadSpinner: (appWindow.activeFocusItem !== null) ? true : false

            //Done to avoid spinner running during gaming ;-)
            onCanLoadSpinnerChanged:{
                if (launchedGame) {
                    if (api.launchedgame.path === game.path){
                        //if can't Load Spinner
                        if(!canLoadSpinner){
                            //stop  animation (existing or not)
                            iconRotation.stop();
                        }
                        else {
                            //restart or start animation
                            icon = "../assets/images/loading.png";
                            //start animation without end
                            iconRotation.loops = Animation.Infinite;
                            iconRotation.start();
                        }
                    }
                }
            }

            onSelectedGameChanged: {
                //console.log("onSelectedGameChanged");
                if (launchedGame) {
                    if (api.launchedgame.path === game.path){
                        icon = "../assets/images/loading.png";
                        //start animation without end
                        iconRotation.loops = Animation.Infinite;
                        iconRotation.start();
                    }
                    else{
                        //if animation is running
                        if(iconRotation.running === true){
                            //stop existing animation
                            iconRotation.stop();
                            //limit to one cycle
                            iconRotation.loops = 1;
                            //restart animation
                            iconRotation.start();
                        }
                        else icon = "../assets/images/icon_play.svg";
                    }
                }
                else icon = "../assets/images/icon_play.svg";
            }
            iconRotation.onStarted: {
                    //console.log("iconRotation.onStarted");
                    icon = "../assets/images/loading.png";
            }

            iconRotation.onFinished:{
                    //console.log("iconRotation.onFinished");
                    //if finish and during the last cycle
                    if (iconRotation.loops === 1) icon = "../assets/images/icon_play.svg";
            }

            onLaunchedGameChanged: {
                //if game is launched
                if(launchedGame){
                    //if launched game is the selected game of gameview
                    if((launchedGame.path === selectedGame.path) && (!iconRotation.running)){
                        //start animation without end
                        iconRotation.loops = Animation.Infinite;
                        iconRotation.start();
                    }
                    else{
                        //if animation is running
                        if(iconRotation.running === true){
                            //stop existing animation
                            iconRotation.stop();
                            //limit to one cycle
                            iconRotation.loops = 30;
                            //restart animation
                            iconRotation.start();
                        }
                    }
                }
                else{
                    //if animation is running
                    if(iconRotation.running === true){
                        //stop existing animation
                        iconRotation.stop();
                        //limit to one cycle
                        iconRotation.loops = 1;
                        //restart animation
                        iconRotation.start();
                    }
                }
            }
            
            Timer {
                id: launchGameDelay
                running: false
                triggeredOnStart: false
                repeat: false
                interval: 500
                onTriggered: {
                    launchGame(game);
                }
            }

            onActivated:
                if (selected) {
                    //if game not already launched
                    if(!launchedGame){
                        sfxAccept.play();
                        if(api.internal.recalbox.getBoolParameter("pegasus.multiwindows") || api.internal.recalbox.getBoolParameter("pegasus.theme.keeploaded")){
                            //to launch animation at launch
                            icon = "../assets/images/loading.png";
                            //start animation without end
                            iconRotation.loops = 30;
                            iconRotation.start();
                        }
                        //force gameToLaunched flag also in this case
                        gameToLaunched = true;
                        launchGameDelay.start();
                    }
                }
                else {
                    sfxNav.play();
                    menu.currentIndex = ObjectModel.index;
                }
        }
 */
        Button {
            id: button2

            icon: "../assets/images/icon_details.svg"
            height: parent.height
            selected: ListView.isCurrentItem && menu.focus && (root.embedded ? root.focus : true)
            onHighlighted: { menu.currentIndex = ObjectModel.index; content.currentIndex = 0; }
            onActivated:
                if (selected) {
                    sfxToggle.play();
                    showDetails();
                } else {
                    sfxNav.play();
                    menu.currentIndex = ObjectModel.index;
                }
        }

        Button {
            id: button4

            //text: "Back"
            icon: "../assets/images/icon_back.svg"
            height: parent.height
            selected: ListView.isCurrentItem && menu.focus && (root.embedded ? root.focus : true)
            onHighlighted: { menu.currentIndex = ObjectModel.index; content.currentIndex = 0; }
            onActivated:
                if (selected) {
                    //to let video to run if needed
                    videoToStop = false;
                    if(embedded) {
/*                         if (retroachievementsOpacity === 1) {
                            detailsOpacity = 1;
                            retroachievementsOpacity = 0;
                            achievements.selected = false;
                            content.focus = true;
                        } */
                        root.focus = false;
                        root.parent.focus = true;
                    }
                    else previousScreen();
                }
                else {
                    sfxNav.play(); 
                    menu.currentIndex = ObjectModel.index;
                }
        }

    }

    // Full list
    ObjectModel {
        id: extrasModel

        // Game menu
        ListView {
            id: menu
            visible: (demoLaunched !== true)
            property bool selected: root.focus
            focus: selected
			width: root.width
            height: vpx(root.height * (parseFloat("9%")/100))
			model: menuModel
            orientation: ListView.Horizontal
            spacing: vpx(10)
            keyNavigationWraps: true
            Keys.onLeftPressed: { 
                                    //console.log("api.launchedgame : ",api.launchedgame);
                                    //console.log("appWindow.activeFocusItem : ", appWindow.activeFocusItem)
                                    //console.log("gameToLaunched : ", gameToLaunched)
                                    if((api.launchedgame && !appWindow.activeFocusItem) || gameToLaunched){
                                        //console.log("api.launchedgame.path : ",api.launchedgame.path);
                                        //console.log("Block Keys.onLeftPressed on ListView(menu) of GameView");
                                        return;
                                    }
                                    //if embedded and if we do left to come back to list
                                    if (root.embedded ? !root.parent.focus : false){
                                        if(currentIndex === 0){
                                            // if (retroachievementsOpacity === 1) {
                                                // detailsOpacity = 1;
                                                // retroachievementsOpacity = 0;
                                                // achievements.selected = false;
                                                // content.focus = true;
                                            // }
                                            root.focus = false;
                                            root.parent.focus = true;
                                        }
                                    }

                                    //console.log("Menu - Keys.onLeftPressed");
                                    sfxNav.play(); 
                                    do{    
                                        decrementCurrentIndex();
                                    }while(!currentItem.enabled);                                
                                }
            Keys.onRightPressed:{ 
                                    //console.log("api.launchedgame : ",api.launchedgame);
                                    //console.log("appWindow.activeFocusItem : ", appWindow.activeFocusItem)
                                    //console.log("gameToLaunched : ", gameToLaunched)
/*                                     if((api.launchedgame && !appWindow.activeFocusItem) || gameToLaunched){
                                        //console.log("api.launchedgame.path : ",api.launchedgame.path);
                                        //console.log("Block Keys.onRightPressed on ListView(menu) of GameView");
                                        return;
                                    } */
                                    //console.log("Menu - Keys.onLeftPressed");
                                    sfxNav.play(); 
                                    do{    
                                        incrementCurrentIndex();
                                    }while(!currentItem.enabled);
                                }
        }
    }

    ListView {
        id: content

        anchors {
            left: parent.left; leftMargin: vpx(70)
            right: parent.right
            top: parent.top
            topMargin: content.currentIndex === 0 ? (details.height + header.height) + vpx(root.height * (parseFloat("8%")/100)) : header.height
            bottom: parent.bottom; bottomMargin: + vpx(root.height * (parseFloat("6%")/100))
        }
        model: extrasModel
        focus: true
        spacing: vpx(30)
        snapMode: ListView.SnapToItem
        highlightMoveDuration: 100
        displayMarginEnd: 150
        cacheBuffer: 250
        keyNavigationWraps: true
        Keys.onUpPressed: { 
                            //console.log("api.launchedgame : ",api.launchedgame);
                            //console.log("appWindow.activeFocusItem : ", appWindow.activeFocusItem)
                            if((api.launchedgame && !appWindow.activeFocusItem) || gameToLaunched){
                                //console.log("api.launchedgame.path : ",api.launchedgame.path);
                                //console.log("Block Keys.onUpPressed on ListView(content) of GameView");
                                return;
                            }
                            sfxNav.play(); 
                            if(currentIndex !== 0)    
                            {
                                decrementCurrentIndex();
                            }
                          }
        Keys.onDownPressed: { 
                            //console.log("api.launchedgame : ",api.launchedgame);
                            //console.log("appWindow.activeFocusItem : ", appWindow.activeFocusItem)
                            if((api.launchedgame && !appWindow.activeFocusItem) || gameToLaunched){
                                //console.log("api.launchedgame.path : ",api.launchedgame.path);
                                //console.log("Block Keys.onDownPressed on ListView(content) of GameView");
                                return;
                            }
                          sfxNav.play();
                          incrementCurrentIndex() 
        }
    }

/*     MediaView {
        id: mediaScreen

        anchors.fill: parent
        Behavior on opacity { NumberAnimation { duration: 100 } }
		opacity: 0
        visible: opacity !== 0

        mediaModel: mediaArray();
        mediaIndex: media.currentIndex !== -1 ? media.currentIndex : 0
        onClose: closeMedia();
    } */
    Keys.onReleased: {
        //console.log("Keys.onReleased::hotkeyPressed : ", hotkeyPressed);
        // Guide
        if (api.keys.isGuide(event) && !event.isAutoRepeat) {
            hotkeyPressed = false;
            event.accepted = true;
            return;
        }
        //to ignore keys if hotkey still pressed
        if(hotkeyPressed === true) return;
    }
    // Input handling
    Keys.onPressed: {
        //console.log("api.launchedgame : ",api.launchedgame);
        //console.log("appWindow.activeFocusItem : ", appWindow.activeFocusItem)
        //console.log("Keys.onPressed::hotkeyPressed : ", hotkeyPressed);
/*         if((api.launchedgame && !appWindow.activeFocusItem) || gameToLaunched){
            //console.log("api.launchedgame.path : ",api.launchedgame.path);
            event.accepted = true;
            //console.log("Block Keys.onPressed on GameView");
            return;
        } */
        //to ignore keys if hotkey still pressed
        if(hotkeyPressed === true) return;
        // Guide
        if (api.keys.isGuide(event) && !event.isAutoRepeat) {
            hotkeyPressed = true;
            event.accepted = true;
            return;
        }            
        // Back
        if (api.keys.isCancel(event) && !event.isAutoRepeat) {
            event.accepted = true;
            //to let video to run if needed
            videoToStop = false;
            if(embedded){
/*                 if (retroachievementsOpacity === 1) {
                    detailsOpacity = 1;
                    retroachievementsOpacity = 0;
                    achievements.selected = false;
                    content.focus = true;
                } */
                root.focus = false;
                root.parent.focus = true;
            }
            else{
/*                 if (mediaScreen.visible)
                    closeMedia();
                else */
                previousScreen();
            }
        }
/*         // Toggle Favorite
        if (api.keys.isDetails(event) && !event.isAutoRepeat) {
            event.accepted = true;
            sfxAccept.play();
            game.favorite = !game.favorite;
        } */

        // Launch Netplay
/*         if (api.keys.isFilters(event) && !event.isAutoRepeat) {
            event.accepted = true;
            sfxToggle.play();
            if(readyForNeplay){
                //to force focus & reload dialog
                netplayRoomDialog.focus = false;
                netplayRoomDialog.active = false;
                netplayRoomDialog.game = game; //set game
                netplayRoomDialog.active = true;
                netplayRoomDialog.focus = true;
            }
        }
 */
        if(!embedded){
        // Next game
        if (api.keys.isNextPage(event) && !event.isAutoRepeat && !global.guideButtonPressed) {
            event.accepted = true;
            sfxToggle.play();
            if (currentGameIndex < game.collections.get(0).games.count-1)
                currentGameIndex++;
            else
                currentGameIndex = 0;
            gameDetails(game.collections.get(0).games.get(currentGameIndex));
            lastState[lastState.length-1] = "showcasescreen";
        }

        // Previous game
        if (api.keys.isPrevPage(event) && !event.isAutoRepeat && !global.guideButtonPressed) {
            event.accepted = true;
            sfxToggle.play();
            if (currentGameIndex > 0)
                currentGameIndex--;
            else
                currentGameIndex = game.collections.get(0).games.count-1;
            gameDetails(game.collections.get(0).games.get(currentGameIndex));
            lastState[lastState.length-1] = "showcasescreen";
            }
        }
    }

    // Helpbar buttons
    ListModel {
        id: gameviewHelpModel
        ListElement {
            name: qsTr("Back")
            button: "cancel"
        }
        ListElement {
            name: qsTr("Launch")
            button: "accept"
        }
    }

    onActiveFocusChanged:
    {
        if (activeFocus){
            currentHelpbarModel = ""; // to force reload for transkation
            currentHelpbarModel = gameviewHelpModel;
        }
    }

    onFocusChanged: {
        //console.log("onFocusChanged - focus",focus);
        if (focus) {
            currentHelpbarModel = gameviewHelpModel;
            menu.focus = true;
            menu.currentIndex = 0;
            if(embedded){
                if(gameToLaunched && !api.launchedgame){
                    if(api.internal.recalbox.getBoolParameter("pegasus.multiwindows") || api.internal.recalbox.getBoolParameter("pegasus.theme.keeploaded")){
                        //to launch animation at launch
                        button1.icon = "../assets/images/loading.png";
                        //start animation without end
                        button1.iconRotation.loops = 30;
                        button1.iconRotation.start();
                    }
                    launchGameDelay.start();
                }
            }
        } 
    }

    //Search to provide the currentGameIndex when gameView is launched from favorite and other collections..
    SearchGameByModel {
        id: searchGameIndex;
        onMaxChanged:{
            //console.log("onMaxChanged - activated :",searchGameIndex.activated);
            //console.log("onMaxChanged - max :",searchGameIndex.max);
            //console.log("onMaxChanged - game_crc :",game_crc);
            //console.log("onMaxChanged - game_name :",game_name);
            //console.log("onMaxChanged - crc :",searchGameIndex.crc);
            //console.log("onMaxChanged - crcToFind :",searchGameIndex.crcToFind);
            //console.log("onMaxChanged - filenameRegEx :",searchGameIndex.filenameRegEx);
            //console.log("onMaxChanged - filenameToFilter :",searchGameIndex.filenameToFilter);
            //console.log("onMaxChanged - system :",searchGameIndex.system);
            //console.log("onMaxChanged - sytemToFind :",searchGameIndex.systemToFilter);
            //console.log("onMaxChanged - result.games.get(0).path", searchGameIndex.result.games.get(0).path);
            //console.log("onMaxChanged - result.games.get(0).files.get(0).path", searchGameIndex.result.games.get(0).files.get(0).path);
            if(searchGameIndex.max === 1){
                currentGameIndex = searchGameIndex.sourceGameIndexFound(0);
            }
        }
    }

    Component.onCompleted: {
        //set currentGameIndex
        searchGameIndex.sourceModel = game.collections.get(0).games;
        searchGameIndex.filenameToFind = true; //force to search exact file name and not a filter using regex
        searchGameIndex.filename = game.path;
        //console.log("Component.onCompleted - filename :",searchGameIndex.filename);
        //activate search at the end
        searchGameIndex.activated = true;
    }
}
