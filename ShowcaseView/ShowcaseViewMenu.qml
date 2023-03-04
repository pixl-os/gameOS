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

import QtQuick 2.15
import QtQuick.Layouts 1.15
import SortFilterProxyModel 0.2
import QtGraphicalEffects 1.15
import QtMultimedia 5.15
import QtQml.Models 2.15
import "../Global"
import "../GridView"
import "../Lists"
import "../utils.js" as Utils

FocusScope {
    id: root

    // Pull in our custom lists and define
    ListNone    { id: listNone;        max: 0 }
    ListFavorites   { id: listFavorites;   } //no limit in favory now - better to limit in collection itself

	//Repeater to manage loading of lists dynamically and without limits in the future
	property int nbLoaderReady: 0
	Repeater{
		id: repeater
		model: 10 // 10 is the maximum of list loaded dynamically for the moment 
		//warning: index start from 0 but Colletions from 1
		delegate: 
		Loader {
			id: listLoader
			source: getListSourceFromIndex(index + 1) // get qml file to load from index of "settings.ShowcaseCollectionX"
			asynchronous: true
			property bool measuring: false
            property string cacheActivation: "No" //Yes or no
			onStatusChanged:{
				/*
				Available status:
				Loader.Null - the loader is inactive or no QML source has been set
				Loader.Ready - the QML source has been loaded
				Loader.Loading - the QML source is currently being loaded
				Loader.Error - an error occurred while loading the QML source
				*/
                if (listLoader.status === Loader.Loading && !settingsChanged) {
                    if(!listLoader.measuring){
                        viewLoadingText = qsTr("Loading Collection") + " " + (index + 1) + " ...";
						console.time("listLoader - Collection " + (index + 1));
						listLoader.measuring = true;
					}
				}

                if (listLoader.status === Loader.Ready && !settingsChanged) {
                    nbLoaderReady = nbLoaderReady + 1;

					let listType = getListTypeFromIndex((index + 1));
					//console.log("listLoader.listType: ",listType);
                    viewLoadingText = qsTr("Loading Collection") + " " + (index + 1) + " - " + listType + " ...";
					if(listType.includes("My Collection") &&  (api.memory.get(listType + " - Collection name") !== null) &&
						(api.memory.get(listType + " - Collection name") !== ""))
					{
                        listLoader.item.readyForSearch = false;
                        //need to set a ref to manage "cache"
                        listLoader.item.collectionRef = listType;
                        listLoader.item.collectionName = api.memory.has(listType + " - Collection name") ? api.memory.get(listType + " - Collection name") : "";
                        cacheActivation = api.memory.has(listType + " - Cache Activation") ? api.memory.get(listType + " - Cache Activation") : "No";
                        if(cacheActivation === "No") listLoader.item.resetCache(); //for test purpose - to do after collectionName initialization
                        if((cacheActivation === "Yes") && (listLoader.item.hasCacheInitially() === true)) listLoader.item.restoreFromCache();
                        else{
                            listLoader.item.system = api.memory.has(listType + " - System filter") ? api.memory.get(listType + " - System filter") : "";
                            listLoader.item.manufacturer = api.memory.has(listType + " - System Manufacturer filter") ? api.memory.get(listType + " - System Manufacturer filter") : "";
                            listLoader.item.favorite = api.memory.has(listType + " - Favorite") ? api.memory.get(listType + " - Favorite") : "No";
                            listLoader.item.filter = api.memory.has(listType + " - Name filter") ? api.memory.get(listType + " - Name filter") : "";
                            listLoader.item.region = api.memory.has(listType + " - Region/Country filter") ? api.memory.get(listType + " - Region/Country filter") : "";
                            listLoader.item.nb_players = api.memory.has(listType + " - Nb players") ? api.memory.get(listType + " - Nb players") : "1+";
                            listLoader.item.rating = api.memory.has(listType + " - Rating") ? api.memory.get(listType + " - Rating") : "All";
                            listLoader.item.genre = api.memory.has(listType + " - Genre filter") ? api.memory.get(listType + " - Genre filter") : "";
                            listLoader.item.publisher = api.memory.has(listType + " - Publisher filter") ? api.memory.get(listType + " - Publisher filter") : "";
                            listLoader.item.developer = api.memory.has(listType + " - Developer filter") ? api.memory.get(listType + " - Developer filter") : "";
                            listLoader.item.filename = api.memory.has(listType + " - File name filter") ? api.memory.get(listType + " - File name filter") : "";
                            listLoader.item.release = api.memory.has(listType + " - Release year filter") ? api.memory.get(listType + " - Release year filter") : "";
                            listLoader.item.exclusion = api.memory.has(listType + " - Name Exclusion filter") ? api.memory.get(listType + " - Name Exclusion filter") : "";
                            listLoader.item.fileExclusion = api.memory.has(listType + " - File Exclusion filter") ? api.memory.get(listType + " - File Exclusion filter") : "";
                            listLoader.item.sorting = api.memory.has(listType + " - Sort games by") ? api.memory.get(listType + " - Sort games by") : "default";
                        }
                        //tip mandatory to avoid issue of multi-loading of collections
                        listLoader.item.readyForSearch = true;
					}
					else
					{
						if (listType.includes("None")||(listType === "")||(listType === null)) listLoader.item.max = 0;
						else listLoader.item.max = settings.ShowcaseColumns;
					}
					//console.log("listLoader.item.max : ",listLoader.item.max);
					setCollectionFromIndex((index+1));
                    if(listType.includes("My Collection")){
                        //save to cache if my collection
                        if((listLoader.item.hasCache === false) && (cacheActivation === "Yes")) listLoader.item.saveToCache();
                    }
                    console.timeEnd("listLoader - Collection " + (index + 1));
					listLoader.measuring = false;

					if (nbLoaderReady >= repeater.count) {
						showCaseViewCollectionTimer.start();
					}
				}
			}
            active: true;
		}
    }	

	// function used to finish creation of object from qml component
	function finishCreation(component,i){
		mainModel.append(component.createObject(parent,{
													collection : getCollectionFromIndex(i),
													selected : ListView.isCurrentItem,
													objectModelIndex : mainModel.count
												}));
		//console.log("init ShowcaseViewCollection " + i);
	}
    //timer to create ShowCaseViewCollection dynamically
    Timer {
        id: showCaseViewCollectionTimer
        interval: 250 // run afer 250 ms
        repeat: false
        running: false
        triggeredOnStart: false
        onTriggered: {
			for(var i = 1; i <= repeater.count;i++){
				//load dynamic collection here
				var collectionCreated = getCollectionFromIndex(i);
				//console.log("collectionCreated ",i," : ",collectionCreated);
				//console.log("getListTypeFromIndex(i) : ",getListTypeFromIndex(i));
				if(getListTypeFromIndex(i) !== "None"){
					var component = Qt.createComponent("ShowcaseViewCollection.qml");
					if (component.status === Component.Ready)
						finishCreation(component,i);
					else
						component.statusChanged.connect(finishCreation(component,i));
				}
			}
			viewIsLoading = false;
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
        if ((listType === "")||(typeof(listType) === "undefined")) listType = "None";
        else if(api.memory.has(listType + " - Collection name")){
			var value = api.memory.get(listType + " - Collection name");
            listType  = ((value === "")||(value === null)||(typeof(value) === "undefined")) ? "None" : listType;
		}
        //console.log("listType: ",listType);
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
        //to remove index of My Collection if needed
        if(listType.includes("My Collection"))
        {
            listType = "My Collection";
        }
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
			case "My Collection":
				qmlFileToUse = "../Lists/ListMyCollection.qml";
				break;
			case "None":
                qmlFileToUse = "../Lists/ListNone.qml";
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
		
        var collection = {
            enabled: true,
        };

        var width = root.width - globalMargin * 2;
        var collectionThumbnail = getThumbnailFromIndex(index);
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

        var collectionType = getListTypeFromIndex(index);
        switch (collectionType) {
        case "None":
            collection.enabled = false;
            collection.height = 0;
            collection.search = listNone;
            collection.title = "";
            break;
		default:            
            collection.search = repeater.itemAt(index-1).item;
            collection.title = collection.search.collection.name;
            break;
        }
		
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

    //Function to get collection from index to help automatic creation of ShowcaseViewCollection
    function getCollectionFromIndex(index){
        switch (index) {
            case 1:
                return collection1;
            case 2:
                return collection2;
            case 3:
                return collection3;
            case 4:
                return collection4;
            case 5:
                return collection5;
            case 6:
                return collection6;
            case 7:
                return collection7;
            case 8:
                return collection8;
            case 9:
                return collection9;
            case 10:
                return collection10;
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


    // Using an object model to build the main list using other lists
    ObjectModel {
        id: mainModel

        property var regionSSIndex : getInitialRegionIndex();

        Component.onCompleted: {
            //set position of Video Banner (id: ftueContainer)
            if(designs.VideoBannerPosition !== "No") findObjectAndMove(ftueContainer,parseInt(designs.VideoBannerPosition));
            //set position of Favorites Banner (id: featuredlist)
            if(designs.FavoritesBannerPosition !== "No") findObjectAndMove(featuredlist,parseInt(designs.FavoritesBannerPosition));
            //set position of Groups List (id: grouplist)
            if(designs.GroupsListPosition !== "No") findObjectAndMove(grouplist,parseInt(designs.GroupsListPosition));
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
					if(ftue){
						if(designs.VideoBannerSource === "Default"){
							return "../assets/video/ftue.mp4"
						}
						else{
							//unique url or path, no variable data for the moment
							return designs.VideoBannerPathExpression;
						}
					}
					//solution to set to nothing to avoid memory leak if no video necessary
					else return "";
                }
                fillMode: VideoOutput.PreserveAspectCrop
                muted: true
                loops: MediaPlayer.Infinite
                autoPlay: ftue //avoid to autoplay if no video should be display

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
            focus: selected
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
            currentIndex: 0
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
                    source: Utils.favorite(modelData);
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
                    //change favorites only if several and showcaseViewMenu at front
                    if (featuredlist.count >= 2 && root.activeFocus === true) featuredlist.incrementCurrentIndex();
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
                        if (!ftue){
                            storedHomeSecondaryIndex = featuredlist.currentIndex; // not used today for this case
                            if(designs.FavoritesBannerPosition === designs.VideoBannerPosition){
                                //in case of same position, we ahve to move by adding 1 for favorites
                                storedHomePrimaryIndex = parseInt(designs.FavoritesBannerPosition)+1;
                            }
                            else storedHomePrimaryIndex = parseInt(designs.FavoritesBannerPosition);
	                        gameDetails(featuredCollection.currentGame(currentIndex));
                        }
                    }
				}
            }
        }

        // List by group of systems
        ListView {
            id: grouplist

            property bool selected : ListView.isCurrentItem
            property int myIndex: ObjectModel.index
            width: appWindow.width

            visible: ((settings.SystemsGroupDisplay === "No") || (storedHomePrimaryIndex === platformlist.ObjectModel.index && (settings.SystemsGroupDisplay === "same slot"))) ? false : true
            height: visible ? appWindow.height * (parseFloat(designs.GroupsListRatio)/100) : 0

            enabled: visible
            currentIndex: -1
            focus: false

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

            property int savedIndex: currentGroupIndex
            onSelectedChanged: {
                //console.log("grouplist.onSelectedChanged : ", grouplist.selected);
                //console.log("settings.SystemsGroupDisplay : ",settings.SystemsGroupDisplay);
                //console.log("platformlist.visible : ",platformlist.visible);
                //console.log("platformlist.selected : ",platformlist.selected);
                //console.log("platformlist.currentIndex : ",platformlist.currentIndex);
                //console.log("platformlist.savedIndex : ",platformlist.savedIndex);
                //console.log("grouplist.currentIndex : ",grouplist.currentIndex);
                //console.log("grouplist.savedIndex : ",grouplist.savedIndex);
                if(grouplist.selected === true || platformlist.selected === true){
                    if(designs.GroupsListPosition !== "No" && settings.SystemsGroupDisplay !== "No"){
                        if (settings.SystemsGroupDisplay !== "same slot"){
                            grouplist.visible = true;
                            grouplist.height = appWindow.height * (parseFloat(designs.GroupsListRatio)/100)
                        }
                        else if (grouplist.selected === true && platformlist.visible === false) {
                            grouplist.visible = true;
                            grouplist.height = appWindow.height * (parseFloat(designs.GroupsListRatio)/100)
                        }
                        else {
                            grouplist.visible = false;
                            grouplist.height = 0;
                        }
                    }
                    else{
                        grouplist.visible = false;
                        grouplist.height = 0;
                    }
                }
                //console.log("grouplist.height : ",grouplist.height);
                //console.log("grouplist.visible : ",grouplist.visible);
            }
            onFocusChanged: {
                //console.log("grouplist::onFocusChanged : ",focus);
                if (focus)
                    currentIndex = savedIndex;
                else {
                    savedIndex = currentIndex;
                    currentIndex = -1;
                    if(designs.GroupMusicSource !== "No") playMusic.stop();
                }
            }

            Component.onCompleted: {
                //console.log("grouplist::Component.onCompleted - currentIndex (before) : ",currentIndex);
                currentIndex = savedIndex;
                //console.log("grouplist::Component.onCompleted - currentIndex (after) : ",currentIndex);
                positionViewAtIndex(currentIndex, ListView.End);
            }

            //to adapt for groups / not visible by defaults
            ListModel{
                id: typeOfSystems
                ListElement {
                    shortName : "arcade"
                    name: qsTr("Arcade system")
                    names: qsTr("Arcade systems")
                }
                ListElement {
                    shortName : "console"
                    name: qsTr("Home console")
                    names: qsTr("Home consoles")
                }
                ListElement {
                    shortName : "handheld"
                    name: qsTr("Handheld console")
                    names: qsTr("Handheld consoles")
                }
                ListElement {
                    shortName : "computer"
                    name: qsTr("Computer")
                    names: qsTr("Computers")
                    visible: false
                }
                ListElement {
                    shortName : "port"
                    name: qsTr("Port")
                    names: qsTr("Ports")
                }
                ListElement {
                    shortName : "engine"
                    name: qsTr("Engine")
                    names: qsTr("Engines")
                }
                ListElement {
                    shortName : "virtual"
                    name: qsTr("Virtual system")
                    names: qsTr("Virtual systems")
                }
            }

            //FILTERING for Group of systems to display (Display only group if not empty)
            SortFilterProxyModel {
                id: groupsDisplayed
                sourceModel: typeOfSystems
                delayed: true //to avoid loop binding
                filters:[
                    //to search i fany collection exists for this type of system
                    ExpressionFilter {
                        enabled: settings.SystemsGroupDisplay !== "No"
                        expression:{
                            //to avoid to check collections if undefined
                            if(model.shortName === 'undefined') return false;
                            //console.log("model.shortName : ",model.shortName);
                            //console.log("api.collections.count: ",api.collections.count);
                            for(var i = 0;i <= api.collections.count; i++)
                            {
                                if(api.collections.get(i) !== null){
                                    if(api.collections.get(i).type === model.shortName){
                                        //console.log("api.collections.get(i).type : ", api.collections.get(i).type)
                                        return true;
                                    }
                                }
                            }
                            return false;
                        }
                    }
                ]
            }

            model: groupsDisplayed

            delegate: Rectangle {
                id:rectangleGroupLogo
                property bool selected: ListView.isCurrentItem && grouplist.focus
                width: grouplist.width / parseFloat(designs.NbGroupLogos)
                height: grouplist.height
                color: "transparent"
                property string shortName: { //that's short name of group, not of collections !!!
                    //console.log("typeOfSystems.get(ListView.currentIndex).shortName",typeOfSystems.get(ListView.currentIndex).shortName);
                    //console.log("model.shortName", model.shortName);
                    return model.shortName
                }

                Image {
                    id: groupBackground
                    visible: (designs.GroupsListBackground !== "No") ? true : false
                    height: rectangleGroupLogo.height
                    width: rectangleGroupLogo.width
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    smooth: true
                    opacity: 1
                    z:-1
                    source:{
                        if(designs.GroupsListBackground === "Custom"){
                            // for {region} & {shortname} tags
                            return mainModel.processPathExpression(designs.GroupsListBackgroundPathExpression, model)
                        }
                        else return "";
                    }
                }

                onSelectedChanged: {
                    //console.log("Delegate::onSelectedChanged : ",selected)

                    //reset index saved if selected changed during browsing in groups
                    if(selected && grouplist.selected){
                        platformlist.currentIndex = 0;
                        platformlist.savedIndex = 0;
                        searchTerm = "";
                    }

                    if(selected && (designs.GroupMusicSource !== "No")){
                        if(activeFocus && focus){
                           playGroupMusic.play();
                        }
                        else{
                           playGroupMusic.stop();
                        }
                    }
                    else{
                        playGroupMusic.stop();
                    }
                }

                onActiveFocusChanged: {
                    //console.log("Focus changed to " + focus)
                    //console.log("Active Focus changed to " + activeFocus)
                    if(selected && (designs.GroupMusicSource !== "No")){
                        if(activeFocus && focus){
                           playGroupMusic.play();
                        }
                        else{
                            playGroupMusic.stop();
                        }
                    }
                    else{
                        playGroupMusic.stop();
                    }
                }

                Audio {
                    id: playGroupMusic
                    loops: Audio.Infinite
                    source: {
                        if (designs.GroupMusicSource === "Custom") {
                            if (model.shortName !=="imageviewer"){
                                return mainModel.processPathExpression(designs.GroupMusicPathExpression,model)
                            }
                            else return "";
                        }
                        else if(designs.GroupMusicSource !== "No") {
                            return "";
                        }
                        else return "";
                    }
                }

                Image {
                    id: grouplogo
                    height: parent.height * (parseFloat(designs.GroupLogoRatio)/100)
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: {
                        if (designs.GroupLogoSource === "Custom"){
                            // Able to manage {region} & {shortname} tags
                            var result = mainModel.processPathExpression(designs.GroupLogoPathExpression,model)
                            return result;
                        }
                        else if(designs.GroupLogoSource !== "No"){
                            if(settings.SystemLogoStyle === "White")
                            {
                                return "../assets/images/logospng/" + Utils.processPlatformName(model.shortName) + ".png";
                            }
                            else
                            {
                                return "../assets/images/logospng/" + Utils.processPlatformName(model.shortName) + "_" + settings.SystemLogoStyle.toLowerCase() + ".png";
                            }
                        }
                    }
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    smooth: true
                    opacity: selected ? 1 : (designs.NbGroupLogos === "1" ? 0.0 : 0.3)
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
                            if (designs.GroupLogoSource !== "Default"){
                                //if custom logo, we are trying to load without region
                                source = mainModel.processPathExpressionNoRegion(designs.GroupLogoPathExpression,model)
                            }
                        }
                    }
                }

                Text {
                    id: grouptitle
                    text: {
                        return (groupSelected.count + " " + ((groupSelected.count > 1) ? model.names + api.tr : model.name + api.tr));
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

                    anchors.top: grouplogo.bottom

                    width: parent.width

                    opacity: designs.NbGroupLogos === "1" ?  0.0 : 0.2
                    visible: (settings.AlwaysShowTitles === "Yes") || selected
                }

                Text {
                    id: groupname

                    text: model.name
                    anchors { fill: parent; margins: vpx(10) }
                    color: theme.text
                    opacity: selected ? 1 : 0.2
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                    font.pixelSize: vpx(18)
                    font.family: subtitleFont.name
                    font.bold: true
                    style: Text.Outline; styleColor: theme.main
                    visible: grouplogo.status === Image.Error ? ((designs.NbGroupLogos === "1") ? selected : true) : false
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
                    onEntered: { sfxNav.play(); mainList.currentIndex = grouplist.ObjectModel.index; grouplist.savedIndex = index; grouplist.currentIndex = index; }
                    onExited: {}
                    onClicked: {
                        if (selected)
                        {
                            mainList.currentIndex = grouplist.ObjectModel.index + 1;
                        } else {
                            mainList.currentIndex = grouplist.ObjectModel.index;
                        }
                    }
                }
            }

            // List specific input
            Keys.onLeftPressed: { sfxNav.play(); decrementCurrentIndex(); savedIndex = grouplist.currentIndex; currentGroupIndex = savedIndex; currentCollectionIndex = 0;}
            Keys.onRightPressed: { sfxNav.play(); incrementCurrentIndex(); savedIndex = grouplist.currentIndex; currentGroupIndex = savedIndex; currentCollectionIndex = 0;}
            Keys.onDownPressed: { sfxNav.play();
                                  if(designs.GroupsListPosition !== "No" && settings.SystemsGroupDisplay !== "No"){
                                      if(settings.SystemsGroupDisplay === "same slot") {
                                          mainList.currentIndex = platformlist.ObjectModel.index + 2; //to avoid to select system list
                                      }
                                      else mainList.currentIndex = grouplist.ObjectModel.index + 1;
                                  }
            }
            Keys.onPressed: {
                if (!viewIsLoading){
                    // Accept
                    if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        if(designs.GroupsListPosition !== "No" && settings.SystemsGroupDisplay !== "No"){
                            if(settings.SystemsGroupDisplay === "same slot") {
                                grouplist.height = 0;
                                grouplist.visible = false;
                            }
                            mainList.currentIndex = platformlist.ObjectModel.index;
                            //to force update of display if needed
                            platformlist.selected = false;
                            platformlist.selected = true;
                        }
                    }
                }
            }
        }

        // Collections list with systems
        ListView {
            id: platformlist

            //FILTERING collections to display by group & SORTERING collections to sort by name, releasedate or manufacturer
            SortFilterProxyModel {
                id: groupSelected
                sourceModel: api.collections
                delayed: true //to avoid loop binding
                filters:[ValueFilter { roleName: "type"; value: groupsDisplayed.get(grouplist.currentIndex !== -1 ? grouplist.currentIndex : grouplist.savedIndex).shortName; enabled: settings.SystemsGroupDisplay !== "No"}
                ]
                sorters:[RoleSorter { roleName: settings.SortSystemsBy; sortOrder: Qt.AscendingOrder; enabled: true},
                         RoleSorter { roleName: settings.SortSystemsSecondlyBy; sortOrder: Qt.AscendingOrder; enabled: settings.SortSystemsBy !== settings.SortSystemsSecondlyBy}
                ]
            }

            model: groupSelected

            property bool selected : ListView.isCurrentItem
            property int myIndex: ObjectModel.index
            width: appWindow.width

            height: (settings.SystemsGroupDisplay !== "same slot") ? appWindow.height * (parseFloat(designs.SystemsListRatio)/100) : 0
            visible: (settings.SystemsGroupDisplay !== "same slot") ? true : false

            onSelectedChanged: {
                //console.log("platformlist::onSelectedChanged : ", selected);
                //console.log("platformlist::onSelectedChanged - currentIndex: ", currentIndex);
                //console.log("platformlist::onSelectedChanged - settings.SystemsGroupDisplay : ",settings.SystemsGroupDisplay);
                //console.log("platformlist::onSelectedChanged - grouplist.visible : ",grouplist.visible);
                //console.log("platformlist::onSelectedChanged - grouplist.selected : ",grouplist.selected);
                //console.log("platformlist::onSelectedChanged - grouplist.height : ",grouplist.height);
                if(designs.SystemsListPosition !== "No"){
                    if (settings.SystemsGroupDisplay !== "same slot"){
                        platformlist.visible = true;
                        platformlist.height = appWindow.height * (parseFloat(designs.SystemsListRatio)/100);
                    }
                    else if (platformlist.selected === true && grouplist.visible === false){ //(grouplist.selected === false)
                        platformlist.visible = true;
                        platformlist.height = appWindow.height * (parseFloat(designs.SystemsListRatio)/100);
                    }
                    else {
                        platformlist.visible = false;
                        platformlist.height = 0;
                    }
                }
                else{
                    platformlist.visible = false;
                    platformlist.height = 0;
                }
                //console.log("platformlist::onSelectedChanged - platformlist.height : ",platformlist.height);
                //console.log("platformlist::onSelectedChanged - platformlist.visible : ",platformlist.visible);
            }

            focus: (storedHomePrimaryIndex === platformlist.ObjectModel.index) ?  true : false

            enabled: visible

            //ok without group but with sorting, need additional fix for groups due to loading of platformlist in parralel of grouplist
            property int savedIndex : (storedHomePrimaryIndex === platformlist.ObjectModel.index) ?  storedHomeSecondaryIndex : 0

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

            onActiveFocusChanged: {
                //console.log("platformlist::onActiveFocusChanged : ",activeFocus);
                //console.log("platformlist::onActiveFocusChanged - currentIndex: ",platformlist.currentIndex);
                //console.log("platformlist::onActiveFocusChanged - savedIndex: ",platformlist.savedIndex);
                //console.log("platformlist::onActiveFocusChanged - storedHomeSecondaryIndex: ",storedHomeSecondaryIndex);

                //FIX: to return to good index in list - seems a bug of list udpates during loading of models when we come back from game
                if(platformlist.currentIndex !== platformlist.savedIndex){
                    if(platformlist.savedIndex === storedHomeSecondaryIndex){
                        platformlist.currentIndex = storedHomeSecondaryIndex;
                    }
                }

            }

            onFocusChanged: {
                //console.log("platformlist::onFocusChanged - focus : ",focus);
                //console.log("platformlist::onFocusChanged - currentCollectionIndex : ",currentCollectionIndex);
                //console.log("platformlist::onFocusChanged - savedIndex : ",savedIndex);
                if (focus){
                    if(savedIndex < platformlist.count){
                        currentIndex = savedIndex;
                    }
                    else{
                        currentIndex = 0;
                        savedIndex = 0;
                    }
                }
                else {
                    savedIndex = currentIndex;
                    currentIndex = -1;
                    if(designs.SystemMusicSource !== "No") playMusic.stop();
                }
            }

            Component.onCompleted:{
                //console.log("platformlist::Component.onCompleted - grouplist.currentIndex (before) : ",grouplist.currentIndex);
                //console.log("platformlist::Component.onCompleted - platformlist.ObjectModel.index : ",platformlist.ObjectModel.index);
                //console.log("platformlist::Component.onCompleted - storedHomePrimaryIndex : ",storedHomePrimaryIndex);
                //console.log("platformlist::Component.onCompleted - storedHomeSecondaryIndex : ",storedHomeSecondaryIndex);
                //console.log("platformlist::Component.onCompleted - currentCollectionIndex : ",currentCollectionIndex);
                //console.log("platformlist::Component.onCompleted - savedIndex (before): ",savedIndex);
                savedIndex = (storedHomePrimaryIndex === platformlist.ObjectModel.index) ?  storedHomeSecondaryIndex : 0
                //console.log("platformlist::Component.onCompleted - savedIndex (after): ",savedIndex);
                //console.log("platformlist::Component.onCompleted - currentIndex (before): ",currentIndex);
                currentIndex = savedIndex;
                //console.log("platformlist::Component.onCompleted - currentIndex (before): ",currentIndex);
                positionViewAtIndex(currentIndex, ListView.End)

            }

            delegate: Rectangle {
                id:rectangleLogo
                property bool selected: ListView.isCurrentItem && platformlist.focus
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
                    //console.log("platformlist::delegate onSelectedChanged : ",selected)
                    //console.log("platformlist::delegate onSelectedChanged index : ",index)
                    //console.log("platformlist::delegate onSelectedChanged - currentIndex: ",platformlist.currentIndex);
                    //console.log("platformlist::delegate onSelectedChanged - grouplist.currentIndex (after) : ",grouplist.currentIndex);

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
                    //console.log("platformlist::delegate onActiveFocusChanged : ",activeFocus);
                    //console.log("platformlist::delegate onActiveFocusChanged - currentIndex: ",platformlist.currentIndex);
                    //console.log("Active Focus changed to " + activeFocus)
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
                        else{
                            //display release date if sorted by that
                            if(settings.SortSystemsBy === "releasedate" || settings.SortSystemsSecondlyBy === "releasedate" ){
                                return (modelData.releasedate  + " - " + modelData.games.count + ((modelData.games.count > 1) ? " " + qsTr("games") + api.tr : " " + qsTr("game") + api.tr));

                            }
                            else return (modelData.games.count + ((modelData.games.count > 1) ? " " + qsTr("games") + api.tr : " " + qsTr("game") + api.tr));
                        }
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
                            //to have the direct access to collection if needed for other views
                            currentCollectionIndex = groupSelected.mapToSource(platformlist.currentIndex);
                            //to keep position in menu after game launching
                            storedHomeSecondaryIndex = platformlist.currentIndex;
                            storedHomePrimaryIndex = platformlist.ObjectModel.index;
                            softwareScreen();
                        } else {
                            mainList.currentIndex = platformlist.ObjectModel.index;
                            platformlist.currentIndex = index;
                        }

                    }
                }
            }

            // List specific input
            Keys.onLeftPressed: { sfxNav.play(); decrementCurrentIndex();}
            Keys.onRightPressed: { sfxNav.play(); incrementCurrentIndex();}
            Keys.onPressed: {
                if (!viewIsLoading){
                    // Accept
                    if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        //to have the direct access to collection if needed for other views
                        currentCollectionIndex = groupSelected.mapToSource(platformlist.currentIndex);
                        //console.log("platformlist::Keys.onPressed - platformlist.currentIndex : ",platformlist.currentIndex);
                        //console.log("platformlist::Keys.onPressed - currentCollectionIndex : ",currentCollectionIndex);
                        //to keep position in menu after game launching
                        storedHomeSecondaryIndex = platformlist.currentIndex;
                        storedHomePrimaryIndex = platformlist.ObjectModel.index;
                        //console.log("platformlist::Keys.onPressed - storedHomePrimaryIndex : ",storedHomePrimaryIndex);
                        //console.log("platformlist::Keys.onPressed - storedHomeSecondaryIndex : ",storedHomeSecondaryIndex);
                        softwareScreen();
                    }
                    // Cancel (only when Groups are activated)
                    if (api.keys.isCancel(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        if(designs.GroupsListPosition !== "No" && settings.SystemsGroupDisplay !== "No"){
                            //to have the direct access to collection if needed
                            currentCollectionIndex = groupSelected.mapToSource(platformlist.currentIndex);
                            savedIndex = currentCollectionIndex;
                            //console.log("SystemsGroupDisplay: ", settings.SystemsGroupDisplay);
                            if(settings.SystemsGroupDisplay === "same slot") {
                                platformlist.height = 0;
                                platformlist.visible = false;
                            }
                            mainList.currentIndex = grouplist.ObjectModel.index;
                            //to force update of display if needed
                            grouplist.selected = false;
                            grouplist.selected = true;
                        }
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
                                source = mainModel.processPathExpressionScreenScraper(pathExpression, modelData,regionIndexUsed);
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

        cacheBuffer: 1000
        footer: Item { height: helpMargin }

        Component.onCompleted:{
            if((storedHomePrimaryIndex === 0) && (storedHomeSecondaryIndex === 0) && (lastState.length === 0)){
                //to manage focus and selection for first time
                if(designs.InitialPosition === "Video Banner") storedHomePrimaryIndex = 0;
                if(designs.InitialPosition === "Favorites Banner") storedHomePrimaryIndex = 1;
                if(designs.InitialPosition === "Groups list" && settings.SystemsGroupDisplay !== "No" ) storedHomePrimaryIndex = 2;
                if(designs.InitialPosition === "Groups list" && settings.SystemsGroupDisplay === "No" ) storedHomePrimaryIndex = 3; //to select systems list in this case
                if(designs.InitialPosition === "Systems list") storedHomePrimaryIndex = 3;
                if(designs.InitialPosition === "Systems list" && settings.SystemsGroupDisplay !== "No" ) storedHomePrimaryIndex = 2; //to select groups list in this case
                if(designs.InitialPosition === "System Details") storedHomePrimaryIndex = 4;
            }
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
        interval: 500 // Run the timer every seconds
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            //for netplay help button
            var found = false
            var netplay = api.internal.recalbox.getBoolParameter("global.netplay") === true ? true : false;
            var item;
            //loop to find netplay
            for(var i = 0;i < gridviewHelpModel.count;i++){
                item = gridviewHelpModel.get(i);
                if(item.button === "netplay"){
                    if(netplay === false){
                        gridviewHelpModel.remove(i);
                    }
                    found = true;
                }
            }
            if(found === false && netplay === true){
                gridviewHelpModel.append({name:qsTr("Netplay"),button:"netplay"});
            }
            //for back help button
            found = false
            var back = (designs.GroupsListPosition !== "No" && settings.SystemsGroupDisplay === "same slot" && platformlist.selected === true && platformlist.visible === true && platformlist.focus === true) ? true : false
            //loop to find back
            for(var j=0;j < gridviewHelpModel.count;j++){
                item = gridviewHelpModel.get(j);
                if(item.button === "cancel"){
                    if(back === false){
                        gridviewHelpModel.remove(j);
                    }
                    found = true;
                }
            }
            if(found === false && back === true){
                gridviewHelpModel.append({name:qsTr("Group"),button:"cancel"});
            }
        }
    }

    onActiveFocusChanged:
    {
        //console.log("onActiveFocusChanged : ", activeFocus);
        if (activeFocus){
            previousHelpbarModel = ""; // to force reload for transkation
            previousHelpbarModel = gridviewHelpModel; // the same in case of showcaseview
            currentHelpbarModel = ""; // to force reload for transkation
            currentHelpbarModel = gridviewHelpModel;
        }
    }
}
