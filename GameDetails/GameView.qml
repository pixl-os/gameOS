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
import QtGraphicalEffects 1.0
import SortFilterProxyModel 0.2
import QtQml.Models 2.12
import QtMultimedia 5.12
import "../Global"
import "../GridView"
import "../Lists"
import "../utils.js" as Utils
import "../Search"

FocusScope {
    id: root

    property var game: api.allGames.get(0)
    property bool readyForNeplay: isReadyForNetplay(game)
    property string favIcon: game && game.favorite ? "../assets/images/icon_unheart.svg" : "../assets/images/icon_heart.svg"
    property string collectionName: game ? game.collections.get(0).name : ""
    property string collectionShortName: game ? game.collections.get(0).shortName : ""
    property bool iamsteam: game ? (collectionShortName === "steam") : false
    property bool canPlayVideo: ((settings.VideoPreview === "Yes") && (appWindow.activeFocusItem !== null)) ? true : false
    onCanPlayVideoChanged:{
        //to force to stop video playing when we lost focus
       if(canPlayVideo === false) toggleVideo(false);
    }

    property real detailsOpacity: ((settings.DetailsDefault === "Yes") && (demoLaunched !== true)) || ((settings.DemoShowFullDetails === "Yes") && (demoLaunched === true)) ? 1 : 0
	property real retroachievementsOpacity: 0
	property bool blurBG: settings.GameBlurBackground === "Yes"
    property string publisherName: {
        if (game !== null && game.publisher !== null) {
            var str = game.publisher;
            var result = str.split(" ");
            return result[0]
        } else {
            return ""
        }
    }

    //parameter for Overlay
    property bool overlay_exists: false
    property int aspect_ratio_index: 0
    property int custom_viewport_x: 0
    property int custom_viewport_y: 0
    property int custom_viewport_width: 0
    property int custom_viewport_height: 0
    property string overlay_cfg_filename_fullpath: ""
    property string overlay_png_filename_fullpath: ""
    property string input_overlay_cfg_filename_fullpath: ""

    property string overlaySource:{
       if(settings.OverlaysSource === "Default"){
           return "/recalbox/share_init/overlays";
       }
       else{
           return "/recalbox/share/overlays";
       }
    }

    //function to prepare resize of video and screenshot depending Overlays configuration
    function getOverlaysParameters(){
        //to find game name
        var path = game.files.get(0).path;
        var word = path.split('/');
        var game_filename = word[word.length-1];
        //console.log("getOverlaysParameters() - game_filename : ", game_filename);
        //game_filename = game_filename.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
        //console.log("getOverlaysParameters() - 'escaped' game_filename : ", game_filename);

        //reset overlay to avoid to reuse it for one that doesn't exist
        overlay_png_filename_fullpath = "";
        overlay_cfg_filename_fullpath = "";
        input_overlay_cfg_filename_fullpath = "";

        //check if custom overlays exists
        overlay_exists = api.internal.system.run("test -f \"" + root.overlaySource + "/" + game.collections.get(0).shortName + "/" + game_filename + ".cfg\" && echo \"true\"");
        if(overlay_exists !== true){
            //check if system overlays exists
            overlay_exists = api.internal.system.run("test -f \"" + root.overlaySource + "/" + game.collections.get(0).shortName + "/" + game.collections.get(0).shortName + ".cfg\" && echo \"true\"");
            if(overlay_exists === true) overlay_cfg_filename_fullpath = root.overlaySource + "/" + game.collections.get(0).shortName + "/" + game.collections.get(0).shortName + ".cfg";
        }
        else{
            overlay_cfg_filename_fullpath = root.overlaySource + "/" + game.collections.get(0).shortName + "/" + game_filename + ".cfg";
        }
        //console.log("getOverlaysParameters() - overlay_cfg_filename_fullpath : ", overlay_cfg_filename_fullpath);
        //console.log("getOverlaysParameters() - overlay_exists : ", overlay_exists);
        if(overlay_exists === true){
            aspect_ratio_index = parseInt(api.internal.system.run("cat \"" + overlay_cfg_filename_fullpath + "\" | grep -E \"aspect_ratio_index\" | awk -F '=' '{print $2}'").replace(/\"/g, "").trim()); //to remove " by nothing & trim
            //console.log("getOverlaysParameters() - aspect_ratio_index : ", aspect_ratio_index);
            input_overlay_cfg_filename_fullpath = api.internal.system.run("cat \"" + overlay_cfg_filename_fullpath + "\" | grep -E \"input_overlay\" | grep -E '/' | awk -F '=' '{print $2}'").replace(/\"/g, "").trim(); //to remove " by nothing & trim
            //console.log("getOverlaysParameters() - input_overlay_cfg_filename_fullpath : ", input_overlay_cfg_filename_fullpath);
            //get path of input_overlay cfg
            var cfgpath = input_overlay_cfg_filename_fullpath;
            var cfgword = cfgpath.split('/');
            var cfg_filename = cfgword[cfgword.length-1];
            //console.log("getOverlaysParameters() - cfg_filename : ", cfg_filename);
            //use path of input_overlay cfg and png filename
            var overlay0_overlay = api.internal.system.run("cat \"" + input_overlay_cfg_filename_fullpath + "\" | grep -E \"overlay0_overlay\" | awk -F '=' '{print $2}'").replace(/\"/g, "").trim(); //to remove " by nothing & trim
            //console.log("getOverlaysParameters() - overlay0_overlay : ", overlay0_overlay);
            overlay_png_filename_fullpath = input_overlay_cfg_filename_fullpath.replace(cfg_filename,overlay0_overlay);
            //console.log("getOverlaysParameters() - overlay_png_filename_fullpath : ", overlay_png_filename_fullpath);

            if(aspect_ratio_index === 23){
                //get the following parameter in this case
                //custom_viewport_x = "251"
                //custom_viewport_y = "10"
                //custom_viewport_width = "1415"
                //custom_viewport_height = "1060"

                custom_viewport_x = parseInt(api.internal.system.run("cat \"" + overlay_cfg_filename_fullpath + "\" | grep -E \"custom_viewport_x\" | awk -F '=' '{print $2}'").replace(/\"/g, "").trim()); //to remove " by nothing & trim
                custom_viewport_y = parseInt(api.internal.system.run("cat \"" + overlay_cfg_filename_fullpath + "\" | grep -E \"custom_viewport_y\" | awk -F '=' '{print $2}'").replace(/\"/g, "").trim()); //to remove " by nothing & trim
                custom_viewport_width = parseInt(api.internal.system.run("cat \"" + overlay_cfg_filename_fullpath + "\" | grep -E \"custom_viewport_width\" | awk -F '=' '{print $2}'").replace(/\"/g, "").trim()); //to remove " by nothing & trim
                custom_viewport_height = parseInt(api.internal.system.run("cat \"" + overlay_cfg_filename_fullpath + "\" | grep -E \"custom_viewport_height\" | awk -F '=' '{print $2}'").replace(/\"/g, "").trim()); //to remove " by nothing & trim
                //check if overlay 1080p or 720p
                if((appWindow.height < custom_viewport_height) || (appWindow.width < custom_viewport_width)){
                    //Need to divide by 2 because the overlay is certainly in 1080p and Window in 720p
                    custom_viewport_x = custom_viewport_x * (1280/1920);
                    custom_viewport_y = custom_viewport_y * (720/1080);
                    custom_viewport_width = custom_viewport_width * (1280/1920);
                    custom_viewport_height = custom_viewport_height * (720/1080);
                }
            }
        }
        //console.log("getOverlaysParameters() - custom_viewport_x : ", custom_viewport_x);
        //console.log("getOverlaysParameters() - custom_viewport_y : ", custom_viewport_y);
        //console.log("getOverlaysParameters() - custom_viewport_width : ", custom_viewport_width);
        //console.log("getOverlaysParameters() - custom_viewport_height : ", custom_viewport_height);
    }

    ListPublisher { id: publisherCollection; publisher: game && game.publisher ? game.publisher : ""; max: 10 }
    ListGenre { id: genreCollection; genre: game ? game.genreList[0] : ""; max: 10 }

    // Combine the video and the screenshot arrays into one
    function mediaArray() {
        let mediaList = [];
        if (game && game.assets.video) game.assets.videoList.forEach(v => mediaList.push(v));

        if (game && game.assets.manual) {
            mediaList.push(game.assets.manual);
        }

        if (game) {
            game.assets.screenshotList.forEach(v => mediaList.push(v));
            game.assets.backgroundList.forEach(v => mediaList.push(v));

            //To add other assets as visible in media list if possible (verify to avoid dooblons display also)
            if ((game.assets.boxFront !== "") && (game.assets.boxFront !== game.assets.screenshots[0]) && (game.assets.boxFront !== game.assets.background)) mediaList.push(game.assets.boxFront);
            if (game.assets.boxFront3d !== "") mediaList.push(game.assets.boxFront3d);
            if (game.assets.boxBack !== "") mediaList.push(game.assets.boxBack);
            if (game.assets.boxSpine !== "") mediaList.push(game.assets.boxSpine);
            if (game.assets.boxFull !== "") mediaList.push(game.assets.boxFull);
            if ((game.assets.cartridge !== "") && (game.assets.cartridge !== game.assets.boxFront)) mediaList.push(game.assets.cartridge);
            if (game.assets.cartridgetexture !== "") mediaList.push(game.assets.cartridgetexture);
            if (game.assets.logo !== "") mediaList.push(game.assets.logo);
            if (game.assets.logocarbon !== "") mediaList.push(game.assets.logocarbon);
            if (game.assets.logosteel !== "") mediaList.push(game.assets.logosteel);
            if (game.assets.poster !== "") mediaList.push(game.assets.poster);

            if (game.assets.marquee !== "") mediaList.push(game.assets.marquee);
            if (game.assets.screenmarqueesmall !== "") mediaList.push(game.assets.screenmarqueesmall);
            if (game.assets.bezel !== "") mediaList.push(game.assets.bezel);
            if (game.assets.panel !== "") mediaList.push(game.assets.panel);
            if (game.assets.cabinetLeft !== "") mediaList.push(game.assets.cabinetLeft);
            if (game.assets.cabinetRight !== "") mediaList.push(game.assets.cabinetRight);

            if (game.assets.tile !== "") mediaList.push(game.assets.tile);
            if (game.assets.steam !== "") mediaList.push(game.assets.steam);
            if (game.assets.banner !== "") mediaList.push(game.assets.banner);

            //if (game.assets.music !== "") mediaList.push(game.assets.music);//RFU

            if (game.assets.titlescreen !== "") mediaList.push(game.assets.titlescreen);

            if (game.assets.map !== "") mediaList.push(game.assets.map);
        }

        return mediaList;
    }

    // Reset the screen to default state
    function reset() {
        content.currentIndex = 0;
        menu.currentIndex = 0;
        media.savedIndex = 0;
        list1.savedIndex = 0;
        list2.savedIndex = 0;
        screenshot.opacity = 1;
        mediaScreen.opacity = 0;
        toggleVideo(true);
    }

	function setRetroAchievements(){
        if(game.retroAchievementsCount !== 0){
            //to force update of GameAchievements model for gridView
            achievements.model = game.retroAchievementsCount;
            if (readyForNeplay){
               button5.visible = true;
               button6.visible = true;
            }
            else{
                button5.visible = true;
                button6.visible = false;

            }
        }
        else
        {
            if (readyForNeplay) button5.visible = true;
            else button5.visible = false;
            button6.visible = false;
            //hide retroachievements if displayed from a previous game
            if(retroachievementsOpacity === 1) showDetails();
        }
	}

    // Show/hide the details overlay
    function showDetails() {
        if (detailsOpacity === 1) {
            toggleVideo(true);
            detailsOpacity = 0;
	        retroachievementsOpacity = 0;
        }
        else {
            detailsOpacity = 1;
	        retroachievementsOpacity = 0;
            toggleVideo(false);
	        achievements.selected = false;
	        content.focus = true;
        }
    }

    // Show/hide the achievements
    function showAchievements() {
        if (retroachievementsOpacity === 1) {
            detailsOpacity = 1;
            retroachievementsOpacity = 0;
	        achievements.selected = false;
	        content.focus = true;
        }
        else {
	        detailsOpacity = 0;
	        retroachievementsOpacity = 1;
            toggleVideo(false);
		    achievements.index = -1;
		    achievements.updateDetails(0);
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
				//launch initialization of retroachievements
				//the initialization is done in a separate thread to avoid conflicts and blocking in user interface)
				game.initRetroAchievements();
                //init overlays parameters
                root.getOverlaysParameters();
	}	

	Connections {
        target: game
		function onRetroAchievementsInitialized() {
            //console.log("GameView - retroAchievements is now initialized !");
			setRetroAchievements();	
		}
    }

    anchors.fill: parent

    GridSpacer {
        id: fakebox

        width: vpx(100); height: vpx(100)
    }

    // Video
    // Show/hide the video
    function toggleVideo(toggle) {
      if (!toggle)
      {
        // Turn off video
        screenshot.opacity = 1;
        stopvideo.restart();
      } else {
        stopvideo.stop();
        // Turn on video
        if (canPlayVideo)
            videoDelay.restart();
      }
    }

    // Timer to show the video
    Timer {
        id: videoDelay

        interval: 1000
        onTriggered: {
            if (game && game.assets.videos.length && canPlayVideo) {
                videoPreviewLoader.sourceComponent = videoPreviewWrapper;
                fadescreenshot.restart();
            }
        }
    }

    // NOTE: Next fade out the bg so there is a smooth transition into the video
    Timer {
        id: fadescreenshot

        interval: 1000
        onTriggered: {
            screenshot.opacity = 0;
            if (blurBG)
                blurBG.opacity = 0;
        }
    }

    Timer {
        id: stopvideo

        interval: 1000
        onTriggered: {
            videoPreviewLoader.sourceComponent = undefined;
            videoDelay.stop();
            fadescreenshot.stop();
        }
    }

    // NOTE: Video Preview
    Component {
        id: videoPreviewWrapper

        Rectangle{
            anchors.fill: parent
            color: "black"
            Video {
                id: videocomponent
                property bool videoExists: game ? game.assets.videos.length : false
                source: {
                        if(videoExists){
                            //console.log("video path:",game.assets.videos[0]);
                            return game.assets.videos[0];
                        }
                        else return "";
                }

                height: ((settings.AllowVideoPreviewOverlay === "Yes") && (overlay_exists === true)) ? (custom_viewport_height === 0 ? parent.height : custom_viewport_height) : parent.height
                width: ((settings.AllowVideoPreviewOverlay === "Yes") && (overlay_exists === true)) ? (custom_viewport_width === 0 ? (height/3)*4 : custom_viewport_width) :  parent.width
                anchors.top: {
                    if(custom_viewport_y !== 0) return  parent.top;
                }
                anchors.left: {
                    if(custom_viewport_x !== 0) return  parent.left;
                }
                anchors.leftMargin: ((settings.AllowVideoPreviewOverlay === "Yes") && (overlay_exists === true)) ? custom_viewport_x : 0
                anchors.topMargin: ((settings.AllowVideoPreviewOverlay === "Yes") && (overlay_exists === true)) ? custom_viewport_y : 0
                anchors.horizontalCenter:{
                    if(custom_viewport_x === 0) return  parent.horizontalCenter;
                }
                anchors.verticalCenter:{
                    if(custom_viewport_y === 0) return parent.verticalCenter;
                }

                fillMode: ((settings.AllowVideoPreviewOverlay === "Yes") && (overlay_exists === true)) ? VideoOutput.Stretch : VideoOutput.PreserveAspectCrop
                muted: settings.AllowVideoPreviewAudio === "No"
                loops: MediaPlayer.Infinite
                autoPlay: true
            }

            // Scanlines
            Image {
                id: scanlines

                anchors.fill: parent
                source: "../assets/images/scanlines_v3.png"
                asynchronous: true
                opacity: 0.2
                visible: !iamsteam && (settings.ShowScanlines === "Yes")
            }

            Image {
                id: overlaycomponent
                property bool videoExists: game ? game.assets.videos.length : false

                source:{
                    if(videoExists && (overlay_exists === true)){
                            return "file://" + overlay_png_filename_fullpath;
                    }
                    else return "";
                }

                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                visible: ((settings.AllowVideoPreviewOverlay === "Yes") && (overlay_exists === true)) ? true : false
            }
        }
    }

    // Video
    Loader {
        id: videoPreviewLoader

        asynchronous: true
        anchors { fill: parent }
    }

    Rectangle{
        id:background
        anchors.fill: parent
        opacity: screenshot.opacity

        // Background (screenshot and/or fanart)
        Image {
            id: screenshot

            height: ((settings.AllowGameBackgroundOverlay === "Yes") && (overlay_exists === true)) ? (custom_viewport_height === 0 ? parent.height : custom_viewport_height) : parent.height
            width: ((settings.AllowGameBackgroundOverlay === "Yes") && (overlay_exists === true)) ? (custom_viewport_width === 0 ? (height/3)*4 : custom_viewport_width) :  parent.width
            anchors.top: {
                if(custom_viewport_y !== 0) return  parent.top;
            }
            anchors.left: {
                if(custom_viewport_x !== 0) return  parent.left;
            }
            anchors.leftMargin: ((settings.AllowGameBackgroundOverlay === "Yes") && (overlay_exists === true)) ? custom_viewport_x : 0
            anchors.topMargin: ((settings.AllowGameBackgroundOverlay === "Yes") && (overlay_exists === true)) ? custom_viewport_y : 0
            anchors.horizontalCenter:{
                if(custom_viewport_x === 0) return  parent.horizontalCenter;
            }
            anchors.verticalCenter:{
                if(custom_viewport_y === 0) return parent.verticalCenter;
            }

            asynchronous: true
            property int randoScreenshotNumber: {
                if (game && settings.GameRandomBackground === "Yes")
                    return Math.floor(Math.random() * game.assets.screenshotList.length);
                else
                    return 0;
            }
            property int randoFanartNumber: {
                if (game && settings.GameRandomBackground === "Yes")
                    return Math.floor(Math.random() * game.assets.backgroundList.length);
                else
                    return 0;
            }

            property var randoScreenshot: game ? game.assets.screenshotList[randoScreenshotNumber] : ""
            property var randoFanart: game ? game.assets.backgroundList[randoFanartNumber] : ""
            property var actualBackground: (settings.GameBackground === "Screenshot") ? randoScreenshot : Utils.fanArt(game) || randoFanart;
            source: actualBackground || ""

            fillMode: ((settings.AllowGameBackgroundOverlay === "Yes") && (overlay_exists === true)) ? Image.Stretch : Image.PreserveAspectCrop
            smooth: true
            Behavior on opacity { NumberAnimation { duration: 500 } }
            visible: !blurBG
        }
        // Scanlines (for screenshot/fanart only)
        Image {
            id: scanlines

            anchors.fill: parent
            source: "../assets/images/scanlines_v3.png"
            asynchronous: true
            opacity: 0.2
            visible: (!iamsteam && (settings.ShowScanlines === "Yes")) ? true : false
        }

        // Background overlay (for screenshot/fanart only)
        Image {
            id: overlayBackground
            source:{
                if(overlay_exists === true) return "file://" + overlay_png_filename_fullpath;
                else return "";
            }
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            visible: ((settings.AllowGameBackgroundOverlay === "Yes") && (overlay_exists === true)) ? true : false
        }

        FastBlur {
            anchors.fill: screenshot
            source: screenshot
            radius: 64
            opacity: screenshot.opacity
            Behavior on opacity { NumberAnimation { duration: 500 } }
            visible: blurBG
        }

    }

    // Clear logo
    Image {
        id: logo
        anchors {
            top: parent.top; //topMargin: vpx(70)
            left:{
                if (settings.GameLogoPosition === "Left") return parent.left;
            }
            leftMargin: (settings.GameLogoPosition === "Left") ? vpx(70) : 0
            right:{
                if (settings.GameLogoPosition === "Right") return parent.right;
            }
            rightMargin: (settings.GameLogoPosition === "Right") ? vpx(70) : 0
        }
        width: vpx(500)
        height: vpx(450) + header.height
        source: game ? Utils.logo(game) : ""
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        opacity: (content.currentIndex !== 0 || detailsScreen.opacity !== 0 || retroachievementsScreen.opacity !== 0) ? 0 : 1
        Behavior on opacity { NumberAnimation { duration: 200 } }
        z: (content.currentIndex == 0) ? 10 : -10
        visible: settings.GameLogo === "Show"
    }

    Image{
        id: alphaLogo
        anchors.top: parent.top
        anchors.right: parent.right
        width: parent.width/4
        height: parent.height/4

        //to alert when system is in beta
        source: "../assets/images/beta.png";
        //for the moment, just check if first core for this system still low
        visible: game.collections.get(0).getCoreCompatibilityAt(0) === "low" ? true : false
    }

    DropShadow {
        id: logoshadow

        anchors.fill: logo
        horizontalOffset: 0
        verticalOffset: 0
        radius: 8.0
        samples: 12
        color: "#000000"
        source: logo
        opacity: (content.currentIndex !== 0 || detailsScreen.opacity !== 0 || retroachievementsScreen.opacity !== 0) ? 0 : 0.4
        Behavior on opacity { NumberAnimation { duration: 200 } }
        visible: settings.GameLogo === "Show"
    }

    // Platform title
    Text {
        id: gametitle

        text: game.title

        anchors {
            top:    logo.top;
            left:   logo.left;
            right:  parent.right;
            bottom: logo.bottom
        }

        anchors {
            top: logo.top
            left:{
                if (settings.GameLogoPosition === "Left") return logo.left;
                else return parent.left;
            }
            right:{
                if (settings.GameLogoPosition === "Right") return logo.right;
                else return parent.right;
            }
            bottom: logo.bottom
        }
        color: theme.text
        font.family: titleFont.name
        font.pixelSize: vpx(80)
        font.bold: true
        horizontalAlignment: (settings.GameLogoPosition === "Left") ? Text.AlignHLeft : Text.AlignHRight
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        wrapMode: Text.WordWrap
        lineHeight: 0.8
        visible: logo.source === "" || settings.GameLogo === "Text only"
        opacity: (content.currentIndex !== 0 || detailsScreen.opacity !== 0) ? 0 : 1
    }

    // Gradient
    LinearGradient {
        id: bggradient
        visible: (demoLaunched !== true)
        width: parent.width
        height: parent.height/2
        start: Qt.point(0, 0)
        end: Qt.point(0, height*1.25) //updated to reduce gradient effect on background screenshot/fanart or video
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

    // Retroachievements screen
    Item {
    id: retroachievementsScreen
        
        anchors.fill: parent
        visible: opacity !== 0
        opacity: (content.currentIndex !== 0) ? 0 : retroachievementsOpacity
        Behavior on opacity { NumberAnimation { duration: 200 } }
        
        Rectangle {
            anchors.fill: parent
            color: theme.main
            opacity: 0.7
        }

        Item {
        id: retroachievements 

            anchors { 
                top: parent.top; topMargin: vpx(100)
                left: parent.left; leftMargin: vpx(70)
                right: parent.right; rightMargin: vpx(70)
            }
            height: vpx(484) - header.height

            GameAchievements {
            id: achievements

                anchors {
                    left: parent.left; leftMargin: vpx(30)
                    top: parent.top; bottom: parent.bottom; right: parent.right
                }
            }
			
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
                top: parent.top; topMargin: vpx(100)
                left: parent.left; leftMargin: vpx(70)
                right: parent.right; rightMargin: vpx(70)
            }
            height: vpx(450) - header.height

            Image {
                id: boxart

                source: Utils.boxArt(game);
                //width: vpx(350)
                height: parent.height
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                smooth: true
            }

            GameInfo {
                id: info

                anchors {
                    left: boxart.right; leftMargin: vpx(30)
                    top: parent.top; bottom: parent.bottom; right: parent.right
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

//        // Platform logo
//        Image {
//            id: logobg

//            anchors.fill: platformlogo
//            source: "../assets/images/gradient.png"
//            asynchronous: true
//            visible: false
//        }

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
//            sourceSize: vpx(25)
            smooth: true
            visible: ((settings.SystemLogo === "Show") || ((settings.SystemLogo === "Show if no overlay") && (overlay_exists !== true))) ? true : false
            asynchronous: true
        }

//        OpacityMask {
//            anchors.fill: logobg
//            source: logobg
//            maskSource: platformlogo
//        }

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

        Button {
            id: button1

            text: qsTr("Play game") + api.tr
            height: parent.height
            selected: (demoLaunched !== true) && ListView.isCurrentItem && menu.focus
            onHighlighted: { menu.currentIndex = ObjectModel.index; content.currentIndex = 0; }
            icon: api.launchedgame ? (api.launchedgame.path === game.path  ? "../assets/images/loading.png" : "../assets/images/icon_play.svg") : "../assets/images/icon_play.svg"
            iconRotation.running: api.launchedgame ? (api.launchedgame.path === game.path ? true : false) : false
            onActivated:
                if (selected) {
                    sfxAccept.play();
                    launchGame(game);
                } else {
                    sfxNav.play();
                    menu.currentIndex = ObjectModel.index;
                }
        }

        Button {
            id: button2

            icon: "../assets/images/icon_details.svg"
            height: parent.height
            selected: ListView.isCurrentItem && menu.focus
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
            id: button3

            property string buttonText: game && game.favorite ? qsTr("Unfavorite") + api.tr : qsTr("Add favorite") + api.tr
            //text: buttonText
            icon: favIcon
            height: parent.height
            selected: ListView.isCurrentItem && menu.focus
            onHighlighted: { menu.currentIndex = ObjectModel.index; content.currentIndex = 0; }
            onActivated:
                if (selected) {
                    sfxToggle.play();
                    game.favorite = !game.favorite;
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
            selected: ListView.isCurrentItem && menu.focus
            onHighlighted: { menu.currentIndex = ObjectModel.index; content.currentIndex = 0; }
            onActivated:
                if (selected)
                    previousScreen();
                else {
                    sfxNav.play(); 
                    menu.currentIndex = ObjectModel.index;
                }
        }

        Button {
            id: button5
            icon: readyForNeplay ? "../assets/images/multiplayer.svg" : "../assets/images/icon_cup.svg"
            text: readyForNeplay ? qsTr("Netplay") + api.tr : ""
            height: parent.height
            selected: ListView.isCurrentItem && menu.focus
            onHighlighted: { menu.currentIndex = ObjectModel.index; content.currentIndex = 0; }
            visible: readyForNeplay || (!readyForNeplay && (game.retroAchievementsCount !== 0)) ? true : false
            enabled : visible
            onActivated:{
                if (selected) {
                    sfxToggle.play();
                    if(readyForNeplay){
                        //to force focus & reload dialog
                        netplayRoomDialog.focus = false;
                        netplayRoomDialog.active = false;
                        netplayRoomDialog.game = game; //set game
                        netplayRoomDialog.active = true;
                        netplayRoomDialog.focus = true;
                    }
                    else if (game.retroAchievementsCount !== 0) showAchievements();
                }
                else {
                    sfxNav.play();
                    menu.currentIndex = ObjectModel.index;
                }
            }
        }

        Button { 
            id: button6
            icon: "../assets/images/icon_cup.svg"
            text: ""
            height: parent.height
			selected: ListView.isCurrentItem && menu.focus
            onHighlighted: { menu.currentIndex = ObjectModel.index; content.currentIndex = 0; }
            visible: ((game.retroAchievementsCount !== 0) && readyForNeplay) ? true : false
            enabled : visible
            onActivated:{
                if (selected) {
                    sfxToggle.play();
                    if (game.retroAchievementsCount !== 0) showAchievements();
                } else {
                    sfxNav.play();
                    menu.currentIndex = ObjectModel.index;
                }
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
            property bool selected: parent.focus
            focus: selected
            width: parent.width
            height: vpx(110) // to put media more at the bottom
            model: menuModel
            orientation: ListView.Horizontal
            spacing: vpx(10)
            keyNavigationWraps: true
            Keys.onLeftPressed: { 
                                    //console.log("Menu - Keys.onLeftPressed");
									sfxNav.play(); 
									do{	
										decrementCurrentIndex();
									}while(!currentItem.enabled);								
								}
            Keys.onRightPressed:{ 
                                    //console.log("Menu - Keys.onLeftPressed");
									sfxNav.play(); 
									do{	
										incrementCurrentIndex();
									}while(!currentItem.enabled);
								}
        }

        //media list
        HorizontalCollection {
            id: media
            visible: (demoLaunched !== true)
            width: root.width - vpx(70) - globalMargin
            height: ((root.width - globalMargin * 2) / 6.0) + vpx(60)
            title: qsTr("Media") + api.tr
            model: game ? mediaArray() : []
            delegate: MediaItem {
                id: mediadelegate

                width: (root.width - globalMargin * 2) / 6.0
                height: width
                selected: ListView.isCurrentItem && media.ListView.isCurrentItem
                mediaItem: modelData

                onHighlighted: {
                    sfxNav.play();
                    media.currentIndex = index;
                    content.currentIndex = media.ObjectModel.index;
                }

                onActivated: {
                    if (selected)
                        showMedia(index);
                    else
                    {
                        sfxNav.play();
                        media.currentIndex = index;
                        content.currentIndex = media.ObjectModel.index;
                    }
                }
            }

        }

        // More by publisher
        HorizontalCollection {
            id: list1
            visible: (demoLaunched !== true)
            property bool selected: ListView.isCurrentItem
            focus: selected
            width: root.width - vpx(70) - globalMargin
            height: itemHeight + vpx(60)
            itemWidth: (root.width - globalMargin * 2) / 4.0
            itemHeight: itemWidth * settings.WideRatio

            title: game ? qsTr("More games by") + api.tr + " " + game.publisher : ""
            search: publisherCollection
            onListHighlighted: { sfxNav.play(); content.currentIndex = list1.ObjectModel.index; }
        }

        // More in genre
        HorizontalCollection {
            id: list2
            visible: (demoLaunched !== true)
            property bool selected: ListView.isCurrentItem
            focus: selected
            width: root.width - vpx(70) - globalMargin
            height: itemHeight + vpx(60)
            itemWidth: (root.width - globalMargin * 2) / 8.0
            itemHeight: itemWidth / settings.TallRatio

            title: game ? qsTr("More games of") + " " + game.genreList[0].toLowerCase() + api.tr  : ""
            search: genreCollection
            onListHighlighted: { sfxNav.play(); content.currentIndex = list2.ObjectModel.index; }
        }

    }

    ListView {
        id: content

        anchors {
            left: parent.left; leftMargin: vpx(70)
            right: parent.right
            top: parent.top; topMargin: header.height
            bottom: parent.bottom; bottomMargin: vpx(150)
        }
        model: extrasModel
        focus: true
        spacing: vpx(30)
        header: Item { height: vpx(450) }

        snapMode: ListView.SnapToItem
        highlightMoveDuration: 100
        displayMarginEnd: 150
        cacheBuffer: 250
        onCurrentIndexChanged: {
            if (content.currentIndex === 0) {
                toggleVideo(true);
            } else {
                toggleVideo(false);
            }
        }
        keyNavigationWraps: true
        Keys.onUpPressed: { 
							sfxNav.play(); 
 							if(currentIndex !== 0)	
							{
								decrementCurrentIndex();
							}
							else //focus on retroachievements gridView if display
							{
								if((retroachievementsOpacity === 1) && (game.retroAchievementsCount !== 0)) 
								{
								   	menu.currentIndex = -1;
									achievements.index = 0;
									achievements.selected = true;
									achievements.updateDetails(0);
								}
								else  decrementCurrentIndex();
							}
						  }
        Keys.onDownPressed: { sfxNav.play(); incrementCurrentIndex() }
    }

    MediaView {
        id: mediaScreen

        anchors.fill: parent
        Behavior on opacity { NumberAnimation { duration: 100 } }
        visible: opacity !== 0

        mediaModel: mediaArray();
        mediaIndex: media.currentIndex !== -1 ? media.currentIndex : 0
        onClose: closeMedia();
    }

    // Input handling
    Keys.onPressed: {
        // Back
        if (api.keys.isCancel(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if (mediaScreen.visible)
                closeMedia();
            else
                previousScreen();
        }
        // Filters
        if (api.keys.isFilters(event) && !event.isAutoRepeat) {
            event.accepted = true;
            sfxAccept.play();
            game.favorite = !game.favorite;
        }

        // Next game
        if (api.keys.isNextPage(event) && !event.isAutoRepeat) {
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
        if (api.keys.isPrevPage(event) && !event.isAutoRepeat) {
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

    // Helpbar buttons
    ListModel {
        id: gameviewHelpModel

        ListElement {
            name: qsTr("Back")
            button: "cancel"
        }
        ListElement {
            name: qsTr("Toggle favorite")
            button: "filters"
        }
        ListElement {
            name: qsTr("Launch")
            button: "accept"
        }
    }

    onFocusChanged: {
        if (focus) {
            currentHelpbarModel = gameviewHelpModel;
            menu.focus = true;
            menu.currentIndex = 0;
        } 
	else {
            screenshot.opacity = 1;
            toggleVideo(false);
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
        //init overlays parameters
        root.getOverlaysParameters();
    }
}
