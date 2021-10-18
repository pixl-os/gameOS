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
import QtMultimedia 5.12
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
	
		//property alias listMyCollection: listMyCollectionLoader.item;
		delegate: 
		Loader {
			id: listLoader
			//source: Utils.isCollectionTypeRequested("My Collection 1") ? "../Lists/ListMyCollection.qml" : ""
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
						viewLoadingText = "Loading Collection " + (index + 1) + " ...";
						console.time("listLoader - Collection " + (index + 1));
						listLoader.measuring = true;
					}
				}

				if (listLoader.status === Loader.Ready) {
					nbLoaderReady = nbLoaderReady + 1;
					let listType = api.memory.has("Collection " + (index + 1)) ? api.memory.get("Collection " + (index + 1)) : "";
					//console.log("listLoader.listType: ",listType);
					viewLoadingText = "Loading Collection " + (index + 1) + " - " + listType + " ...";
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

    property bool ftue: featuredCollection.games.count == 0

    function storeIndices(secondary) {
        storedHomePrimaryIndex = mainList.currentIndex;
        if (secondary)
            storedHomeSecondaryIndex = secondary;
    }

    Component.onDestruction: storeIndices();

    anchors.fill: parent

	//ftueContainer
    Item {
        id: ftueContainer

        width: parent.width
        height: vpx(360)
        visible: ftue
        opacity: {
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
        }
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
            source: "../assets/video/ftue.mp4"
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
            source: "../assets/images/gameOS-logo.png"
            sourceSize: Qt.size(parent.width, parent.height)
            fillMode: Image.PreserveAspectFit
            smooth: true
            asynchronous: true
            anchors.centerIn: parent
        }

        Text {
            text: "Try adding some favorite games"

            horizontalAlignment: Text.AlignHCenter
            anchors { bottom: parent.bottom; bottomMargin: vpx(75) }
            width: parent.width
            height: contentHeight
            color: theme.text
            font.family: subtitleFont.name
            font.pixelSize: vpx(16)
            opacity: 0.5
            visible: false
        }
    }
	
	//header
    Item {
        id: header

        width: parent.width
        height: vpx(70)
        z: 10
        Image {
            id: logo

            width: vpx(150)
            anchors { left: parent.left; leftMargin: globalMargin }
            source: "../assets/images/gameOS-logo.png"
            sourceSize: Qt.size(parent.width, parent.height)
            fillMode: Image.PreserveAspectFit
            smooth: true
            asynchronous: true
            anchors.verticalCenter: parent.verticalCenter
            visible: !ftueContainer.visible
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

            Keys.onDownPressed: mainList.focus = true;
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

		// Favorites list at top with screenshot/fanart/marquee and logos
        ListView {
            id: featuredlist

            property bool selected: ListView.isCurrentItem
            focus: selected
            width: parent.width
            height: vpx(360)
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
            Component.onCompleted: positionViewAtIndex(currentIndex, ListView.Visible)

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
                        color: (featuredlist.currentIndex == index) && featuredlist.focus ? theme.accent : theme.text
                        radius: width/2
                        opacity: (featuredlist.currentIndex == index) ? 1 : 0.5
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
            Keys.onUpPressed: settingsbutton.focus = true;
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

            property bool selected: ListView.isCurrentItem
            property int myIndex: ObjectModel.index
            focus: selected
            width: root.width
            height: vpx(100) + globalMargin * 2
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

            property int savedIndex: currentCollectionIndex
            onFocusChanged: {
                if (focus)
                    currentIndex = savedIndex;
                else {
                    savedIndex = currentIndex;
                    currentIndex = -1;
                }
            }

            Component.onCompleted: positionViewAtIndex(savedIndex, ListView.End)

            model: api.collections//Utils.reorderCollection(api.collections);
            delegate: Rectangle {
                property bool selected: ListView.isCurrentItem && platformlist.focus
                width: (root.width - globalMargin * 2) / 7.0
                height: width * settings.WideRatio
                //                color: selected ? theme.accent : theme.secondary
                color: "transparent"

                scale: selected ? 1.1 : 1
                Behavior on scale { NumberAnimation { duration: 100 } }
                //                border.width: vpx(1)
                //                border.color: "#19FFFFFF"

//                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id: collectionlogo

                    anchors.fill: parent
                    anchors.centerIn: parent
                    anchors.margins: vpx(15)
                    source: {
                        if(settings.SystemLogoStyle === "White")
                        {
                            return "../assets/images/logospng/" + Utils.processPlatformName(modelData.shortName) + ".png";
                        }
                        else
                        {
                            return "../assets/images/logospng/" + Utils.processPlatformName(modelData.shortName) + "_" + settings.SystemLogoStyle.toLowerCase() + ".png";
                        }
                    }
                    sourceSize: Qt.size(collectionlogo.width, collectionlogo.height)
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    smooth: true
                    opacity: selected ? 1 : 0.3
                    scale: selected ? 1.1 : 1
                    Behavior on scale { NumberAnimation { duration: 100 } }
                }

                Text {
                    id: title
                    text: {
                        if(modelData.name === "Screenshots")
                            return (modelData.games.count + ((modelData.games.count)!==1 ? " screenshots" : " screenshot"));
                        else
                            return (modelData.games.count + ((modelData.games.count)!==1 ? " games" : " game"));
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

                    anchors.top: parent.bottom

                    width: parent.width

                    opacity: 0.2
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
                    visible: collectionlogo.status == Image.Error
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

        Keys.onUpPressed: {
            sfxNav.play();
            do {
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
            name: "Settings"
            button: "filters"
        }
        ListElement {
            name: "Select"
            button: "accept"
        }
    }

    onFocusChanged: {
       if (focus){
			previousHelpbarModel = gridviewHelpModel; // the same in case of showcaseview
            currentHelpbarModel = gridviewHelpModel;
		}
    }

}
