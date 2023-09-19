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
import QtQuick.Layouts 1.15
import SortFilterProxyModel 0.2
import QtMultimedia 5.15
import "VerticalList"
import "GridView"
import "Global"
import "GameDetails"
import "ShowcaseView"
import "Settings"

FocusScope {
    id: root


    //DEBUG property
    property bool detailed_debug: false

    property bool viewIsLoading: true
    property string viewLoadingText: qsTr("Loading") + "..." + api.tr
    property bool gameToLaunched: false
    property bool settingsChanged: false

    //Spinner Loader for all views loading... (principally for main menu for the moment)
    Loader {
        id: spinnerloader
        z:10 
        anchors.centerIn: parent        
        active: viewIsLoading && (showcaseLoader.opacity === 1)
        sourceComponent: spinner
    }

    Component {
        id: spinner
        Rectangle{
            Image {
                id: imageSpinner
                anchors.centerIn: parent
                source: "assets/images/loading.png"
                width: vpx(100)
                height: vpx(100)
                z: 10
                asynchronous: true
                sourceSize { width: vpx(50); height: vpx(50) }
                RotationAnimator on rotation {
                    loops: Animator.Infinite;
                    from: 0;
                    to: 360;
                    duration: 3000
                }
            }
            Text {
                id: textSpinner
                text: viewLoadingText
                width: contentWidth
                height: contentHeight
                font.family: titleFont.name
                font.pixelSize: vpx(24)
                color: theme.text
                property real centerOffset: imageSpinner.height/2
                visible: settings.ShowLoadingDetails === "No" ? false : true
                anchors {
                    top: imageSpinner.verticalCenter; topMargin: centerOffset + vpx(100)
                    horizontalCenter: imageSpinner.horizontalCenter
                }
            }
        }
    } 

    FontLoader { id: titleFont; source: "assets/fonts/SourceSansPro-Bold.ttf" }
    FontLoader { id: subtitleFont; source: "assets/fonts/OpenSans-Bold.ttf" }
    FontLoader { id: bodyFont; source: "assets/fonts/OpenSans-Semibold.ttf" }

    // Load designer settings
    property var designs: {
        return {
            InitialPosition:               api.memory.has("Initial Focus on") ? api.memory.get("Initial Focus on") : "Systems list",
            VideoBannerPosition:           api.memory.has("Video Banner screen position") ? api.memory.get("Video Banner screen position") : "0",
            VideoBannerRatio:              api.memory.has("Video Banner screen ratio") ? api.memory.get("Video Banner screen ratio") : "50%",
            VideoBannerSource:             api.memory.has("Video Banner source") ? api.memory.get("Video Banner source") : "Default",
            VideoBannerLogoSource:         api.memory.has("Video Banner logo source") ? api.memory.get("Video Banner logo source") : "Default",
            VideoBannerPathExpression:     api.memory.has("Video Banner path expression") ? api.memory.get("Video Banner path expression") : "",
            FavoritesBannerPosition:       api.memory.has("Favorites Banner screen position") ? api.memory.get("Favorites Banner screen position") : "0",
            FavoritesBannerRatio:          api.memory.has("Favorites Banner screen ratio") ? api.memory.get("Favorites Banner screen ratio") : "50%",
            SystemsListPosition:           api.memory.has("Systems list screen position") ? api.memory.get("Systems list screen position") : "3",
            SystemsListRatio:              api.memory.has("Systems list screen ratio") ? api.memory.get("Systems list screen ratio") : "15%",
            NbSystemLogos:                 api.memory.has("Number of System logos visible") ? api.memory.get("Number of System logos visible") : "6",
            SystemsListBackground:         api.memory.has("Systems list background source") ? api.memory.get("Systems list background source") : "No",
            SystemsListBackgroundPathExpression:         api.memory.has("Systems list background path expression") ? api.memory.get("Systems list background path expression") : "",
            SystemLogoRatio:               api.memory.has("System logo ratio") ? api.memory.get("System logo ratio") : "80%",
            SystemLogoSource:              api.memory.has("System logo source") ? api.memory.get("System logo source") : "Default",
            SystemLogoPathExpression:      api.memory.has("System logo path expression") ? api.memory.get("System logo path expression") : "",
            SystemMusicSource:             api.memory.has("System music source") ? api.memory.get("System music source") : "No",
            SystemMusicPathExpression:     api.memory.has("System music path expression") ? api.memory.get("System music path expression") : "",
            SystemDetailsPosition:         api.memory.has("System Details screen position") ? api.memory.get("System Details screen position") : "No",
            SystemDetailsRatio:            api.memory.has("System Details screen ratio") ? api.memory.get("System Details screen ratio") : "30%",
            SystemDetailsBackground:       api.memory.has("System Details background source") ? api.memory.get("System Details background source") : "No",
            SystemDetailsBackgroundPathExpression:         api.memory.has("System Details background path expression") ? api.memory.get("System Details background path expression") : "",
            SystemDetailsVideo:            api.memory.has("System Details video source") ? api.memory.get("System Details video source") : "No",
            SystemDetailsVideoPathExpression:         api.memory.has("System Details video path expression") ? api.memory.get("System Details video path expression") : "",
            SystemDetailsHardware:         api.memory.has("System Details hardware source") ? api.memory.get("System Details hardware source") : "No",
            SystemDetailsHardwarePathExpression:         api.memory.has("System Details hardware path expression") ? api.memory.get("System Details hardware path expression") : "",
            SystemDetailsController:       api.memory.has("System Details controller source") ? api.memory.get("System Details controller source") : "No",
            SystemDetailsControllerPathExpression:         api.memory.has("System Details controller path expression") ? api.memory.get("System Details controller path expression") : "",
            ThemeLogoSource:               api.memory.has("Theme logo source") ? api.memory.get("Theme logo source") : "Default",
            ThemeLogoWidth:                api.memory.has("Theme logo width") ? api.memory.get("Theme logo width") : "100",
            GroupsListPosition:            api.memory.has("Groups list screen position") ? api.memory.get("Groups list screen position") : "2",
            GroupsListRatio:               api.memory.has("Groups list screen ratio") ? api.memory.get("Groups list screen ratio") : "15%",
            NbGroupLogos:                  api.memory.has("Number of group logos visible") ? api.memory.get("Number of group logos visible") : "5",
            GroupsListBackground:          api.memory.has("Groups list background source") ? api.memory.get("Groups list background source") : "No",
            GroupsListBackgroundPathExpression:         api.memory.has("Groups list background path expression") ? api.memory.get("Groups list background path expression") : "",
            GroupLogoRatio:                api.memory.has("Group logo ratio") ? api.memory.get("Group logo ratio") : "90%",
            GroupLogoSource:               api.memory.has("Group logo source") ? api.memory.get("Group logo source") : "Default",
            GroupLogoPathExpression:       api.memory.has("Group logo path expression") ? api.memory.get("Group logo path expression") : "",
            GroupMusicSource:              api.memory.has("Group music source") ? api.memory.get("Group music source") : "No",
            GroupMusicPathExpression:      api.memory.has("Group music path expression") ? api.memory.get("Group music path expression") : ""
        }
    }

    // Load settings
    property var settings: {
        return {
            PlatformView:                  api.memory.has("Platform page style") ? api.memory.get("Platform page style") : "Grid",
            GridThumbnail:                 api.memory.has("Grid Thumbnail") ? api.memory.get("Grid Thumbnail") : "Box Art",
            GridColumns:                   api.memory.has("Number of columns") ? api.memory.get("Number of columns") : "5",
            SystemHeaderLogoGradientEffect:    api.memory.has("System Header Logo with pink gradient effect") ? api.memory.get("System Header Logo with pink gradient effect") : "No",
            GameBackground:                api.memory.has("Game Background") ? api.memory.get("Game Background") : "Screenshot",
            AllowGameBackgroundOverlay:    api.memory.has("Game Background overlay") ? api.memory.get("Game Background overlay") : "No",
            GameLogo:                      api.memory.has("Game Logo") ? api.memory.get("Game Logo") : "Show",
            GameLogoPosition:              api.memory.has("Game Logo position") ? api.memory.get("Game Logo position") : "Left",
            GameRandomBackground:          api.memory.has("Randomize Background") ? api.memory.get("Randomize Background") : "No",
            SystemLogo:                    api.memory.has("System Logo") ? api.memory.get("System Logo") : "Show",
            SystemLogoPosition:            api.memory.has("System Logo position") ? api.memory.get("System Logo position") : "Left",
            SystemLogoGradientEffect:    api.memory.has("System Logo with pink gradient effect") ? api.memory.get("System Logo with pink gradient effect") : "No",
            GameBlurBackground:            api.memory.has("Blur Background") ? api.memory.get("Blur Background") : "No",
            VideoPreview:                  api.memory.has("Video preview") ? api.memory.get("Video preview") : "Yes",
            AllowThumbVideo:               api.memory.has("Allow video thumbnails") ? api.memory.get("Allow video thumbnails") : "Yes",
            AllowThumbVideoAudio:          api.memory.has("Play video thumbnail audio") ? api.memory.get("Play video thumbnail audio") : "No",
            HideLogo:                      api.memory.has("Hide logo when thumbnail video plays") ? api.memory.get("Hide logo when thumbnail video plays") : "No",
            HideButtonHelp:                api.memory.has("Hide button help") ? api.memory.get("Hide button help") : "No",
            HelpButtonsStyle:              api.memory.has("Help buttons style") ? api.memory.get("Help buttons style") : "Gamepad",
            HideClock:                     api.memory.has("Hide Clock") ? api.memory.get("Hide Clock") : "No",
            ColorLayout:                   api.memory.has("Color Layout") ? api.memory.get("Color Layout") : "Original",
            ColorBackground:               api.memory.has("Color Background") ? api.memory.get("Color Background") : "Original",
            SystemLogoStyle:               api.memory.has("System Logo Style") ? api.memory.get("System Logo Style") : "Color",
            MouseHover:                    api.memory.has("Enable mouse hover") ? api.memory.get("Enable mouse hover") : "No",
            AlwaysShowTitles:              api.memory.has("Always show titles") ? api.memory.get("Always show titles") : "No",
            AnimateHighlight:              api.memory.has("Animate highlight") ? api.memory.get("Animate highlight") : "No",
            AllowVideoPreviewAudio:        api.memory.has("Video preview audio") ? api.memory.get("Video preview audio") : "Yes",
            AllowVideoPreviewOverlay:      api.memory.has("Video preview overlay") ? api.memory.get("Video preview overlay") : "Yes",
            OverlaysSource:                api.memory.has("Overlays source") ? api.memory.get("Overlays source") : "Default",
            ShowScanlines:                 api.memory.has("Show scanlines") ? api.memory.get("Show scanlines") : "Yes",
            ShowFilename:                  api.memory.has("Show file name") ? api.memory.get("Show file name") : "No",
            ShowFilehash:                  api.memory.has("Show file hash") ? api.memory.get("Show file hash") : "No",
            DetailsDefault:                api.memory.has("Default to full details") ? api.memory.get("Default to full details") : "No",
            ShowcaseColumns:               api.memory.has("Number of games showcased") ? api.memory.get("Number of games showcased") : "10",
            SystemsGroupDisplay:            api.memory.has("Systems group display") ? api.memory.get("Systems group display") : "No",
            SortSystemsBy:                 api.memory.has("Sort systems by") ? api.memory.get("Sort systems by") : "manufacturer",
            SortSystemsSecondlyBy:         api.memory.has("Sort systems secondly by") ? api.memory.get("Sort systems secondly by") : "releasedate",
            //not used ?: ShowcaseFeaturedCollection:    api.memory.has("Featured collection") ? api.memory.get("Featured collection") : "Favorites",
            ShowcaseChangeFavoriteDisplayAutomatically:    api.memory.has("Change favorite display automatically") ? api.memory.get("Change favorite display automatically") : "Yes",
            ShowcaseCollection1:           api.memory.has("Collection 1") ? api.memory.get("Collection 1") : "Recently Played",
            ShowcaseCollection1_Thumbnail: api.memory.has("Collection 1 - Thumbnail") ? api.memory.get("Collection 1 - Thumbnail") : "Wide",
            ShowcaseCollection2:           api.memory.has("Collection 2") ? api.memory.get("Collection 2") : "Most Played",
            ShowcaseCollection2_Thumbnail: api.memory.has("Collection 2 - Thumbnail") ? api.memory.get("Collection 2 - Thumbnail") : "Tall",
            ShowcaseCollection3:           api.memory.has("Collection 3") ? api.memory.get("Collection 3") : "Recommended",
            ShowcaseCollection3_Thumbnail: api.memory.has("Collection 3 - Thumbnail") ? api.memory.get("Collection 3 - Thumbnail") : "Wide",
            ShowcaseCollection4:           api.memory.has("Collection 4") ? api.memory.get("Collection 4") : "None",
            ShowcaseCollection4_Thumbnail: api.memory.has("Collection 4 - Thumbnail") ? api.memory.get("Collection 4 - Thumbnail") : "Tall",
            ShowcaseCollection5:           api.memory.has("Collection 5") ? api.memory.get("Collection 5") : "None",
            ShowcaseCollection5_Thumbnail: api.memory.has("Collection 5 - Thumbnail") ? api.memory.get("Collection 5 - Thumbnail") : "Wide",
            WideRatio:                     api.memory.has("Wide - Ratio") ? api.memory.get("Wide - Ratio") : "0.64",
            TallRatio:                     api.memory.has("Tall - Ratio") ? api.memory.get("Tall - Ratio") : "0.66",
            ShowLoadingDetails:            api.memory.has("Show loading details") ? api.memory.get("Show loading details") : "No",
            ShowPlayStats:                 api.memory.has("Show play stats") ? api.memory.get("Show play stats") : "No",
            DemoTriggeringDelay:           api.memory.has("Demo triggering delay (in minutes)") ? api.memory.get("Demo triggering delay (in minutes)") : "Deactivated",
            DemoShowFullDetails:           api.memory.has("Demo show full details") ? api.memory.get("Demo show full details") : "No",
            PreferedRegion:                api.memory.has("Prefered region") ? api.memory.get("Prefered region") : "eu"
        }
    }

    // Collections
    property int currentGroupIndex
    property var currentGroup
    property int currentCollectionIndex
    property int currentGameIndex
    property var currentCollection
    property var currentGame

    // Stored variables for page navigation
    property int storedHomePrimaryIndex
    property int storedHomeSecondaryIndex
    property int storedCollectionIndex
    property int storedCollectionGameIndex

    //global property
    property bool videoToStop: false

    // Handle loading settings when returning from a game
    property bool fromGame: api.memory.has('To Game');
    property string state;
    property var lastState: []
    property var lastGame: [] //lastGame is used only for 'title' tracability now, working by Index is better in QML
    property var lastGameIndex: []
    property var gameToLaunch

    // Reset the stored game index when changing collections
    onCurrentCollectionIndexChanged: {
        storedCollectionGameIndex = 0
        searchTerm = "";
        //console.log("currentCollectionIndex : ",currentCollectionIndex)
        //console.log("currentCollection.shortName  : ",currentCollection.shortName)
    }

    // Filtering options
    property bool showFavs: false
    property var sortByFilter: ["title", "lastPlayed", "playCount", "rating"]
    property var sortByFilterDisplay: [qsTr("title") + api.tr, qsTr("lastPlayed") + api.tr, qsTr("playCount") + api.tr, qsTr("rating") + api.tr]
    property int sortByIndex: 0
    property int orderBy: Qt.AscendingOrder
    property string searchTerm: ""
    property bool steam: typeof(currentCollection) !== 'undefined' ? currentCollection.name === "Steam" : false

    function steamExists() {
        for (i = 0; i < api.collections.count; i++) {
            if (api.collections.get(i).name === "Steam") {
                return true;
            }
            return false;
        }
    }

    // Functions for switching currently active collection
    function toggleFavs() {
        showFavs = !showFavs;
    }

    function cycleSort() {
        if (sortByIndex < sortByFilter.length - 1)
            sortByIndex++;
        else
            sortByIndex = 0;
    }

    function toggleOrderBy() {
        if (orderBy === Qt.AscendingOrder)
            orderBy = Qt.DescendingOrder;
        else
            orderBy = Qt.AscendingOrder;
    }
    
    //Timer to launch video with delay in case of embedded gameView
    Timer {
        id: launchGameTimer
        running: false
        triggeredOnStart: false
        repeat: false
        interval: 500
        onTriggered: {
            if(!api.internal.recalbox.getBoolParameter("pegasus.multiwindows") && !api.internal.recalbox.getBoolParameter("pegasus.theme.keeploaded")){
              launchGameScreen();
            }
            else{
                launchGameTimerBis.start();
            }

        }
    }

    //Timer to launch video with delay in case of embedded gameView
    Timer {
        id: launchGameTimerBis
        running: false
        triggeredOnStart: false
        repeat: false
        interval: 100
        onTriggered: {
            gameToLaunch.launch();
            //reset flag for game to launched
            gameToLaunched = false;
        }
    }


    // Launch the current game
    function launchGame(game) {
        if (typeof(game) !== "undefined") {
            //if pegasus.multiwindows is no activated
            if(!api.internal.recalbox.getBoolParameter("pegasus.multiwindows") && !api.internal.recalbox.getBoolParameter("pegasus.theme.keeploaded")){
                launchGameScreen();
                saveCurrentState(game);
                game.launch();
            }
            else{
                gameToLaunch = game;
                saveCurrentState(game);
                launchGameTimer.start();
            }
        } else {
            //console.log("launchGame(game) with game is null");
            //if pegasus.multiwindows is no activated
            if(!api.internal.recalbox.getBoolParameter("pegasus.multiwindows") && !api.internal.recalbox.getBoolParameter("pegasus.theme.keeploaded")){
              launchGameScreen();
              saveCurrentState(currentGame);
              currentGame.launch();
            }
            else{
                gameToLaunch = currentGame;
                saveCurrentState(currentGame);
                launchGameTimer.start();
            }
        }
    }

    // Save current states for returning from game
    function saveCurrentState(game) {
        api.memory.set('savedState', root.state);
        api.memory.set('savedCollection', currentCollection);
    	//console.log("lastState  : ",JSON.stringify(lastState));
        api.memory.set('lastState', JSON.stringify(lastState));
        //console.log("lastGame  : ",JSON.stringify(lastGame));
        api.memory.set('lastGame', JSON.stringify(lastGame));
        api.memory.set('lastGameIndex', JSON.stringify(lastGameIndex));

        //console.log("storedHomePrimaryIndex saved  : ",storedHomePrimaryIndex)
        api.memory.set('storedHomePrimaryIndex', storedHomePrimaryIndex);
        //console.log("storedHomeSecondaryIndex  saved : ",storedHomeSecondaryIndex)
        api.memory.set('storedHomeSecondaryIndex', storedHomeSecondaryIndex);
        api.memory.set('storedGroupIndex',currentGroupIndex);
        api.memory.set('storedCollectionIndex', currentCollectionIndex);
        api.memory.set('storedCollectionGameIndex', storedCollectionGameIndex);
        //to save search from grid or vertical list if needed
        api.memory.set('searchTerm', searchTerm);

        const savedGameIndex = api.allGames.toVarArray().findIndex(g => g === game);
        api.memory.set('savedGameIndex', savedGameIndex);

        api.memory.set('To Game', 'True');
    }

    function returnedFromGame() {
        lastState                   = JSON.parse(api.memory.get('lastState'));
        //console.log("lastState  : ",JSON.stringify(lastState));
        lastGame                    = JSON.parse(api.memory.get('lastGame'));
        lastGameIndex               = JSON.parse(api.memory.get('lastGameIndex'));

        //console.log("lastGame  : ",JSON.stringify(lastGame));
        
        currentGroupIndex           = api.memory.get('storedGroupIndex');
        currentCollection           = api.memory.get('savedCollection');
        //console.log("currentCollection.shortName  : ",currentCollection.shortName)
        storedHomePrimaryIndex      = api.memory.get('storedHomePrimaryIndex');
        //console.log("storedHomePrimaryIndex restored : ",storedHomePrimaryIndex)
        storedHomeSecondaryIndex    = api.memory.get('storedHomeSecondaryIndex');
        //console.log("storedHomeSecondaryIndex restored : ",storedHomeSecondaryIndex)
        currentCollectionIndex      = api.memory.get('storedCollectionIndex');
        //console.log("currentCollectionIndex : ",currentCollectionIndex)
        storedCollectionGameIndex   = api.memory.get('storedCollectionGameIndex');
        //console.log("currentCollectionIndex : ",currentCollectionIndex)
        currentCollection           = api.collections.get(currentCollectionIndex);
        //console.log("currentCollectionIndex : ",currentCollectionIndex)
        //console.log("currentCollection.shortName  : ",currentCollection.shortName)
        currentGame                 = api.allGames.get(api.memory.get('savedGameIndex'));
        //console.log("currentGame.title  : ",currentGame.title);
        root.state                  = api.memory.get('savedState');

        //to restore search from grid or vertical list if needed
        searchTerm = api.memory.get('searchTerm');

        // Remove these from memory so as to not clog it up
        api.memory.unset('savedState');
        api.memory.unset('savedGameIndex');
        api.memory.unset('savedCollection');
        api.memory.unset('lastState');
        api.memory.unset('lastGame');
        api.memory.unset('lastGameIndex');
        api.memory.unset('storedHomePrimaryIndex');
        api.memory.unset('storedHomeSecondaryIndex');
        api.memory.unset('storedCollectionIndex');
        api.memory.unset('storedCollectionGameIndex');
        api.memory.unset('searchTerm');

        // Remove this one so we only have it when we come back from the game and not at Pegasus launch
        api.memory.unset('To Game');
    }

    // Theme settings
    property var theme: {

        var background =         "#000000";
        var text =                 "#ebebeb";
        var gradientstart =             "#001f1f1f";
        var gradientend =         "#FF000000";
        var secondary =         "#303030";

        if (settings.ColorBackground === "Original") {
            background =      "#1d253d";
            text =           "#ececec";
            gradientstart =  "#000d111d";
            gradientend =    "#FF0d111d";
        }
        else if (settings.ColorBackground === "Black") {
            background =     "#000000";
            gradientstart = "#001f1f1f";
            gradientend =     "#FF000000";
        }
        else if (settings.ColorBackground === "White") {
            background =     "#ebebeb";
            gradientstart = "#00ebebeb";
            gradientend =     "#FFebebeb";
            text         =     "#101010";
        }
        else if (settings.ColorBackground === "Gray") {
            background =     "#1f1f1f";
            gradientstart = "#001f1f1f";
            gradientend =     "#FF1F1F1F";
        }
        else if (settings.ColorBackground === "Blue") {
            background =     "#1d253d";
            gradientstart = "#001d253d";
            gradientend =     "#FF1d253d";
        }
        else if (settings.ColorBackground === "Green") {
            background =     "#054b16";
            gradientstart = "#00054b16";
            gradientend =     "#00054b16";
        }
        else if (settings.ColorBackground === "Red") {
            background =     "#520000";
            gradientstart = "#00520000";
            gradientend =     "#FF520000";
        }

        var accent = "#288928";
        if (settings.ColorLayout === "Original") {
            accent = "#f00980";
            secondary = "#202a44";
        }
        else if (settings.ColorLayout === "Dark Green") {
            accent = "#288928";
        }
        else if (settings.ColorLayout === "Light Green") {
            accent = "#65b032";
        }
        else if (settings.ColorLayout === "Turquoise") {
            accent = "#288e80";
        }
        else if (settings.ColorLayout === "Dark Red") {
            accent = "#ab283b";
        }
        else if (settings.ColorLayout === "Light Red") {
            accent = "#e52939";
        }
        else if (settings.ColorLayout === "Dark Pink") {
            accent = "#c52884";
        }
        else if (settings.ColorLayout === "Light Pink") {
            accent = "#ee6694";
        }
        else if (settings.ColorLayout === "Dark Blue") {
            accent = "#30519c";
        }
        else if (settings.ColorLayout === "Light Blue") {
            accent = "#288dcf";
        }
        else if (settings.ColorLayout === "Orange") {
            accent = "#ed5b28";
        }
        else if (settings.ColorLayout === "Yellow") {
            accent = "#ed9728";
        }
        else if (settings.ColorLayout === "Magenta") {
            accent = "#b857c6";
        }
        else if (settings.ColorLayout === "Purple") {
            accent = "#825fb1";
        }
        else if (settings.ColorLayout === "Dark Gray") {
            accent = "#5e5c5d";
        }
        else if (settings.ColorLayout === "Light Gray") {
            accent = "#818181";
        }
        else if (settings.ColorLayout === "Dark Gray") {
            accent = "#5e5c5d";
        }
        else if (settings.ColorLayout === "Steel") {
            accent = "#768294";
        }
        else if (settings.ColorLayout === "Stone") {
            accent = "#658780";
        }
        else if (settings.ColorLayout === "Dark Brown") {
            accent = "#806044";
        }
        else if (settings.ColorLayout === "Light Brown") {
            accent = "#7e715c";
        }
        return {
            main:           background,
            secondary:      secondary,
            accent:         accent,
            highlight:      accent,
            text:           text,
            button:         accent,
            gradientstart:  gradientstart,
            gradientend:    gradientend
        };

    };
    

    property real globalMargin: vpx(30)
    property real helpMargin: helpbuttonbar.height
    property int transitionTime: 100

    // State settings
    states: [
        State {
            name: "softwarescreen";
        },
        State {
            name: "softwaregridscreen";
        },
        State {
            name: "showcasescreen";
        },
        State {
            name: "gameviewscreen";
        },
        State {
            name: "settingsscreen";
        },
        State {
            name: "launchgamescreen";
        }
    ]

    // Screen switching functions
    function softwareScreen() {
        sfxAccept.play();
        lastState.push(state);
        //console.log("gameDetails - lastState (after push) : ",JSON.stringify(lastState));
        switch(settings.PlatformView) {
        case "Grid":
            root.state = "softwaregridscreen";
            break;
        default:
            root.state = "softwarescreen";
        }
    }

    function showcaseScreen() {
        sfxAccept.play();
        //console.log("gameDetails(showcaseScreen) - lastState (before push) : ",JSON.stringify(lastState));
        lastState.push(state);
        //console.log("gameDetails - lastState (after push) : ",JSON.stringify(lastState));
        //console.log("gameDetails(showcaseScreen) - lastState (after push) : ",JSON.stringify(lastState));
        root.state = "showcasescreen";
    }

    function gameDetails(game) {
        sfxAccept.play();
        //if (game !== null) console.log("gameDetails - game.title:", game.title);
        //else console.log("gameDetails - game.title:", "null");
        
	//console.log("gameDetails - lastState : ",JSON.stringify(lastState));
        // As long as there is a state history, save the last game
        if (lastState.length != 0){
            if (typeof(currentGame) !== "undefined") {
	            //console.log("gameDetails - currentGame.title:", currentGame.title);
                //console.log("gameDetails - currentGame:", JSON.stringify(currentGame));
                //console.log("gameDetails - lastGame (before push) : ",JSON.stringify(lastGame));
                lastGame.push(currentGame.title);
                //console.log("gameDetails - lastGame 'titles' (after push) : ",JSON.stringify(lastGame));
                const curentGameIndex = api.allGames.toVarArray().findIndex(g => g === currentGame);
                lastGameIndex.push(curentGameIndex);
                //console.log("gameDetails - lastGameIndex (after push) : ",JSON.stringify(lastGameIndex));
            }
        }

        // Push the new game
        if (game !== null){
            currentGame = game;
            //console.log("gameDetails - new currentGame.title:", currentGame.title);
        }
        
        // Save the state before pushing the new one
        lastState.push(state);
        //console.log("gameDetails - lastState (after push) : ",JSON.stringify(lastState));
        root.state = "gameviewscreen";
    }

    function settingsScreen() {
        sfxAccept.play();
        lastState.push(state);
        //console.log("gameDetails - lastState (after push) : ",JSON.stringify(lastState));
        root.state = "settingsscreen";
    }

    function launchGameScreen() {
        sfxAccept.play();
        lastState.push(state);
        //console.log("gameDetails - lastState (after push) : ",JSON.stringify(lastState));
        root.state = "launchgamescreen";
        if(api.internal.recalbox.getBoolParameter("pegasus.multiwindows") || api.internal.recalbox.getBoolParameter("pegasus.theme.keeploaded")){
                launchGameTimerBis.start();
        }
    }

    function previousScreen() {
        sfxBack.play();

        //reset here settings flag in all cases
        settingsChanged = false;

        if (state === lastState[lastState.length-1])
        {    
            popLastGame();
        }
        else if(previousHelpbarModel) {
            currentHelpbarModel = previousHelpbarModel;
        }
        
        state = lastState[lastState.length - 1];
        //console.log("gameDetails - current state : ",state);
        lastState.pop();
        //console.log("gameDetails - lastState (after pop) : ",JSON.stringify(lastState));

    }

    function popLastGame() {
        if (lastGame.length) {
            //New method to get game from lastGameIndex table
            currentGame = api.allGames.get(lastGameIndex[lastGameIndex.length-1]);
            //console.log("gameDetails - popLastGame - currentGame : ",currentGame.title);
            lastGame.pop();
            //console.log("gameDetails - lastGame 'titles' (after pop) : ",JSON.stringify(lastGame));
            lastGameIndex.pop();
            //console.log("gameDetails - lastGameIndex (after pop) : ",JSON.stringify(lastGameIndex));
        }
    }

    // Set default state to the platform screen
    Component.onCompleted: {
        root.state = "showcasescreen";
        //console.log("gameDetails - lastState (initial) : ",JSON.stringify(lastState));
        if (fromGame)
            returnedFromGame();
    }

    // Background
    Rectangle {
        id: background
        
        anchors.fill: parent
        color: theme.main
    }

    Loader  {
        id: showcaseLoader

        focus: (root.state === "showcasescreen")
        active: true //force loading in all cases
        opacity: focus ? 1 : 0
        Behavior on opacity { PropertyAnimation { duration: transitionTime } }

        anchors.fill: parent
        sourceComponent: showcaseview
        asynchronous: true
    }

    Loader  {
        id: gridviewloader

        focus: (root.state === "softwaregridscreen")
        active: opacity !== 0
        opacity: focus ? 1 : 0
        Behavior on opacity { PropertyAnimation { duration: transitionTime } }

        anchors.fill: parent
        sourceComponent: gridview
        asynchronous: true
    }

    Loader  {
        id: listviewloader

        focus: (root.state === "softwarescreen")
        active: opacity !== 0
        opacity: focus ? 1 : 0
        Behavior on opacity { PropertyAnimation { duration: transitionTime } }

        anchors.fill: parent
        sourceComponent: (api.collections.get(currentCollectionIndex).shortName === "imageviewer") ? screenshotlistview : listview
        asynchronous: true
    }

    Loader  {
        id: gameviewloader

        focus: (root.state === "gameviewscreen")
        active: opacity !== 0
        onActiveChanged: if (!active) popLastGame();
        opacity: focus ? 1 : 0
        Behavior on opacity { PropertyAnimation { duration: transitionTime } }

        anchors.fill: parent
        sourceComponent: currentGame.collections.get(0).shortName === "imageviewer" ? screenshotview : gameview
        asynchronous: true
    }

    Loader  {
        id: launchgameloader

        focus: (root.state === "launchgamescreen")
        active: opacity !== 0
        opacity: focus ? 1 : 0
        Behavior on opacity { PropertyAnimation { duration: transitionTime } }

        anchors.fill: parent
        sourceComponent: launchgameview
        asynchronous: true
    }

    Loader  {
        id: settingsloader

        focus: (root.state === "settingsscreen")
        active: opacity !== 0
        opacity: focus ? 1 : 0
        Behavior on opacity { PropertyAnimation { duration: transitionTime } }

        anchors.fill: parent
        sourceComponent: settingsview
        asynchronous: true
    }

    Component {
        id: showcaseview
    
    ShowcaseViewMenu { focus: true; visible: !viewIsLoading; }
    }

    Component {
        id: gridview

        GridViewMenu { focus: true }
    }

    Component {
        id: listview

        SoftwareListMenu { focus: true }
    }

    Component {
        id: screenshotlistview

        ScreenshotListMenu { focus: true }
    }

    Component {
        id: gameview

        GameView {
            focus: true
            game: currentGame
        }
    }

    Component {
        id: screenshotview

        ScreenshotView {
            focus: true
            game: currentGame
        }
    }
	
    //property, timers & functions to manage a demo mode in gameOS theme ;-)
    property bool demoLaunched: false
    
    function getRandomInt(max) {
      return Math.floor(Math.random() * max);
    }


    //in this section, we use timers/function/events to detect any move in theme but could be catch by other view.
    //Optionally: add resetDemo() if you have Keys.onReleased if other view outside theme.qml.
    //We advice also to do it where the event is accepted near line: "event.accepted = true;"
    function resetDemo(){
        //console.log("resetDemo() launched !");
        if(settings.DemoTriggeringDelay !== "Deactivated"){
            //if any key is used, we restart demoTrigger timer.
            demoTrigger.running = false;
            demoTrigger.running = true;
        }
        else demoTrigger.running = false;
        //and stop demo in all cases
        demoTimer.running = false;
        demoLaunched = false;
    }

    //we use Keys.OnReleased because this event is rarelly used in children views.
    Keys.onReleased:{
        resetDemo();
    }

    //this timer is use to trigger the demo
    Timer {
        id: demoTrigger
        interval: settings.DemoTriggeringDelay !== "Deactivated" ? parseInt(settings.DemoTriggeringDelay,10) * 60000 : 60000 //no set to 0 to avoid launch of demo during settings udpate
        repeat: false
        running: settings.DemoTriggeringDelay !== "Deactivated" ? true : false
        triggeredOnStart: false
        // Check if game not launch before launch demo trigger
        onTriggered: {
            if ( !api.launchedgame ){
                demoTimer.running = true;
            }
        }
    }

    //this timer is used during demo to change video every each minutes
    Timer {
        id: demoTimer
        interval: 60000 // Run the timer every 60s
        repeat: true
        running: false
        triggeredOnStart: true
        onTriggered: {
            //selection any collection
            var demoCollectionIndex = 0;
            do{
                demoCollectionIndex = getRandomInt(api.collections.count-1);
                //console.log("api.collections.get(demoCollectionIndex).shortName:",api.collections.get(demoCollectionIndex).shortName);
            }while(api.collections.get(demoCollectionIndex).shortName === "imageviewer")
            //selection game in collection
            var demoGameIndex = 0;
            var loopCount = 0; //loopCount is here to unlock when system is not or no well scrapped
            do{
                demoGameIndex = getRandomInt(api.collections.get(demoCollectionIndex).games.count-1);
                loopCount++;
            }while((api.collections.get(demoCollectionIndex).games.get(demoGameIndex).assets.videos.length === 0) && (loopCount <= 10))

            if(api.collections.get(demoCollectionIndex).games.get(demoGameIndex).assets.videos.length !== 0){
                demoLaunched = true;
                gameDetails(api.collections.get(demoCollectionIndex).games.get(demoGameIndex));
                lastState[lastState.length-1] = "showcasescreen";
            }
        }
    }

    Component {
        id: launchgameview

        LaunchGame { focus: true }
    }

    Component {
        id: settingsview

        SettingsScreen { focus: true }
    }

    
    // Button help
    property var currentHelpbarModel
    property var previousHelpbarModel
    ButtonHelpBar {
        id: helpbuttonbar
        height: vpx(50)
        anchors {
            left: parent.left; right: parent.right; rightMargin: globalMargin
            bottom: parent.bottom
        }
        opacity: viewIsLoading && (showcaseLoader.opacity === 1) ? 0 : 1
        visible: settings.HideButtonHelp === "No"
    }

    ///////////////////
    // SOUND EFFECTS //
    ///////////////////
    SoundEffect {
        id: sfxNav
        source: "assets/sfx/navigation.wav"
        volume: 1.0
    }

    SoundEffect {
        id: sfxBack
        source: "assets/sfx/back.wav"
        volume: 1.0
    }

    SoundEffect {
        id: sfxAccept
        source: "assets/sfx/accept.wav"
    }

    SoundEffect {
        id: sfxToggle
        source: "assets/sfx/toggle.wav"
    }
    
}

