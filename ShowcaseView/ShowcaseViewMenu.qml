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

//
// Updated by Bozo the Geek for 'collections' features 26/08/2021
//

import QtQuick 2.12
import QtQuick.Layouts 1.12
import SortFilterProxyModel 0.2
import QtGraphicalEffects 1.12
import QtMultimedia 5.15
import QtQml.Models 2.12
import "../Global"
import "../GridView"
import "../Lists"
import "../utils.js" as Utils

FocusScope {
    id: root

    property string randoPub: (Utils.returnRandom(Utils.uniqueValuesArray('publisher')) || '')
    property string randoGenre: (Utils.returnRandom(Utils.uniqueValuesArray('genreList'))[0] || '').toLowerCase()

    // Pull in our custom lists and define
    ListAllGames    { id: listNone;        max: 0 }
    ListAllGames    { id: listAllGames;    max: settings.ShowcaseColumns }
    ListFavorites   { id: listFavorites;   max: settings.ShowcaseColumns }

	//Repeater to manage loading of lists dynamically and without limits in the future
	property int nbLoaderReady: 0
	Repeater{
		id: repeater
		model: 10 // 5 is the maximum of list loaded dynamically for the moment 
		//still to find a solution for "HorizontalCollection" loading dynamically
		//that's why we can't change the number dynamically for the moment
		//warning: index start from 0 but Colletions from 1
		delegate: 
		Loader {
			id: listLoader
			source: getListSourceFromIndex(index + 1) // get qml file to load from index of "settings.ShowcaseCollectionX"
			asynchronous: true
			property bool measuring: false
			onStatusChanged:{
				/*
				Available status:
				Loader.Null - the loader is inactive or no QML source has been set
				Loader.Ready - the QML source has been loaded
				Loader.Loading - the QML source is currently being loaded
				Loader.Error - an error occurred while loading the QML source
				*/
				if (listLoader.status === Loader.Loading) {
					if(!listLoader.measuring){
                        viewLoadingText = qsTr("Loading Collection") + " " + (index + 1) + " ...";
						console.time("listLoader - Collection " + (index + 1));
						listLoader.measuring = true;
					}
				}

				if (listLoader.status === Loader.Ready) {
					nbLoaderReady = nbLoaderReady + 1;
					let listType = api.memory.has("Collection " + (index + 1)) ? api.memory.get("Collection " + (index + 1)) : "";
					//console.log("listLoader.listType: ",listType);
                    viewLoadingText = qsTr("Loading Collection") + " " + (index + 1) + " - " + listType + " ...";
					if(listType.includes("My Collection") &&  (api.memory.get(listType + " - Collection name") !== null) &&
						(api.memory.get(listType + " - Collection name") !== ""))
					{
						listLoader.item.collectionName = api.memory.has(listType + " - Collection name") ? api.memory.get(listType + " - Collection name") : "";
						listLoader.item.filter = api.memory.has(listType + " - Name filter") ? api.memory.get(listType + " - Name filter") : "";
						listLoader.item.region = api.memory.has(listType + " - Region/Country filter") ? api.memory.get(listType + " - Region/Country filter") : "";
						listLoader.item.nb_players = api.memory.has(listType + " - Nb players") ? api.memory.get(listType + " - Nb players") : "1+";
						listLoader.item.rating = api.memory.has(listType + " - Rating") ? api.memory.get(listType + " - Rating") : "All";
						listLoader.item.genre = api.memory.has(listType + " - Genre filter") ? api.memory.get(listType + " - Genre filter") : "";
						listLoader.item.publisher = api.memory.has(listType + " - Publisher filter") ? api.memory.get(listType + " - Publisher filter") : "";
						listLoader.item.developer = api.memory.has(listType + " - Developer filter") ? api.memory.get(listType + " - Developer filter") : "";
						listLoader.item.system = api.memory.has(listType + " - System") ? api.memory.get(listType + " - System") : "";
						listLoader.item.filename = api.memory.has(listType + " - File name filter") ? api.memory.get(listType + " - File name filter") : "";
						listLoader.item.release = api.memory.has(listType + " - Release year filter") ? api.memory.get(listType + " - Release year filter") : "";
						listLoader.item.exclusion = api.memory.has(listType + " - Exclusion filter") ? api.memory.get(listType + " - Exclusion filter") : "";
						listLoader.item.favorite = api.memory.has(listType + " - Favorite") ? api.memory.get(listType + " - Favorite") : "No";
					}
					else
					{
						if (listType.includes("None")||(listType === "")||(listType === null)) listLoader.item.max = 0;
						else listLoader.item.max = settings.ShowcaseColumns;
					}
					
					setCollectionFromIndex((index+1));
					console.timeEnd("listLoader - Collection " + (index + 1));
					listLoader.measuring = false;
					if (nbLoaderReady >= repeater.count) {
						viewIsLoading = false;
					}
				}
			}
			active: true;
		}
    }	

    property var featuredCollection: listFavorites
	
	property var collection1
    property var collection2
    property var collection3
    property var collection4
    property var collection5
	property var collection6
    property var collection7
    property var collection8
    property var collection9
    property var collection10
	
	//Function to get the list type of a collection from index in main list of collections
	function getListTypeFromIndex(index)
	{
		let listType;
		//for existing pre-configured lists (keep hardcoded way for the 5 first collections to benefit default value predefined for this theme, for first launching)
		//console.log("index:",index);
		if(index <= 5)
		{
			switch (index) {
				case 1:
				  listType = settings.ShowcaseCollection1;
				  break;
				case 2:
				  listType = settings.ShowcaseCollection2;
				  break;
				case 3:
				  listType = settings.ShowcaseCollection3;
				  break;
				case 4:
				  listType = settings.ShowcaseCollection4;
				  break;
				case 5:
				  listType = settings.ShowcaseCollection5;
				  break;
			}
		}
		// for the potential other ones not "hardcoded" and to be more flexible for a future menu/view "Colletions"
		else
		{
			listType = api.memory.has("Collection " + index) ? api.memory.get("Collection " + index) : "None";
			//console.log("api.memory.get('Collection ' + index) = ",api.memory.get("Collection " + index));
		}
		if ((listType === "")||(typeof(listType) === undefined)) listType = "None";
		
		if (api.memory.has(listType + " - Collection name") && (listType !== "None")){
			var value = api.memory.get(listType + " - Collection name");
			listType  = ((value === "") || (value === null)) ? "None" : listType;
		}
		//console.log("listType: ",listType);
		//To manage types using index in collections type as "My Coleltions 1", "My Collections 2", etc...
		if(listType.includes("My Collection"))
		{
			listType = "My Collection";
		}
		return listType;
	}

	//Function to get the Thumbnail of a collection from index in main list of collections
	function getThumbnailFromIndex(index)
	{
		let thumbnail;
		//for existing pre-configured lists (keep hardcoded way for the 5 first collections to benefit default value predefined for this theme, for first launching)
		//console.log("index:",index);
		if(index <= 5)
		{
			switch (index) {
				case 1:
				  thumbnail = settings.ShowcaseCollection1_Thumbnail;
				  break;
				case 2:
				  thumbnail = settings.ShowcaseCollection2_Thumbnail;
				  break;
				case 3:
				  thumbnail = settings.ShowcaseCollection3_Thumbnail;
				  break;
				case 4:
				  thumbnail = settings.ShowcaseCollection4_Thumbnail;
				  break;
				case 5:
				  thumbnail = settings.ShowcaseCollection5_Thumbnail;
				  break;
			}
		}
		// for the potential other ones not "hardcoded" and to be more flexible for a future menu/view "Colletions"
		else
		{
			thumbnail = api.memory.has("Collection " + index + " - Thumbnail") ? api.memory.get("Collection " + index + " - Thumbnail") : "Wide"
		}
		//console.log("thumbnail: ",thumbnail);
		return thumbnail;
	}
	
	//Function to check if a list is requested (to improve performance)
	function getListSourceFromIndex(index) //index from 1 to...
	{
		let qmlFileToUse;
		let listType = getListTypeFromIndex(index);

		switch (listType) {
			case "AllGames":
				qmlFileToUse = "../Lists/ListAllGames.qml";
				break;
			case "Favorites":
				qmlFileToUse = "../Lists/ListFavorites.qml";
				break;
			case "Recently Played":
				qmlFileToUse = "../Lists/ListLastPlayed.qml";
				break;
			case "Most Played":
				qmlFileToUse = "../Lists/ListMostPlayed.qml";
				break;
			case "Recommended":
				qmlFileToUse = "../Lists/ListRecommended.qml";
				break;
			case "Top by Publisher":
				qmlFileToUse = "../Lists/ListPublisher.qml";
				break;
			case "Top by Genre":
				qmlFileToUse = "../Lists/ListGenre.qml";
				break;
			case "My Collection":
				qmlFileToUse = "../Lists/ListMyCollection.qml";
				break;
			case "None":
				qmlFileToUse = "../Lists/ListAllGames.qml";
				break;
			default:
				qmlFileToUse = "";
				break;
		}
		
		return qmlFileToUse;
	}

	//Function to set Collection Details from index in the main list of horizontal collection
    function setCollectionFromIndex(index) //index from 1 to... 5 for the moment (due to constraint to hardcode :-( )
	{
		var collectionType = getListTypeFromIndex(index);		
		var collectionThumbnail = getThumbnailFromIndex(index);	
		
        var collection = {
            enabled: true,
        };

        var width = root.width - globalMargin * 2;

        switch (collectionThumbnail) {
        case "Square":
            collection.itemWidth = (width / 6.0);
            collection.itemHeight = collection.itemWidth;
            break;
        case "Tall":
            collection.itemWidth = (width / 8.0);
            collection.itemHeight = collection.itemWidth / settings.TallRatio;
            break;
        case "Wide":
        default:
            collection.itemWidth = (width / 4.0);
            collection.itemHeight = collection.itemWidth * settings.WideRatio;
            break;

        }

        collection.height = collection.itemHeight + vpx(40) + globalMargin

        switch (collectionType) {
        case "None":
            collection.enabled = false;
            collection.height = 0;
            collection.search = listNone;
            break;
		default:
			collection.search = repeater.itemAt(index-1).item;
            break;
        }

        collection.title = collection.search.collection.name;
		
		//To change in the future : but for the moment it's blocked to 10 collections on main page
		switch (index) {
		case 1:
			collection1  = collection;
		break;
		case 2:
			collection2  = collection;
		break;
		case 3:
			collection3  = collection;
		break;
		case 4:
			collection4  = collection;
		break;
		case 5:
			collection5  = collection;
		break;
		case 6:
			collection6  = collection;
		break;
		case 7:
			collection7  = collection;
		break;
		case 8:
			collection8  = collection;
		break;
		case 9:
			collection9  = collection;
		break;
		case 10:
			collection10  = collection;
		break;
		}

    }

    property bool ftue: featuredCollection.games.count === 0

    function storeIndices(secondary) {
        storedHomePrimaryIndex = mainList.currentIndex;
        if (secondary)
            storedHomeSecondaryIndex = secondary;
    }

    Component.onDestruction: storeIndices();

    anchors.fill: parent

    //ScreenScraper regions
    ListModel {
        id: regionSSModel
        ListElement { region: "us" }
        ListElement { region: "wor"}
        ListElement { region: "eu" }
        ListElement { region: "wor"}
        ListElement { region: "jp"}
        ListElement { region: "wor"}
    }

    function getInitialRegionIndex(){
        for(var i = 0; i < regionSSModel.count; i++){
            if(settings.PreferedRegion === regionSSModel.get(i).region){
                return i;
            }
        }
        return 0; //eu by default
    }

    //header
    Item {
        id: header

        width: parent.width
        height: vpx(70)
        z: 10
        Image {
            id: logo

            width: vpx(parseInt(designs.ThemeLogoWidth))
            anchors { left: parent.left; leftMargin: vpx(20); top: parent.top; topMargin: vpx(20); }
            source: (designs.ThemeLogoSource === "Default") ? "../assets/images/logo_white.png" : ((designs.ThemeLogoSource === "Custom") ? "../assets/custom/logo.png" : "")
            sourceSize: Qt.size(parent.width, parent.height)
            fillMode: Image.PreserveAspectFit
            smooth: true
            asynchronous: true
            //anchors.verticalCenter: parent.verticalCenter
            visible: !ftueContainer.visible && (designs.ThemeLogoSource !== "No")
        }

        Rectangle {
            id: settingsbutton

            width: vpx(40)
            height: vpx(40)
            anchors {
                verticalCenter: parent.verticalCenter
                right: (settings.HideClock === "No" ? sysTime.left : parent.right); rightMargin: vpx(10)
            }
            color: focus ? theme.accent : "white"
            radius: height/2
            opacity: focus ? 1 : 0.2
            anchors {
                verticalCenter: parent.verticalCenter
                right: settingsButton.left; rightMargin: vpx(50)
            }
            onFocusChanged: {
                sfxNav.play()
                if (focus)
                    mainList.currentIndex = -1;
                else
                    mainList.currentIndex = 0;
            }

            Keys.onDownPressed: {
                mainList.focus = true;
                while (!mainList.currentItem.enabled) {
                    mainList.incrementCurrentIndex();
                }
            }
            Keys.onPressed: {
				if (!viewIsLoading){
					// Accept
					if (api.keys.isAccept(event) && !event.isAutoRepeat) {
						event.accepted = true;
						settingsScreen();
					}
					// Back
					if (api.keys.isCancel(event) && !event.isAutoRepeat) {
						event.accepted = true;
                        mainList.focus = true;
                        while (!mainList.currentItem.enabled) {
                            mainList.incrementCurrentIndex();
                        }
					}
				}
            }
            // Mouse/touch functionality
            MouseArea {
                anchors.fill: parent
                hoverEnabled: settings.MouseHover === "Yes"
                onEntered: settingsbutton.focus = true;
                onExited: settingsbutton.focus = false;
                onClicked: settingsScreen();
            }
        }

        Image {
            id: settingsicon

            width: height
            height: vpx(24)
            anchors.centerIn: settingsbutton
            smooth: true
            asynchronous: true
            source: "../assets/images/settingsicon.svg"
            opacity: root.focus ? 0.8 : 0.5
        }

        Text {
            id: sysTime

            function set() {
                sysTime.text = Qt.formatTime(new Date(), "hh:mm AP")
            }

            Timer {
                id: textTimer
                interval: 60000 // Run the timer every minute
                repeat: true
                running: true
                triggeredOnStart: true
                onTriggered: sysTime.set()
            }

            anchors {
                top: parent.top; bottom: parent.bottom
                right: parent.right; rightMargin: vpx(25)
            }
            color: "white"
            font.pixelSize: vpx(18)
            font.family: subtitleFont.name
            horizontalAlignment: Text.Right
            verticalAlignment: Text.AlignVCenter
            visible: settings.HideClock === "No"
        }
    }


    // Using an object model to build the main list using other lists
    ObjectModel {
        id: mainModel

        property var regionSSIndex : getInitialRegionIndex();

        function findObjectAndMove(object,newPosition){
            for(var i = 0; i < mainModel.count; i++){
                if(mainModel.get(i) === object){ //need to move it
                   //console.log("findObjectAndMove : ","move ",i," to ",newPosition);
                   mainModel.move(i, newPosition , 1);
                   return; //to exit immediately from function
                }
            }
        }

        function processPathExpression(pathExpression,systemSelected){
            pathExpression = pathExpression.replace("{region}",settings.PreferedRegion);
            pathExpression = pathExpression.replace("{shortname}",Utils.processPlatformName(systemSelected.shortName));
            return pathExpression
        }

        function processPathExpressionNoRegion(pathExpression,systemSelected){
            //to put region part as empty
            pathExpression = pathExpression.replace("{region}","");
            //to replace // by / if region is a directory
            pathExpression = pathExpression.replace("//","/");
            pathExpression = pathExpression.replace("{shortname}",Utils.processPlatformName(systemSelected.shortName));
            return pathExpression
        }


        function processPathExpressionScreenScraper(pathExpression,systemSelected,regionIndexUsed){
            pathExpression = pathExpression.replace("{screenscraper_region}",regionSSModel.get(regionIndexUsed).region);
            pathExpression = pathExpression.replace("{screenscraper_id}",systemSelected.screenScraperId);
            return pathExpression
        }



        Component.onCompleted: {
            //set position of Video Banner (id: ftueContainer)
            if(designs.VideoBannerPosition !== "No") findObjectAndMove(ftueContainer,parseInt(designs.VideoBannerPosition));
            //set position of Favorites Banner (id: featuredlist)
            if(designs.FavoritesBannerPosition !== "No") findObjectAndMove(featuredlist,parseInt(designs.FavoritesBannerPosition));
            //set position of Systems List (id: platformlist)
            if(designs.SystemsListPosition !== "No") findObjectAndMove(platformlist,parseInt(designs.SystemsListPosition));
            //set position of System Details (id: detailedlist)
            if(designs.SystemDetailsPosition !== "No") findObjectAndMove(detailedlist,parseInt(designs.SystemDetailsPosition));
        }

        //ftueContainer
        ListView{
            id: ftueContainer
            property bool selected : ListView.isCurrentItem

            visible: (ftue || (designs.FavoritesBannerPosition !== designs.VideoBannerPosition)) && (designs.VideoBannerPosition !== "No")  //if no favorites or not same position between video/favorites
            enabled: (designs.FavoritesBannerPosition === designs.VideoBannerPosition) && visible // we let selectable only if visible and video/favorites are linked by the same position on the screen.
            width: appWindow.width
            height: visible ? (appWindow.height * (parseFloat(designs.VideoBannerRatio)/100)) : 0
            opacity: focus ? 1 : 0.7
            //DEPREACETED, remove opacity rules
            /*opacity: {
                switch (mainList.currentIndex) {
                case 0:
                    return 1;
                case 1:
                    return 0.3;
                case 2:
                    return 0.1;
                case -1:
                    return 0.3;
                default:
                    return 0
                }
            }*/

            Behavior on opacity { PropertyAnimation { duration: 1000; easing.type: Easing.OutQuart; easing.amplitude: 2.0; easing.period: 1.5 } }

            //        Image {
            //            anchors.fill: parent
            //            source: "../assets/images/ftueBG01.jpeg"
            //            sourceSize { width: root.width; height: root.height}
            //            fillMode: Image.PreserveAspectCrop
            //            smooth: true
            //            asynchronous: true
            //        }

            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.5
            }

            Video {
                id: videocomponent

                anchors.fill: parent
                source: {
                    if(designs.VideoBannerSource === "Default"){
                        return "../assets/video/ftue.mp4"
                    }
                    else{
                        //unique url or path, no variable data for the moment
                        return designs.VideoBannerPathExpression;
                    }
                }
                fillMode: VideoOutput.PreserveAspectCrop
                muted: true
                loops: MediaPlayer.Infinite
                autoPlay: true

                OpacityAnimator {
                    target: videocomponent
                    from: 0;
                    to: 1;
                    duration: 1000;
                    running: true;
                }

            }

            Image {
                id: ftueLogo

                width: vpx(350)
                anchors { left: parent.left; leftMargin: globalMargin }
                source: (designs.VideoBannerLogoSource === "Default") ? "../assets/images/logo.png" : "" // no possibility to have video with other log for the moment
                sourceSize: Qt.size(parent.width, parent.height)
                fillMode: Image.PreserveAspectFit
                smooth: true
                asynchronous: true
                anchors.centerIn: parent
                visible: designs.VideoBannerLogoSource !== "No"
            }

            Text {
                text: qsTr("Try adding some favorite games") + api.tr

                anchors { bottom: parent.bottom; bottomMargin: vpx(15)
                          right: parent.right; rightMargin: vpx (15)
                    }
                width: contentWidth
                height: contentHeight
                color: theme.text
                font.family: subtitleFont.name
                font.pixelSize: vpx(16)
                opacity: 0.5
                visible: ftueContainer.focus && (designs.FavoritesBannerPosition === designs.VideoBannerPosition) //if same position, need to inform about favorites mechanism
            }
        }

		// Favorites list at top with screenshot/fanart/marquee and logos
        ListView {
            id: featuredlist

            property bool selected : ListView.isCurrentItem
            //focus: selected
            width: appWindow.width

            height: visible ? appWindow.height * (parseFloat(designs.FavoritesBannerRatio)/100) : 0
            visible: (designs.FavoritesBannerPosition === "No")  ? false : (designs.FavoritesBannerPosition === designs.VideoBannerPosition) && ftue ? false : true
            enabled: visible

            spacing: vpx(0)
            orientation: ListView.Horizontal
            clip: true
            preferredHighlightBegin: vpx(0)
            preferredHighlightEnd: parent.width
            highlightRangeMode: ListView.StrictlyEnforceRange
            //highlightMoveDuration: 200
            highlightMoveVelocity: -1
            snapMode: ListView.SnapOneItem
            keyNavigationWraps: true
            currentIndex: (storedHomePrimaryIndex == 0) ? storedHomeSecondaryIndex : 0
            Component.onCompleted: {
                positionViewAtIndex(currentIndex, ListView.Visible)
            }

            model: !ftue ? featuredCollection.games : 0
            delegate: featuredDelegate

            Component {
                id: featuredDelegate

                AnimatedImage {
                    id: background

                    property bool selected: ListView.isCurrentItem && featuredlist.focus
                    width: featuredlist.width
                    height: featuredlist.height
                    source: Utils.fanArt(modelData);
                    //sourceSize { width: featuredlist.width; height: featuredlist.height }
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true

                    onSelectedChanged: {
                        if (selected)
                            logoAnim.start()
                    }

                    Rectangle {

                        anchors.fill: parent
                        color: "black"
                        opacity: featuredlist.focus ? 0 : 0.5
                        Behavior on opacity { PropertyAnimation { duration: 150; easing.type: Easing.OutQuart; easing.amplitude: 2.0; easing.period: 1.5 } }
                    }

                    AnimatedImage {
                        id: specialLogo

                        width: parent.height - vpx(20)
                        height: width
                        source: (modelData.assets.marquee === "") ? Utils.logo(modelData) : ""
                        //source: Utils.logo(modelData)
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        //sourceSize: Qt.size(specialLogo.width, specialLogo.height)
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: featuredlist.focus ? 1 : 0.5

                        PropertyAnimation {
                            id: logoAnim;
                            target: specialLogo;
                            properties: "y";
                            from: specialLogo.y-vpx(50);
                            duration: 100
                        }
                    }

                    // Mouse/touch functionality
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: settings.MouseHover === "Yes"
                        onEntered: { sfxNav.play(); mainList.currentIndex = 0; }
                        onClicked: {
                            if (selected)
                                gameDetails(modelData);
                            else
                                mainList.currentIndex = 0;
                        }
                    }
                }
            }

            Row {
                id: blips

                anchors.horizontalCenter: parent.horizontalCenter
                anchors { bottom: parent.bottom; bottomMargin: vpx(20) }
                spacing: vpx(10)
                Repeater {
                    model: featuredlist.count
                    Rectangle {
                        width: vpx(10)
                        height: width
                        color: (featuredlist.currentIndex === index) && featuredlist.focus ? theme.accent : theme.text
                        radius: width/2
                        opacity: (featuredlist.currentIndex === index) ? 1 : 0.5
                    }
                }
            }

			// Timer to show the video
			Timer {
				id: favoriteAutomaticChangeTimer
				interval: 10000 //every 10s
				repeat: true
                running: (settings.ShowcaseChangeFavoriteDisplayAutomatically !== "No") ? true : false
                triggeredOnStart: false
				onTriggered: {
					if (featuredlist.count >= 2) featuredlist.incrementCurrentIndex();
				}
			}	

			// List specific input
            Keys.onLeftPressed: { sfxNav.play(); decrementCurrentIndex() }
            Keys.onRightPressed: { sfxNav.play(); incrementCurrentIndex() }
            Keys.onPressed: {
				if (!viewIsLoading){
	                // Accept
	                if (api.keys.isAccept(event) && !event.isAutoRepeat) {
	                    event.accepted = true;
	                    storedHomeSecondaryIndex = featuredlist.currentIndex;
	                    if (!ftue)
	                        gameDetails(featuredCollection.currentGame(currentIndex));
                    }
				}
            }
        }

        // Collections list with systems
        ListView {
            id: platformlist

            property bool selected : ListView.isCurrentItem
            property int myIndex: ObjectModel.index
            width: appWindow.width

            height: designs.SystemsListPosition !== "No" ? appWindow.height * (parseFloat(designs.SystemsListRatio)/100) : 0
            visible: designs.SystemsListPosition !== "No" ? true : false
            enabled: visible

            anchors {
                left: parent.left;
                right: parent.right;
            }
            spacing: vpx(12)
            orientation: ListView.Horizontal
            preferredHighlightBegin: vpx(0)
            preferredHighlightEnd: parent.width - vpx(60)
            highlightRangeMode: ListView.ApplyRange
            snapMode: ListView.SnapOneItem
            highlightMoveDuration: 100
            keyNavigationWraps: true

            property int savedIndex: currentCollectionIndex
            onFocusChanged: {
                if (focus)
                    currentIndex = savedIndex;
                else {
                    savedIndex = currentIndex;
                    currentIndex = -1;
                }
                if(!focus){
                    if(designs.SystemMusicSource !== "No") playMusic.stop();
                }
            }

            Component.onCompleted: positionViewAtIndex(savedIndex, ListView.End)

            model: api.collections//Utils.reorderCollection(api.collections);

            delegate: Rectangle {
                id:rectangleLogo
                property bool selected: ListView.isCurrentItem
                width: platformlist.width / parseFloat(designs.NbSystemLogos)
                height: platformlist.height
                color: "transparent"
                property string shortName: modelData.shortName
                Image {
                    id: systemBackground
                    visible: (designs.SystemsListBackground !== "No") ? true : false
                    height: rectangleLogo.height
                    width: rectangleLogo.width
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    smooth: true
                    opacity: 1
                    z:-1
                    source:{
                        if(designs.SystemsListBackground === "Custom"){
                            // for {region} & {shortname} tags
                            return mainModel.processPathExpression(designs.SystemsListBackgroundPathExpression, modelData)
                        }
                        else return "";
                    }
                }


                onSelectedChanged: {
                    //console.log("selected : ",selected)
                    if(selected && (designs.SystemMusicSource !== "No")){
                        if(activeFocus && focus){
                           if (modelData.shortName !=="imageviewer") playMusic.play();
                        }
                        else{
                            if (modelData.shortName !=="imageviewer") playMusic.stop();
                        }
                    }
                    else{
                        if (modelData.shortName !=="imageviewer") playMusic.stop();
                    }
                }

                onActiveFocusChanged: {
                    console.log("Focus changed to " + focus)
                    console.log("Active Focus changed to " + activeFocus)
                    if(selected && (designs.SystemMusicSource !== "No")){
                        if(activeFocus && focus){
                           if (modelData.shortName !=="imageviewer") playMusic.play();
                        }
                        else{
                            if (modelData.shortName !=="imageviewer") playMusic.stop();
                        }
                    }
                    else{
                        if (modelData.shortName !=="imageviewer") playMusic.stop();
                    }
                }

                Audio {
                    id: playMusic
                    loops: Audio.Infinite
                    source: {
                        if (designs.SystemMusicSource === "Custom") {
                            if (modelData.shortName !=="imageviewer"){
                                return mainModel.processPathExpression(designs.SystemMusicPathExpression,modelData)
                            }
                            else return "";
                        }
                        else if(designs.SystemMusicSource !== "No") {
                            return "";
                        }
                        else return "";
                    }
                }

                Image {
                    id: collectionlogo
                    height: parent.height * (parseFloat(designs.SystemLogoRatio)/100)
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: {
                        if (designs.SystemLogoSource === "Custom"){
                            // Able to manage {region} & {shortname} tags
                            var result = mainModel.processPathExpression(designs.SystemLogoPathExpression,modelData)
                            return result;
                        }
                        else if(designs.SystemLogoSource !== "No"){
                            if(settings.SystemLogoStyle === "White")
                            {
                                return "../assets/images/logospng/" + Utils.processPlatformName(modelData.shortName) + ".png";
                            }
                            else
                            {
                                return "../assets/images/logospng/" + Utils.processPlatformName(modelData.shortName) + "_" + settings.SystemLogoStyle.toLowerCase() + ".png";
                            }
                        }
                    }                      
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    smooth: true
                    opacity: selected ? 1 : (designs.NbSystemLogos === "1" ? 0.0 : 0.3)
                    scale: selected ? 0.9 : 0.8
                    Behavior on scale { NumberAnimation { duration: 100 } }
                    onStatusChanged: {
                        //Image.Null - no image has been set
                        //Image.Ready - the image has been loaded
                        //Image.Loading - the image is currently being loaded
                        //Image.Error - an error occurred while loading the image
                        //console.log('Loaded: onStatusChanged Image source', source);
                        //console.log('Loaded: onStatusChanged Image status', status);
                        //console.log('Loaded: onStatusChanged sourceSize =', sourceSize);
                        //console.log('Loaded: onStatusChanged sourceSize.height =', sourceSize.height);
                        if (status === Image.Ready) {
                            //OK do nothing, loading ok, image exists
                        }
                        else if (status === Image.Error){
                            //change source in case of error with custom logo
                            if (designs.SystemLogoSource !== "Default"){
                                //if custom logo, we are trying to load without region
                                source = mainModel.processPathExpressionNoRegion(designs.SystemLogoPathExpression,modelData)
                            }
                        }
                    }
                    Image{
                        id: betaLogo
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        width: parent.width/2
                        height: parent.height/2

                        //to alert when system is in beta
                        source: "../assets/images/beta-round.png";
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        smooth: true
                        scale: selected ? 0.9 : 0.8
                        //for the moment, just check if first core for this system still low
                        visible: modelData.getCoreCompatibilityAt(0) === "low" ? true : false
                    }
                }

                Text {
                    id: title
                    text: {
                        if(modelData.name === "Screenshots")
                            return (modelData.games.count + ((modelData.games.count > 1) ? " " + qsTr("screenshots") + api.tr : " " + qsTr("screenshot") + api.tr));
                        else
                            return (modelData.games.count + ((modelData.games.count > 1) ? " " + qsTr("games") + api.tr : " " + qsTr("game") + api.tr));
                    }
                    color: theme.text
                    font {
                        family: subtitleFont.name
                        pixelSize: vpx(12)
                        bold: true
                    }

                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    anchors.top: collectionlogo.bottom

                    width: parent.width

                    opacity: designs.NbSystemLogos === "1" ?  0.0 : 0.2
                    visible: settings.AlwaysShowTitles === "Yes" || selected
                }

                Text {
                    id: platformname

                    text: modelData.name
                    anchors { fill: parent; margins: vpx(10) }
                    color: theme.text
                    opacity: selected ? 1 : 0.2
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                    font.pixelSize: vpx(18)
                    font.family: subtitleFont.name
                    font.bold: true
                    style: Text.Outline; styleColor: theme.main
                    visible: collectionlogo.status === Image.Error && (designs.NbSystemLogos === "1" ? selected : true)
                    anchors.centerIn: parent
                    elide: Text.ElideRight
                    wrapMode: Text.WordWrap
                    lineHeight: 0.8
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                // Mouse/touch functionality
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: settings.MouseHover === "Yes"
                    onEntered: { sfxNav.play(); mainList.currentIndex = platformlist.ObjectModel.index; platformlist.savedIndex = index; platformlist.currentIndex = index; }
                    onExited: {}
                    onClicked: {
                        if (selected)
                        {
                            currentCollectionIndex = index;
                            softwareScreen();
                        } else {
                            mainList.currentIndex = platformlist.ObjectModel.index;
                            platformlist.currentIndex = index;
                        }

                    }
                }
            }

            // List specific input
            Keys.onLeftPressed: { sfxNav.play(); decrementCurrentIndex() }
            Keys.onRightPressed: { sfxNav.play(); incrementCurrentIndex() }
            Keys.onPressed: {
				if (!viewIsLoading){
					// Accept
					if (api.keys.isAccept(event) && !event.isAutoRepeat) {
						event.accepted = true;
						currentCollectionIndex = platformlist.currentIndex;
						softwareScreen();
					}
				}
            }
        }

        // Details/Description list by system
        ListView {
            id: detailedlist
            width: appWindow.width
            height: designs.SystemDetailsPosition !== "No" ? appWindow.height * (parseFloat(designs.SystemDetailsRatio)/100) : 0
            visible: designs.SystemDetailsPosition !== "No" ? true : false
            enabled: false //not selectable

            anchors {
                left: parent.left; leftMargin: globalMargin
                right: parent.right; rightMargin: globalMargin
            }

            spacing: vpx(12)
            orientation: ListView.Horizontal
            preferredHighlightBegin: vpx(0)
            preferredHighlightEnd: parent.width - vpx(60)
            highlightRangeMode: ListView.ApplyRange
            snapMode: ListView.SnapOneItem
            highlightMoveDuration: 100
            keyNavigationWraps: true
            currentIndex: platformlist.currentIndex
            Component.onCompleted: {}
            model: api.collections//Utils.reorderCollection(api.collections);

            delegate: Rectangle {
                width: detailedlist.width
                height: detailedlist.height
                color: "transparent"
                property string shortName: modelData.shortName

                Image {
                    id: detailsBackground
                    visible: designs.SystemDetailsBackground !== "No" ? true : false
                    anchors.centerIn: parent
                    anchors.margins: 0
                    width: appWindow.width
                    height: designs.SystemDetailsPosition !== "No" ? appWindow.height * (parseFloat(designs.SystemDetailsRatio)/100) : 0
                    property var regionIndexUsed: mainModel.regionSSIndex
                    source: {
                        //for test purpose, need to do new parameters using prefix and sufix in path
                        if(designs.SystemDetailsBackground === "Custom"){
                            var pathExpression;
                            //process path/url for system/region selected if needed
                            pathExpression = mainModel.processPathExpression(designs.SystemDetailsBackgroundPathExpression, modelData);
                            //process path/url for screenscraper parameters if needed
                            return mainModel.processPathExpressionScreenScraper(pathExpression, modelData,regionIndexUsed);
                            //still to study how to manage case modelData.screenScraperId ==="0" -> screenshots case
                        }
                        else if(designs.SystemsListBackground !== "No") {
                            return ""; //RFU
                        }
                        else return ""; // N/A
                    }
                    fillMode: Image.Stretch
                    asynchronous: true
                    smooth: true
                    opacity: 1
                    onStatusChanged: {
                        //Image.Null - no image has been set
                        //Image.Ready - the image has been loaded
                        //Image.Loading - the image is currently being loaded
                        //Image.Error - an error occurred while loading the image
                        //console.log('Loaded: onStatusChanged Image source', source);
                        //console.log('Loaded: onStatusChanged Image status', status);
                        //console.log('Loaded: onStatusChanged sourceSize =', sourceSize);
                        //console.log('Loaded: onStatusChanged sourceSize.height =', sourceSize.height);
                        if (status === Image.Ready) {
                            //OK do nothing, loading ok, image exists
                        }
                        else if (status === Image.Error){
                            if(regionIndexUsed < regionSSModel.count-1){
                                regionIndexUsed = regionIndexUsed + 1;
                            }
                            else{
                                regionIndexUsed = 0;
                            }
                            if(regionSSModel.get(regionIndexUsed).region !== settings.PreferedRegion){
                                var pathExpression;
                                //process path/url for system/region selected if needed
                                pathExpression = mainModel.processPathExpression(designs.SystemDetailsBackgroundPathExpression, modelData);
                                //process path/url for screenscraper parameters if needed
                                source = mainModel.processPathExpressionScreenScraper(pathExpression, modelData,regionIndexUsed);
                                //console.log("new tentative to download media from this url: ", "https://www.screenscraper.fr/image.php?plateformid=" + modelData.screenScraperId + "&media=background&region=" + regionSSModel.get(regionIndexUsed).region + "&num=&version=&maxwidth=640&maxheight=");
                                //change source in case of error
                                //source = "https://www.screenscraper.fr/image.php?plateformid=" + modelData.screenScraperId + "&media=background&region=" + regionSSModel.get(regionIndexUsed).region + "&num=&version=&maxwidth=640&maxheight="
                            }

                        }
                    }
                }

                //RFU
                /*Image {
                    id: detailsHardware3DCasePicture
                    anchors.left : parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: vpx(15)
                    height: parent.height
                    width: parent.width / 4
                    property var regionIndexUsed: mainModel.regionSSIndex
                    source: {
                        if(designs.SystemDetailsSource === "ScreenScraper"){
                            if(modelData.screenScraperId !=="0"){
                                return "https://www.screenscraper.fr/image.php?plateformid=" + modelData.screenScraperId + "&media=BoitierConsole3D&region=" + settings.PreferedRegion + "&num=&version=&maxwidth=640&maxheight=";
                            }
                            else return "";
                        }
                        else //to do for other cases
                        {
                            return "";
                        }
                    }
                    //sourceSize: Qt.size(collectionlogo.width, collectionlogo.height)
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    smooth: true
                    //opacity: selected ? 1 : (designs.NbSystemLogos === "1" ? 0.0 : 0.3)
                    //scale: selected ? 0.9 : 0.8
                    //Behavior on scale { NumberAnimation { duration: 100 } }
                    onStatusChanged: {
                        //Image.Null - no image has been set
                        //Image.Ready - the image has been loaded
                        //Image.Loading - the image is currently being loaded
                        //Image.Error - an error occurred while loading the image
                        //console.log('Loaded: onStatusChanged Image source', source);
                        //console.log('Loaded: onStatusChanged Image status', status);
                        //console.log('Loaded: onStatusChanged sourceSize =', sourceSize);
                        //console.log('Loaded: onStatusChanged sourceSize.height =', sourceSize.height);
                        if (status === Image.Ready) {
                            //OK do nothing, loading ok, image exists
                        }
                        else if (status === Image.Error){
                            if(regionIndexUsed < regionSSModel.count-1){
                                regionIndexUsed = regionIndexUsed + 1;
                            }
                            else{
                                regionIndexUsed = 0;
                            }
                            if(regionSSModel.get(regionIndexUsed).region !== settings.PreferedRegion){
                                console.log("new tentative to download media from this url: ", "https://www.screenscraper.fr/image.php?plateformid=" + modelData.screenScraperId + "&media=BoitierConsole3D&region=" + regionSSModel.get(regionIndexUsed).region + "&num=&version=&maxwidth=640&maxheight=");
                                //change source in case of error
                                source = "https://www.screenscraper.fr/image.php?plateformid=" + modelData.screenScraperId + "&media=BoitierConsole3D&region=" + regionSSModel.get(regionIndexUsed).region + "&num=&version=&maxwidth=640&maxheight="
                            }
                        }
                    }
                }*/

                Image {
                    id: detailsHardwarePicture

                    anchors.left : parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: vpx(5)
                    height: vpx(parent.height - 5*2)
                    width: parent.width / 3
                    property var regionIndexUsed: mainModel.regionSSIndex
                    source: {
                        if(designs.SystemDetailsHardware === "Custom"){
                            var pathExpression;
                            //process path/url for system/region selected if needed
                            pathExpression = mainModel.processPathExpression(designs.SystemDetailsHardwarePathExpression, modelData);
                            //process path/url for screenscraper parameters if needed
                            return mainModel.processPathExpressionScreenScraper(pathExpression, modelData,regionIndexUsed);
                            //still to study how to manage case modelData.screenScraperId ==="0" -> screenshots case
                        }
                        else if(designs.SystemDetailsHardware !== "No") {
                            return ""; //RFU
                        }
                        else return ""; // N/A
                    }
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    smooth: true
                    onStatusChanged: {
                        //Image.Null - no image has been set
                        //Image.Ready - the image has been loaded
                        //Image.Loading - the image is currently being loaded
                        //Image.Error - an error occurred while loading the image
                        //console.log('Loaded: onStatusChanged Image source', source);
                        //console.log('Loaded: onStatusChanged Image status', status);
                        //console.log('Loaded: onStatusChanged sourceSize =', sourceSize);
                        //console.log('Loaded: onStatusChanged sourceSize.height =', sourceSize.height);
                        if (status === Image.Ready) {
                            //OK do nothing, loading ok, image exists
                        }
                        else if (status === Image.Error){
                            if(regionIndexUsed < regionSSModel.count-1){
                                regionIndexUsed = regionIndexUsed + 1;
                            }
                            else{
                                regionIndexUsed = 0;
                            }
                            if(regionSSModel.get(regionIndexUsed).region !== settings.PreferedRegion){
                                var pathExpression;
                                //process path/url for system/region selected if needed
                                pathExpression = mainModel.processPathExpression(designs.SystemDetailsHardwarePathExpression, modelData);
                                //process path/url for screenscraper parameters if needed
                                source = pmainModel.rocessPathExpressionScreenScraper(pathExpression, modelData,regionIndexUsed);
                                //still to study how to manage case modelData.screenScraperId ==="0" -> screenshots case
                                //console.log("new tentative to download media from this url: ", "https://www.screenscraper.fr/image.php?plateformid=" + modelData.screenScraperId + "&media=photo&region=" + regionSSModel.get(regionIndexUsed).region + "&num=&version=&maxwidth=640&maxheight=");
                                //change source in case of error
                                //source = "https://www.screenscraper.fr/image.php?plateformid=" + modelData.screenScraperId + "&media=photo&region=" + regionSSModel.get(regionIndexUsed).region + "&num=&version=&maxwidth=640&maxheight="
                            }

                        }
                    }
                }

                //RFU
/*                Text {
                    id: detailsDescription

                    //for test purpose
                    text: modelData.name

                    //anchors { fill: parent; margins: vpx(10) }

                    anchors.left : detailsHardwarePicture.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: vpx(15)
                    height: parent.height
                    width: parent.width / 3

                    color: theme.text
                    font.pixelSize: vpx(18)
                    font.family: subtitleFont.name
                    font.bold: true
                    style: Text.Outline; styleColor: theme.main

                    elide: Text.ElideRight
                    wrapMode: Text.WordWrap
                    lineHeight: 0.8
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: true
                }
*/

                Video{
                    id: detailsVideo

                    anchors.left : detailsHardwarePicture.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: vpx(5)
                    height: vpx(parent.height - 5*2)
                    width: parent.width / 3

                    property var regionIndexUsed: mainModel.regionSSIndex

                    source:{
                        if(designs.SystemDetailsVideo === "Custom"){
                            var pathExpression;
                            //process path/url for system/region selected if needed
                            pathExpression = mainModel.processPathExpression(designs.SystemDetailsVideoPathExpression, modelData);
                            //process path/url for screenscraper parameters if needed
                            return mainModel.processPathExpressionScreenScraper(pathExpression, modelData,regionIndexUsed);
                            //still to study how to manage case modelData.screenScraperId ==="0" -> screenshots case
                        }
                        else if(designs.SystemDetailsHardware !== "No") {
                            return ""; //RFU
                        }
                        else return ""; // N/A
                    }
                    fillMode: VideoOutput.PreserveAspectFit
                    muted: true
                    loops: MediaPlayer.Infinite
                    autoPlay: true

                    OpacityAnimator {
                        target: detailsVideo
                        from: 0;
                        to: 1;
                        duration: 1000;
                        running: true;
                    }
                }

                Image {
                    id: detailsControllerPicture
                    anchors.left : detailsVideo.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: vpx(5)
                    height: vpx(parent.height - 5*2)
                    width: parent.width / 3
                    property var regionIndexUsed: mainModel.regionSSIndex

                    source: {
                        if(designs.SystemDetailsController === "Custom"){
                            var pathExpression;
                            //process path/url for system/region selected if needed
                            pathExpression = mainModel.processPathExpression(designs.SystemDetailsControllerPathExpression, modelData);
                            //process path/url for screenscraper parameters if needed
                            return mainModel.processPathExpressionScreenScraper(pathExpression, modelData,regionIndexUsed);
                            //still to study how to manage case modelData.screenScraperId ==="0" -> screenshots case
                            //return "https://www.screenscraper.fr/image.php?plateformid=" + modelData.screenScraperId + "&media=controller&region=" + settings.PreferedRegion + "&num=&version=&maxwidth=640&maxheight=";

                        }
                        else if(designs.SystemDetailsHardware !== "No") {
                            return ""; //RFU
                        }
                        else return ""; // N/A
                    }
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    smooth: true
                    onStatusChanged: {
                        //Image.Null - no image has been set
                        //Image.Ready - the image has been loaded
                        //Image.Loading - the image is currently being loaded
                        //Image.Error - an error occurred while loading the image
                        //console.log('Loaded: onStatusChanged Image source', source);
                        //console.log('Loaded: onStatusChanged Image status', status);
                        //console.log('Loaded: onStatusChanged sourceSize =', sourceSize);
                        //console.log('Loaded: onStatusChanged sourceSize.height =', sourceSize.height);
                        if (status === Image.Ready) {
                            //OK do nothing, loading ok, image exists
                        }
                        else if (status === Image.Error){
                            if(regionIndexUsed < regionSSModel.count-1){
                                regionIndexUsed = regionIndexUsed + 1;
                            }
                            else{
                                regionIndexUsed = 0;
                            }
                            if(regionSSModel.get(regionIndexUsed).region !== settings.PreferedRegion){
                                var pathExpression;
                                //process path/url for system/region selected if needed
                                pathExpression = mainModel.processPathExpression(designs.SystemDetailsControllerPathExpression, modelData);
                                //process path/url for screenscraper parameters if needed
                                source = mainModel.processPathExpressionScreenScraper(pathExpression, modelData,regionIndexUsed);
                                //still to study how to manage case modelData.screenScraperId ==="0" -> screenshots case
                                //console.log("new tentative to download media from this url: ", "https://www.screenscraper.fr/image.php?plateformid=" + modelData.screenScraperId + "&media=controller&region=" + regionSSModel.get(regionIndexUsed).region + "&num=&version=&maxwidth=640&maxheight=");
                                //change source in case of error
                                //source = "https://www.screenscraper.fr/image.php?plateformid=" + modelData.screenScraperId + "&media=controller&region=" + regionSSModel.get(regionIndexUsed).region + "&num=&version=&maxwidth=640&maxheight="
                            }

                        }
                    }
                }
            }
        }

        //first list
        HorizontalCollection {
            id: list1
            property bool selected: ListView.isCurrentItem
            property var currentList: list1
            property var collection: collection1

            enabled: collection.enabled
            visible: collection.enabled

            height: collection.height

            itemWidth: collection.itemWidth
            itemHeight: collection.itemHeight

            title: {
				//console.log("collection.title:",collection.title);
				return collection.title;
			}
            search: collection.search

            focus: selected
            width: root.width - globalMargin * 2
            x: globalMargin - vpx(8)

            savedIndex: (storedHomePrimaryIndex === currentList.ObjectModel.index) ? storedHomeSecondaryIndex : 0

            onActivateSelected: {
				videoToStop = true;
				storedHomeSecondaryIndex = currentIndex;
			}
            onActivate: { if (!selected) { mainList.currentIndex = currentList.ObjectModel.index; } }
            onListHighlighted: { sfxNav.play(); mainList.currentIndex = currentList.ObjectModel.index; }
        }

		//second list
        HorizontalCollection {
            id: list2
            property bool selected: ListView.isCurrentItem
            property var currentList: list2
            property var collection: collection2

            enabled: collection.enabled
            visible: collection.enabled

            height: collection.height

            itemWidth: collection.itemWidth
            itemHeight: collection.itemHeight

            title: collection.title
            search: collection.search

            focus: selected
            width: root.width - globalMargin * 2
            x: globalMargin - vpx(8)

            savedIndex: (storedHomePrimaryIndex === currentList.ObjectModel.index) ? storedHomeSecondaryIndex : 0

            onActivateSelected: {
				videoToStop = true;
				storedHomeSecondaryIndex = currentIndex;
			}
            onActivate: { if (!selected) { mainList.currentIndex = currentList.ObjectModel.index; } }
            onListHighlighted: { sfxNav.play(); mainList.currentIndex = currentList.ObjectModel.index; }
        }

		//third list
        HorizontalCollection {
            id: list3
            property bool selected: ListView.isCurrentItem
            property var currentList: list3
            property var collection: collection3

            enabled: collection.enabled
            visible: collection.enabled

            height: collection.height

            itemWidth: collection.itemWidth
            itemHeight: collection.itemHeight

            title: collection.title
            search: collection.search

            focus: selected
            width: root.width - globalMargin * 2
            x: globalMargin - vpx(8)

            savedIndex: (storedHomePrimaryIndex === currentList.ObjectModel.index) ? storedHomeSecondaryIndex : 0

            onActivateSelected: {
				videoToStop = true;
				storedHomeSecondaryIndex = currentIndex;
			}
            onActivate: { if (!selected) { mainList.currentIndex = currentList.ObjectModel.index; } }
            onListHighlighted: { sfxNav.play(); mainList.currentIndex = currentList.ObjectModel.index; }
        }

		//fourth list
        HorizontalCollection {
            id: list4
            property bool selected: ListView.isCurrentItem
            property var currentList: list4
            property var collection: collection4

            enabled: collection.enabled
            visible: collection.enabled

            height: collection.height

            itemWidth: collection.itemWidth
            itemHeight: collection.itemHeight

            title: collection.title
            search: collection.search

            focus: selected
            width: root.width - globalMargin * 2
            x: globalMargin - vpx(8)

            savedIndex: (storedHomePrimaryIndex === currentList.ObjectModel.index) ? storedHomeSecondaryIndex : 0

            onActivateSelected: {
				videoToStop = true;
				storedHomeSecondaryIndex = currentIndex;
			}
            onActivate: { if (!selected) { mainList.currentIndex = currentList.ObjectModel.index; } }
            onListHighlighted: { sfxNav.play(); mainList.currentIndex = currentList.ObjectModel.index; }
        }

		//fifth list
        HorizontalCollection {
            id: list5
            property bool selected: ListView.isCurrentItem
            property var currentList: list5
            property var collection: collection5

            enabled: collection.enabled
            visible: collection.enabled

            height: collection.height

            itemWidth: collection.itemWidth
            itemHeight: collection.itemHeight

            title: collection.title
            search: collection.search

            focus: selected
            width: root.width - globalMargin * 2
            x: globalMargin - vpx(8)

            savedIndex: (storedHomePrimaryIndex === currentList.ObjectModel.index) ? storedHomeSecondaryIndex : 0

            onActivateSelected: {
				videoToStop = true;
				storedHomeSecondaryIndex = currentIndex;
			}
            onActivate: { if (!selected) { mainList.currentIndex = currentList.ObjectModel.index; } }
            onListHighlighted: { sfxNav.play(); mainList.currentIndex = currentList.ObjectModel.index; }
        }

		//sixth list
        HorizontalCollection {
            id: list6
            property bool selected: ListView.isCurrentItem
            property var currentList: list6
            property var collection: collection6

            enabled: collection.enabled
            visible: collection.enabled

            height: collection.height

            itemWidth: collection.itemWidth
            itemHeight: collection.itemHeight

            title: collection.title
            search: collection.search

            focus: selected
            width: root.width - globalMargin * 2
            x: globalMargin - vpx(8)

            savedIndex: (storedHomePrimaryIndex === currentList.ObjectModel.index) ? storedHomeSecondaryIndex : 0

            onActivateSelected: {
				videoToStop = true;
				storedHomeSecondaryIndex = currentIndex;
			}
            onActivate: { if (!selected) { mainList.currentIndex = currentList.ObjectModel.index; } }
            onListHighlighted: { sfxNav.play(); mainList.currentIndex = currentList.ObjectModel.index; }
        }

		//seventh list
        HorizontalCollection {
            id: list7
            property bool selected: ListView.isCurrentItem
            property var currentList: list7
            property var collection: collection7

            enabled: collection.enabled
            visible: collection.enabled

            height: collection.height

            itemWidth: collection.itemWidth
            itemHeight: collection.itemHeight

            title: collection.title
            search: collection.search

            focus: selected
            width: root.width - globalMargin * 2
            x: globalMargin - vpx(8)

            savedIndex: (storedHomePrimaryIndex === currentList.ObjectModel.index) ? storedHomeSecondaryIndex : 0

            onActivateSelected: {
				videoToStop = true;
				storedHomeSecondaryIndex = currentIndex;
			}
            onActivate: { if (!selected) { mainList.currentIndex = currentList.ObjectModel.index; } }
            onListHighlighted: { sfxNav.play(); mainList.currentIndex = currentList.ObjectModel.index; }
        }

		//eighth list
        HorizontalCollection {
            id: list8
            property bool selected: ListView.isCurrentItem
            property var currentList: list8
            property var collection: collection8

            enabled: collection.enabled
            visible: collection.enabled

            height: collection.height

            itemWidth: collection.itemWidth
            itemHeight: collection.itemHeight

            title: collection.title
            search: collection.search

            focus: selected
            width: root.width - globalMargin * 2
            x: globalMargin - vpx(8)

            savedIndex: (storedHomePrimaryIndex === currentList.ObjectModel.index) ? storedHomeSecondaryIndex : 0

            onActivateSelected: {
				videoToStop = true;
				storedHomeSecondaryIndex = currentIndex;
			}
            onActivate: { if (!selected) { mainList.currentIndex = currentList.ObjectModel.index; } }
            onListHighlighted: { sfxNav.play(); mainList.currentIndex = currentList.ObjectModel.index; }
        }

		//nineth list
        HorizontalCollection {
            id: list9
            property bool selected: ListView.isCurrentItem
            property var currentList: list9
            property var collection: collection9

            enabled: collection.enabled
            visible: collection.enabled

            height: collection.height

            itemWidth: collection.itemWidth
            itemHeight: collection.itemHeight

            title: collection.title
            search: collection.search

            focus: selected
            width: root.width - globalMargin * 2
            x: globalMargin - vpx(8)

            savedIndex: (storedHomePrimaryIndex === currentList.ObjectModel.index) ? storedHomeSecondaryIndex : 0

            onActivateSelected: {
				videoToStop = true;
				storedHomeSecondaryIndex = currentIndex;
			}
            onActivate: { if (!selected) { mainList.currentIndex = currentList.ObjectModel.index; } }
            onListHighlighted: { sfxNav.play(); mainList.currentIndex = currentList.ObjectModel.index; }
        }

		//tenth list
        HorizontalCollection {
            id: list10
            property bool selected: ListView.isCurrentItem
            property var currentList: list10
            property var collection: collection10

            enabled: collection.enabled
            visible: collection.enabled

            height: collection.height

            itemWidth: collection.itemWidth
            itemHeight: collection.itemHeight

            title: collection.title
            search: collection.search

            focus: selected
            width: root.width - globalMargin * 2
            x: globalMargin - vpx(8)

            savedIndex: (storedHomePrimaryIndex === currentList.ObjectModel.index) ? storedHomeSecondaryIndex : 0

            onActivateSelected: {
				videoToStop = true;
				storedHomeSecondaryIndex = currentIndex;
			}
            onActivate: { if (!selected) { mainList.currentIndex = currentList.ObjectModel.index; } }
            onListHighlighted: { sfxNav.play(); mainList.currentIndex = currentList.ObjectModel.index; }
        }
    }

	//mainList
    ListView {
        id: mainList

        anchors.fill: parent
        model: mainModel
        focus: true
        highlightMoveDuration: 200
        highlightRangeMode: ListView.ApplyRange
        preferredHighlightBegin: header.height
        preferredHighlightEnd: parent.height - (helpMargin * 2)
        snapMode: ListView.SnapOneItem
        keyNavigationWraps: true
        currentIndex: storedHomePrimaryIndex

        cacheBuffer: 1000
        footer: Item { height: helpMargin }

        Component.onCompleted:{
            //to manage focus
            if(designs.InitialPosition === "Video Banner") storedHomePrimaryIndex = 0;
            if(designs.InitialPosition === "Favorites Banner") storedHomePrimaryIndex = 1;
            if(designs.InitialPosition === "Systems list") storedHomePrimaryIndex = 2;
            if(designs.InitialPosition === "System Details") storedHomePrimaryIndex = 3;
            //if you add new component, please put existing index/order before to change position at this place
            mainList.currentIndex = storedHomePrimaryIndex;
        }

        Keys.onUpPressed: {
            sfxNav.play();
            do {
                if(currentIndex === 0){
                    settingsbutton.focus = true;
                    break;
                }
                decrementCurrentIndex();
            } while (!currentItem.enabled);
        }
        Keys.onDownPressed: {
            sfxNav.play();
            do {
                incrementCurrentIndex();
            } while (!currentItem.enabled);
        }
    }

    // Global input handling for the screen
    Keys.onPressed: {
    	if (!viewIsLoading){
	        // Settings
	        if (api.keys.isFilters(event) && !event.isAutoRepeat) {
	            event.accepted = true;
	            settingsScreen();
	        }
		}
    }

    // Helpbar buttons
    ListModel {
        id: gridviewHelpModel

        ListElement {
            name: qsTr("Main Menu")
            button: "mainMenu"
        }
        ListElement {
            name: qsTr("Theme Settings")
            button: "filters"
        }
        ListElement {
            name: qsTr("Select")
            button: "accept"
        }
    }

    //timer to update Helpbar buttons if change after loading of the ShowcaseViewMenu
    property int counter: 0
    Timer {
        id: helpBarTimer
        interval: 1000 // Run the timer every seconds
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            //to have a solution to add netplay dynamicly
            if(api.internal.recalbox.getBoolParameter("global.netplay") && (gridviewHelpModel.count < 4)) gridviewHelpModel.append({name:"Netplay",button:"netplay"});
            else if(!api.internal.recalbox.getBoolParameter("global.netplay") && gridviewHelpModel.count >= 4) gridviewHelpModel.remove(3);
        }
    }

    onFocusChanged: {
       if (focus){
			previousHelpbarModel = gridviewHelpModel; // the same in case of showcaseview
            currentHelpbarModel = gridviewHelpModel;
		}
    }

}
