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

// Updated to add collections management by BozoTheGeek: 24/08/2021

import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import "../Dialogs"

FocusScope {
    id: root

    ListModel {
        id: designsModel
        ListElement {
            settingName: "Initial Focus on"
            setting: "Favorites Banner,Systems list"
        }
        ListElement {
            settingName: "Favorites Banner screen position"
            setting: "0,1,2,3,No"
        }
        ListElement {
            settingName: "Favorites Banner screen ratio"
            setting: "50%,55%,60%,65%,70%,75%,80%,85%,90%,95%,100%,20%,25%,30%,35%,40%,45%"
        }
        ListElement {
            settingName: "Systems list screen position"
            setting: "0,1,2,3,No"
        }
        ListElement {
            settingName: "Systems list screen ratio"
            setting: "50%,55%,60%,65%,70%,75%,80%,85%,90%,95%,100%,20%,25%,30%,35%,40%,45%"
        }
        ListElement {
            settingName: "Number of Systems icon visible"
            setting: "7,8,9,10,1,2,3,4,5,6"
        }
        ListElement {
            settingName: "Systems icon ratio"
            setting: "100%,20%,25%,30%,35%,40%,45%,50%,55%,60%,65%,70%,75%,80%,85%,90%,95%"
        }
        ListElement {

        //after this line, parameters not yet took into account, just ideas ;-)
        ListElement {
            settingName: "Systems list direction"
            setting: "Horizontal,Vertical-left,Vertical-right"
        }
        ListElement {
            settingName: "Systems list style"
            setting: "Standard,Wheel"
        }
        ListElement {
            settingName: "Systems group display"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Systems display in group"
            setting: "When Selected, Always"
        }
        ListElement {
            settingName: "Collections display"
            setting: "In home page, In a dedicated system, Both"
        }
        ListElement {
            settingName: "System picture display"
            setting: "Top,Middle,Bottom,No"
        }
        ListElement {
            settingName: "System picture size"
            setting: "100%,20%,25%,30%,35%,40%,45%,50%,55%,60%,65%,70%,75%,80%,85%,90%,95%"
        }

        ListElement {
            settingName: "System picture source"
            setting: "From theme" //think about other source ?!
        }
        ListElement {
            settingName: "System details display"
            setting: "Top,Middle,Bottom,No"
        }
        ListElement {
            settingName: "System details source"
            setting: "Screenscraper only,pixL only, pixL + Screenscraper" //think about other source ?!
        }
    }

    property var designerPage: {
        return {
            pageName: "Designer (for dev only)",
            listmodel: designsModel
        }
    }

    ListModel {
        id: settingsModel

        /*ListElement {
            settingName: "Game View"
            setting: "Grid,Vertical List"
        }*/
        ListElement {
            settingName: "Allow video thumbnails"
            setting: "Yes,No"
            settingNameDisplay: qsTr("Allow video thumbnails")
            settingDisplay: qsTr("Yes,No")
        }
        ListElement {
            settingName: "Play video thumbnail audio"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Play video thumbnail audio")
            settingDisplay: qsTr("No,Yes")

        }
        ListElement {
            settingName: "Hide logo when thumbnail video plays"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Hide logo when thumbnail video plays")
            settingDisplay: qsTr("No,Yes")

        }
        ListElement {
            settingName: "Animate highlight"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Animate highlight")
            settingDisplay: qsTr("No,Yes")
        }
        ListElement {
            settingName: "Enable mouse hover"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Enable mouse hover")
            settingDisplay: qsTr("No,Yes")

        }
        ListElement {
            settingName: "Always show titles"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Always show titles")
            settingDisplay: qsTr("No,Yes")
        }
        ListElement {
            settingName: "Hide button help"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Hide button help")
            settingDisplay: qsTr("No,Yes")
        }
        ListElement {
            settingName: "Help buttons style"
            setting: "Gamepad,Arcade"
            settingNameDisplay: qsTr("Help buttons style")
            settingDisplay: qsTr("Gamepad,Arcade")
        }
        ListElement {
            settingName: "Hide Clock"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Hide Clock")
            settingDisplay: qsTr("No,Yes")
        }
        ListElement {
            settingName: "Color Layout"
            setting: "Original,Dark Green,Light Green,Turquoise,Dark Red,Light Red,Dark Pink,Light Pink,Dark Blue,Light Blue,Orange,Yellow,Magenta,Purple,Dark Gray,Light Gray,Steel,Stone,Dark Brown,Light Brown"
            settingNameDisplay: qsTr("Color Layout")
            settingDisplay: qsTr("Original,Dark Green,Light Green,Turquoise,Dark Red,Light Red,Dark Pink,Light Pink,Dark Blue,Light Blue,Orange,Yellow,Magenta,Purple,Dark Gray,Light Gray,Steel,Stone,Dark Brown,Light Brown")
        }
        ListElement {
            settingName: "Color Background"
            setting: "Original,Black,Gray,Blue,Green,Red"
            settingNameDisplay: qsTr("Color Background")
            settingDisplay: qsTr("Original,Black,Gray,Blue,Green,Red")
        }
	ListElement {
        settingName: "System Logo Style"
        setting: "Color,Steel,Carbon,White,Black"
        settingNameDisplay: qsTr("System Logo Style")
        settingDisplay: qsTr("Color,Steel,Carbon,White,Black")
        }
    }

    property var generalPage: {
        return {
            pageName: qsTr("General") + api.tr,
            listmodel: settingsModel
        }
    }

    ListModel {
        id: advancedSettingsModel
        ListElement {
            settingName: "Wide - Ratio"
            setting: "0.64,0.65,0.66,0.67,0.68,0.69,0.70,0.71,0.72,0.73,0.74,0.75,0.76,0.77,0.78,0.79,0.80,0.81,0.82,0.83,0.84,0.85,0.86,0.87,0.88,0.89,0.90,0.91,0.92,0.93,0.94,0.95,0.96,0.97,0.98,0.99,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.10,0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.19,0.20,0.21,0.22,0.23,0.24,0.25,0.26,0.27,0.28,0.29,0.30,0.31,0.32,0.33,0.34,0.35,0.36,0.37,0.38,0.39,0.40,0.41,0.42,0.43,0.44,0.45,0.46,0.47,0.48,0.49,0.50,0.51,0.52,0.53,0.54,0.55,0.56,0.57,0.58,0.59,0.60,0.61,0.62,0.63"
            settingNameDisplay: qsTr("Wide - Ratio")

        }
        ListElement {
            settingName: "Tall - Ratio"
            setting: "0.66,0.67,0.68,0.69,0.7,0.71,0.72,0.73,0.74,0.75,0.76,0.77,0.78,0.79,0.80,0.81,0.82,0.83,0.84,0.85,0.86,0.87,0.88,0.89,0.90,0.91,0.92,0.93,0.94,0.95,0.96,0.97,0.98,0.99,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.10,0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.19,0.20,0.21,0.22,0.23,0.24,0.25,0.26,0.27,0.28,0.29,0.30,0.31,0.32,0.33,0.34,0.35,0.36,0.37,0.38,0.39,0.40,0.41,0.42,0.43,0.44,0.45,0.46,0.47,0.48,0.49,0.50,0.51,0.52,0.53,0.54,0.55,0.56,0.57,0.58,0.59,0.60,0.61,0.62,0.63,0.64,0.65"
            settingNameDisplay: qsTr("Tall - Ratio")
        }
        ListElement {
            settingName: "Show loading details"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Show loading details")
            settingDisplay: qsTr("No,Yes")
        }
    }

    property var advancedPage: {
        return {
            pageName: qsTr("Advanced") + api.tr,
            listmodel: advancedSettingsModel
        }
    }

    ListModel {
        id: showcaseSettingsModel
        ListElement {
            settingName: "Number of games showcased"
            setting: "15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,1,2,3,4,5,6,7,8,9,10,11,12,13,14"
            settingNameDisplay: qsTr("Number of games showcased")

        }
        ListElement {
            settingName: "Change favorite display automatically"
            setting: "Yes,No"
            settingNameDisplay: qsTr("Change favorite display automatically")
            settingDisplay: qsTr("Yes,No")
        }
        ListElement {
            settingName: "Collection 1"
            setting: "Recently Played,Most Played,Recommended,Top by Publisher,Top by Genre,None,Favorites"
            settingNameDisplay: qsTr("Collection 1")
            settingDisplay: qsTr("Recently Played,Most Played,Recommended,Top by Publisher,Top by Genre,None,Favorites")
        }
        ListElement {
            settingName: "Collection 1 - Thumbnail"
            setting: "Wide,Tall,Square"
            settingNameDisplay: qsTr("Collection 1 - Thumbnail")
            settingDisplay: qsTr("Wide,Tall,Square")
        }
        ListElement {
            settingName: "Collection 2"
            setting: "Most Played,Recommended,Top by Publisher,Top by Genre,None,Favorites,Recently Played"
            settingNameDisplay: qsTr("Collection 2")
            settingDisplay: qsTr("Most Played,Recommended,Top by Publisher,Top by Genre,None,Favorites,Recently Played")
        }
        ListElement {
            settingName: "Collection 2 - Thumbnail"
            setting: "Tall,Square,Wide"
            settingNameDisplay: qsTr("Collection 2 - Thumbnail")
            settingDisplay: qsTr("Tall,Square,Wide")
        }
        ListElement {
            settingName: "Collection 3"
            setting: "Top by Publisher,Top by Genre,None,Favorites,Recently Played,Most Played,Recommended"
            settingNameDisplay: qsTr("Collection 3")
            settingDisplay: qsTr("Top by Publisher,Top by Genre,None,Favorites,Recently Played,Most Played,Recommended")
        }
        ListElement {
            settingName: "Collection 3 - Thumbnail"
            setting: "Wide,Tall,Square"
            settingNameDisplay: qsTr("Collection 3 - Thumbnail")
            settingDisplay: qsTr("Wide,Tall,Square")
        }
        ListElement {
            settingName: "Collection 4"
            setting: "Top by Genre,None,Favorites,Recently Played,Most Played,Recommended,Top by Publisher"
            settingNameDisplay: qsTr("Collection 4")
            settingDisplay: qsTr("Top by Genre,None,Favorites,Recently Played,Most Played,Recommended,Top by Publisher")
        }
        ListElement {
            settingName: "Collection 4 - Thumbnail"
            setting: "Tall,Square,Wide"
            settingNameDisplay: qsTr("Collection 4 - Thumbnail")
            settingDisplay: qsTr("Tall,Square,Wide")
        }
        ListElement {
            settingName: "Collection 5"
            setting: "None,Favorites,Recently Played,Most Played,Recommended,Top by Publisher,Top by Genre"
            settingNameDisplay: qsTr("Collection 5")
            settingDisplay: qsTr("None,Favorites,Recently Played,Most Played,Recommended,Top by Publisher,Top by Genre")
        }
        ListElement {
            settingName: "Collection 5 - Thumbnail"
            setting: "Wide,Tall,Square"
            settingNameDisplay: qsTr("Collection 5 - Thumbnail")
            settingDisplay: qsTr("Wide,Tall,Square")
        }

    }

    property var showcasePage: {
        return {
            pageName: qsTr("Home page") + api.tr,
            listmodel: showcaseSettingsModel
        }
    }

    ListModel {
        id: gridSettingsModel

        ListElement {
            settingName: "Grid Thumbnail"
            setting: "Wide,Tall,Square,Box Art"
            settingNameDisplay: qsTr("Grid Thumbnail")
            settingDisplay: qsTr("Wide,Tall,Square,Box Art")

        }
        ListElement {
            settingName: "Number of columns"
            setting: "3,4,5,6,7,8"
            settingNameDisplay: qsTr("Number of columns")
        }
    }

    property var gridPage: {
        return {
            pageName: qsTr("Platform page") + api.tr,
            listmodel: gridSettingsModel
        }
    }

    ListModel {
        id: gameSettingsModel

        ListElement {
            settingName: "Game Background"
            setting: "Screenshot,Fanart"
            settingNameDisplay: qsTr("Game Background")
            settingDisplay: qsTr("Screenshot,Fanart")
        }
        ListElement {
            settingName: "Game Background overlay"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Game Background overlay")
            settingDisplay: qsTr("No,Yes")
        }
        ListElement {
            settingName: "Game Logo"
            setting: "Show,Text only,Hide"
            settingNameDisplay: qsTr("Game Logo")
            settingDisplay: qsTr("Show,Text only,Hide")
        }
        ListElement {
            settingName: "Game Logo position"
            setting: "Left,Right"
            settingNameDisplay: qsTr("Game Logo position")
            settingDisplay: qsTr("Left,Right")
        }
        ListElement {
            settingName: "System Logo"
            setting: "Show,Hide,Show if no overlay"
            settingNameDisplay: qsTr("System Logo")
            settingDisplay: qsTr("Show,Hide,Show if no overlay")
        }
        ListElement {
            settingName: "System Logo position"
            setting: "Left,Right"
            settingNameDisplay: qsTr("System Logo position")
            settingDisplay: qsTr("Left,Right")
        }
        ListElement {
            settingName: "Default to full details"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Default to full details")
            settingDisplay: qsTr("No,Yes")
        }
        ListElement {
            settingName: "Video preview"
            setting: "Yes,No"
            settingNameDisplay: qsTr("Video preview")
            settingDisplay: qsTr("Yes,No")
        }
        ListElement {
            settingName: "Video preview overlay"
            setting: "Yes,No"
            settingNameDisplay: qsTr("Video preview overlay")
            settingDisplay: qsTr("Yes,No")
        }
        ListElement {
            settingName: "Overlays source"
            setting: "Default,Share"
            settingNameDisplay: qsTr("Overlays source")
            settingDisplay: qsTr("Default,Share")
        }
        ListElement {
            settingName: "Video preview audio"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Video preview audio")
            settingDisplay: qsTr("No,Yes")
        }
        ListElement {
            settingName: "Randomize Background"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Randomize Background")
            settingDisplay: qsTr("No,Yes")
        }
        ListElement {
            settingName: "Blur Background"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Blur Background")
            settingDisplay: qsTr("No,Yes")
        }
        ListElement {
            settingName: "Show scanlines"
            setting: "Yes,No"
            settingNameDisplay: qsTr("Show scanlines")
            settingDisplay: qsTr("Yes,No")
        }
        ListElement {
            settingName: "Show file name"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Show file name")
            settingDisplay: qsTr("No,Yes")
        }
        ListElement {
            settingName: "Show play stats"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Show play stats")
            settingDisplay: qsTr("No,Yes")
        }
        ListElement {
            settingName: "Demo triggering delay (in minutes)"
            setting: "Deactivated,1,2,3,4,5,10,20,30"
            settingNameDisplay: qsTr("Demo triggering delay (in minutes)")
            settingDisplay: qsTr("Deactivated,1,2,3,4,5,10,20,30")
        }
        ListElement {
            settingName: "Demo show full details"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Demo show full details")
            settingDisplay: qsTr("No,Yes")
        }
    }

    property var gamePage: {
        return {
            pageName: qsTr("Game details") + api.tr,
            listmodel: gameSettingsModel
        }
    }

    property var settingsArr: [designerPage, generalPage, showcasePage, gridPage, gamePage, advancedPage]
    property real itemheight: vpx(50)

    ListModel {
        id: myCollectionsSettingsModel
        ListElement {
            settingName: "Collection name"
            setting: "to edit"
            settingNameDisplay: qsTr("Collection name")

        }
//for later when menu for all collections will be available		
/*      ListElement {
            settingName: "Collection icon"
            setting: "idea: to select from share icons directory"
        }*/		
//for later when menu for all collections will be available		
/*      ListElement {
            settingName: "Collection Thumbnail"
            setting: "Wide,Tall,Square"
        }*/
        ListElement {
            settingName: "Name filter"
            setting: "to edit"
            settingNameDisplay: qsTr("Name filter")
        }
        ListElement {
            settingName: "Region/Country filter"
            setting: "to edit"
            settingNameDisplay: qsTr("Region/Country filter")
        }
        ListElement {
            settingName: "Nb players"
            setting: "1+,2,2+,3,3+,4,4+,5,1"
            settingNameDisplay: qsTr("Nb players")
        }
        ListElement {
            settingName: "Rating"
            setting: "All,1.0,0.9+,0.8+,0.7+,0.6+,0.5+,0.4+,0.3+,0.2+,0.1+"
            settingNameDisplay: qsTr("Rating")
            settingDisplay: qsTr("All,1.0,0.9+,0.8+,0.7+,0.6+,0.5+,0.4+,0.3+,0.2+,0.1+")
        }
        ListElement {
            settingName: "Favorite"
            setting: "No,Yes"
            settingNameDisplay: qsTr("Favorite")
            settingDisplay: qsTr("No,Yes")
        }
        ListElement {
            settingName: "Genre filter"
            setting: "to edit"
            settingNameDisplay: qsTr("Genre filter")
        }
        ListElement {
            settingName: "Publisher filter"
            setting: "to edit"
            settingNameDisplay: qsTr("Publisher filter")
        }
        ListElement {
            settingName: "Developer filter"
            setting: "to edit"
            settingNameDisplay: qsTr("Developer filter")
        }
        ListElement {
            settingName: "System"
            setting: "to edit"
            settingNameDisplay: qsTr("System")
        }
        ListElement {
            settingName: "File name filter"
            setting: "to edit"
            settingNameDisplay: qsTr("File name filter")
        }
        ListElement {
            settingName: "Release year filter"
            setting: "to edit"
            settingNameDisplay: qsTr("Release year filter")
        }
        ListElement {
            settingName: "Exclusion filter"
            setting: "to edit"
            settingNameDisplay: qsTr("Exclusion filter")
        }
    }

     property var myCollections: {
        return {
            pageName: qsTr("My Collections") + api.tr,
            listmodel: myCollectionsSettingsModel
        }
    }

	property var settingsCol: []

	Component.onCompleted: {
		//for 10 collections to display on showcase (main page)
		//-> possibility to have more in the future for HomePage
		//but still to find a solution to manage HorizontalCollection dynamically in ShowcaseViewMenu.qml
		addShowcaseSettingsModel(5);//set to 5 in addition of the 5 existing ones for the moment, to have 10 in total
		//generate My collection(s), no limit ;-)
		initializeMyCollections();
	}

	function addShowcaseSettingsModel(nb_collections)
	{
		var initialCount = 5;
		//add collections to initial 5 ones - we kept initial one to propose default configuration for users
		for(var i = 1; i <= nb_collections; ++i) {
            showcaseSettingsModel.append({"settingName": "Collection " + (i+initialCount),
                                          "setting": "None,Favorites,Recently Played,Most Played,Recommended,Top by Publisher,Top by Genre",
                                          "settingNameDisplay": qsTr("Collection") + " " + api.tr + (i+initialCount),
                                          "settingDisplay": qsTr("None,Favorites,Recently Played,Most Played,Recommended,Top by Publisher,Top by Genre") + api.tr});
            showcaseSettingsModel.append({"settingName": "Collection " + (i+initialCount) + " - Thumbnail",
                                          "setting": "Wide,Tall,Square",
                                          "settingNameDisplay": qsTr("Collection") + " " + api.tr + (i+initialCount) + " - " + qsTr("Thumbnail"),
                                          "settingDispolay": qsTr("Wide,Tall,Square") + api.tr});
        }
	}
	
	function initializeMyCollections()
	{
		var i = 1;
		let value = "";
		do{

			value = (api.memory.has("My Collection " + i + " - Collection name")) ? api.memory.get("My Collection " + i + " - Collection name") : null;
			if (value !== null)
			{
				//console.log("My Collection " + i + " - Collection name");
				//Add the new collection in settings menu
                settingsCol[settingsCol.length] = {"collectionName": "My Collection " + i,"collectionNameDisplay": qsTr("My Collection") + api.tr + " " + i,"listmodel": "myCollectionsSettingsModel"};
				// Add the new collection in selections of Home Page collections
				addMyCollectionsToHomePageSelections(i);
				i = i + 1;
			}
		}
		while(value !== null)
		//Set of model to force binding
		collectionslist.model = settingsCol;
	}

	function addMyCollection()
	{
		var i = settingsCol.length + 1;
		//Add the new collection in settings menu
        settingsCol[settingsCol.length] = {"collectionName": "My Collection " + i,"collectionNameDisplay": qsTr("My Collection") + api.tr + " " + i,"listmodel": "myCollectionsSettingsModel"};
		// Add the new collection in selections of Home Page collections
		addMyCollectionsToHomePageSelections(i);
		//save empty parameter for collection name to record in configuration file
		api.memory.set("My Collection " + i + " - Collection name","");
		//Set of model to force binding
		collectionslist.model = settingsCol;
		collectionslist.currentIndex = collectionslist.count - 1;
		settingsList.model = myCollections.listmodel;
	}

	function addMyCollectionsToHomePageSelections(index)
	{
		var i = index;
		var f = 1;
		for(var j = 0; j < showcaseSettingsModel.count; ++j) {
			//console.log("Collection " + f);
			//console.log(showcaseSettingsModel.get(j).settingName);
			if (showcaseSettingsModel.get(j).settingName === ("Collection " + f))
			{
				//Add this "My Collection n" to the list
				showcaseSettingsModel.get(j).setting = showcaseSettingsModel.get(j).setting + "," + "My Collection " + i
                //Add this "My Collection n" to the display list
                showcaseSettingsModel.get(j).settingDisplay = showcaseSettingsModel.get(j).settingDisplay + "," + qsTr("My Collection") + api.tr + " " + i
				f = f + 1;
			}
				
		}
	}

	function deleteLastCollection()
	{
		var i = settingsCol.length;
		//reset to null parameter for collection name to record in configuration file
		api.memory.set("My Collection " + i + " - Collection name",null);
		//remove last element by decreasing size
		settingsCol.length = i - 1;
		//Set of model to force binding
		collectionslist.model = settingsCol;
		//if 0 or less, no settingslist should be valid
		if(collectionslist.count <= 0) settingsList.model = null;
		else collectionslist.currentIndex = collectionslist.count - 1;
	}	
	

	//Set properties of ListModel from a function
	function createMyCollectionsSettingsModel(index)
	{
		//Add "My Collection X - " to all settingName
		for (var i = 0; i <= myCollectionsSettingsModel.count-1; i++) {
            myCollectionsSettingsModel.setProperty(i,"settingPrefix", "My Collection" + " " + (index+1) + " - ");
            //add display one also now
            myCollectionsSettingsModel.setProperty(i,"settingPrefixDisplay", qsTr("My Collection") + api.tr + " " + (index+1) + " - ");
        	}	
	}

    Rectangle {
        id: header

        anchors {
            top: parent.top
            left: parent.left
            //right: parent.right
        }
        height: vpx(75)
		width: headertitle.contentWidth
        color: theme.main

        // Platform title
        Text {
            id: headertitle
            
            text: qsTr("Settings") + api.tr
            
            anchors {
                top: parent.top;
                left: parent.left; leftMargin: globalMargin
                bottom: parent.bottom
            }
            
            color: theme.text
            font.family: titleFont.name
            font.pixelSize: vpx(30)
            font.bold: true
			opacity: 1
            horizontalAlignment: Text.AlignHLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight

            // Mouse/touch functionality
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    previousScreen();
                }
            }
        }
    }

    ListView {
        id: pagelist

        focus: true
        anchors {
            top: header.bottom
            //bottom: parent.bottom; bottomMargin: helpMargin
			left: parent.left; leftMargin: globalMargin
        }
		height: contentHeight
        width: vpx(300)
        model: settingsArr
        delegate: Component {
            id: pageDelegate

            Item {
                id: pageRow

                property bool selected: ListView.isCurrentItem && pagelist.focus

                width: ListView.view.width
                height: itemheight

                // Page name
                Text {
                    id: pageNameText

                    text: modelData.pageName
                    color: theme.text
                    font.family: subtitleFont.name
                    font.pixelSize: vpx(22)
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    opacity: selected ? 1 : 0.2

                    width: contentWidth
                    height: parent.height
                    anchors {
                        left: parent.left; leftMargin: vpx(25)
                    }
                }

                // Mouse/touch functionality
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: settings.MouseHover === "Yes"
                    onEntered: { sfxNav.play(); }
                    onClicked: {
                        sfxNav.play();
                        pagelist.currentIndex = index;
						settingsList.model = settingsArr[pagelist.currentIndex].listmodel;
                        settingsList.focus = true;
                    }
                }

            }
        }

        Keys.onUpPressed: { 
			sfxNav.play(); decrementCurrentIndex();
			settingsList.model = settingsArr[pagelist.currentIndex].listmodel;			
			}
        Keys.onDownPressed: { 
			sfxNav.play(); 
			var previousIndex = currentIndex;
			incrementCurrentIndex();
			if (previousIndex == currentIndex)
			{
				pagelist.focus = false
				collectionslist.focus = true
				displayMyCollectionsHelp(true);
				headertitleCollections.opacity = 1
				headertitle.opacity = 0.2
				collectionslist.currentIndex = 0;
				if(collectionslist.count!=0) settingsList.model = myCollections.listmodel;
				else settingsList.model = null;
				
			}
			else 
			{
				settingsList.model = settingsArr[pagelist.currentIndex].listmodel;	
			}
 		}
        Keys.onPressed: {
            // Accept
            if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                event.accepted = true;
                sfxAccept.play();
                settingsList.focus = true;
            }
            // Back
            if (api.keys.isCancel(event) && !event.isAutoRepeat) {
                event.accepted = true;
                previousScreen();
            }
        }

    }

	
    Rectangle {
        id: headerCollections

        anchors {
            top: pagelist.bottom
            left: parent.left
            //right: parent.right
        }
        height: vpx(75)
		width: headertitleCollections.contentWidth
        color: theme.main

        // Collections title
        Text {
            id: headertitleCollections
            
            text: qsTr("My Collections") + api.tr
            
            anchors {
                top: parent.top;
                left: parent.left; leftMargin: globalMargin
                bottom: parent.bottom
            }
            
            color: theme.text
            font.family: titleFont.name
            font.pixelSize: vpx(30)
            font.bold: true
			opacity: 0.2
            horizontalAlignment: Text.AlignHLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight

            // Mouse/touch functionality
            MouseArea {
                anchors.fill: parent
                onClicked: {
					//TO DO // NO ACTION for the moment
                }
            }
        }
    }

	function displayMyCollectionsHelp(visible)
	{
		if (visible)
		{
			//add help for My Collections
            settingsHelpModel.append({"name":qsTr("Delete 'last' collection"), "button":"details"});
            settingsHelpModel.append({"name":qsTr("Add 'new' collection"), "button":"filters"});
		}
		else
		{
            //remove the last 2 indexes corresponding to append done before.
			settingsHelpModel.remove((settingsHelpModel.count)-1);
			settingsHelpModel.remove((settingsHelpModel.count)-1);
		}
	}

    ListView {
        id: collectionslist

		onCurrentIndexChanged: createMyCollectionsSettingsModel(currentIndex)
        focus: false
		clip: true	
		
        anchors {
            top: headerCollections.bottom
            bottom: parent.bottom; bottomMargin: helpMargin
			left: parent.left; leftMargin: globalMargin
        }
       width: vpx(300)
        delegate: Component {
            id: collectionDelegate

            Item {
                id: collectionRow

                property bool selected: ListView.isCurrentItem && collectionslist.focus

                width: ListView.view.width
                height: itemheight

                // Collection name
                Text {
                    id: collectionNameText

                    text: modelData.collectionNameDisplay
                    color: theme.text
                    font.family: subtitleFont.name
                    font.pixelSize: vpx(22)
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    opacity: collectionRow.selected ? 1 : 0.2

                    width: contentWidth
                    height: parent.height
                    anchors {
                        left: parent.left; leftMargin: vpx(25)
                    }
                }

                // Mouse/touch functionality
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: settings.MouseHover === "Yes"
                    onEntered: { sfxNav.play(); }
                    onClicked: {
                        sfxNav.play();
                        collectionslist.currentIndex = index;
						settingsList.model = myCollections.listmodel;
                        settingsList.focus = true;
                    }
                }

            }
        }

        Keys.onUpPressed: { 
			sfxNav.play(); 
			var previousIndex = currentIndex;
			decrementCurrentIndex() 
			if (previousIndex == currentIndex)
			{
				collectionslist.focus = false;
				displayMyCollectionsHelp(false);
				headertitleCollections.opacity = 0.2
				headertitle.opacity = 1				
				pagelist.focus = true;
				settingsList.model = settingsArr[pagelist.currentIndex].listmodel;
			}
			else 
			{
				if(collectionslist.count!=0) settingsList.model = myCollections.listmodel;
				else settingsList.model = null;
			}
			//reset index of listview for settingsList
			settingsList.currentIndex = 0;
		}
        Keys.onDownPressed: { 
			sfxNav.play(); incrementCurrentIndex();
			if(collectionslist.count!=0) settingsList.model = myCollections.listmodel;
			else settingsList.model = null;
			//reset index of listview for settingsList
			settingsList.currentIndex = 0;			
		}
        Keys.onPressed: {
            // Accept
            if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                event.accepted = true;
                sfxAccept.play();
				if (settingsList.model !== null) settingsList.focus = true;
            }
            // Back
            if (api.keys.isCancel(event) && !event.isAutoRepeat) {
                event.accepted = true;
                previousScreen();
            }
			
			// Create a 'new' collection
			if (api.keys.isFilters(event) && !event.isAutoRepeat) {
                event.accepted = true;
                sfxToggle.play()
				//create new collection
				addMyCollection();
            }
    		
			// Remove 'last' collection
		    if (api.keys.isDetails(event) && !event.isAutoRepeat) {
		        event.accepted = true;
				//delete only if any collection has been created
				if(collectionslist.count >= 1)
				{
					//confirm deletion
					var i = settingsCol.length;
                    collectionDeletionDialogBoxLoader.item.title = qsTr("Delete") + " '" + qsTr("My Collection") + api.tr + " " + i + "'";
                    collectionDeletionDialogBoxLoader.item.message = qsTr("You are deleting this collection") + api.tr + "...\n\n"
                                                                    + qsTr("Collection name") + ": " + api.memory.get("My Collection " + i + " - Collection name") + "\n"
                                                                    + qsTr("Name filter")+ ": " + api.memory.get("My Collection " + i + " - Name filter");
					collectionDeletionDialogBoxLoader.focus = true;
				}
		    } 			
			
        }

    }


    Rectangle {
        anchors {
            left: pagelist.right;
            top: pagelist.top; bottom: pagelist.bottom
        }
        width: vpx(1)
        color: theme.text
        opacity: 0.1
    }

    ListView {
        id: settingsList

        model: settingsArr[pagelist.currentIndex].listmodel;
        property string localeName: api.internal.settings.locales.currentName
        onLocaleNameChanged:{
            //console.log("onLocaleChanged");
            if(typeof(settingsArr[pagelist.currentIndex]) !== "undefined"){
                if(typeof(settingsArr[pagelist.currentIndex].listmodel) !== "undefined"){
                    //reset model to force refresh
                    settingsList.model = null;
                    //reassign model to forece refresh
                    settingsList.model = settingsArr[pagelist.currentIndex].listmodel;
                }
            }
        }

        delegate: settingsDelegate
        
        anchors {
            top: header.bottom; 
			bottom: parent.bottom; bottomMargin: helpMargin
            left: pagelist.right; leftMargin: globalMargin
            right: parent.right; rightMargin: globalMargin
        }
        width: vpx(500)

        spacing: vpx(0)
        orientation: ListView.Vertical

        preferredHighlightBegin: settingsList.height / 2 - itemheight
        preferredHighlightEnd: settingsList.height / 2
        highlightRangeMode: ListView.ApplyRange
        highlightMoveDuration: 100
        clip: true

        Component {
            id: settingsDelegate

            Item {
                id: settingRow
                //simple parameter without translation
                property string fullSettingName: (typeof(settingPrefix) !== "undefined") ? settingPrefix + settingName : settingName
                property variant settingList: (setting !== "to edit") ? setting.split(',') : ""
                //new parameter to display with translation
                property string fullSettingNameDisplay: (typeof(settingNameDisplay) !== "undefined") ? ((typeof(settingPrefixDisplay) !== "undefined") ? settingPrefixDisplay + settingNameDisplay : settingNameDisplay) : ""
                property variant settingListDisplay: (setting !== "to edit") ? ((typeof(settingDisplay) !== "undefined") ? settingDisplay.split(',') : "") : ""

                property bool selected: ListView.isCurrentItem && settingsList.focus

                property int savedIndex: {
					//console.log("savedIndex refresh for :",fullSettingName + 'Index');
					//console.log("savedIndex refresh for setting:",setting);
					if (setting !== "to edit") 
					{
						//console.log(fullSettingName + "Index: ",api.memory.get(fullSettingName + 'Index'));
						var value = api.memory.get(fullSettingName + 'Index') || 0;
						if (value < settingList.length) return value;
						else return 0;
					
					}
					else return 0;
				}

                function saveSetting() {
					//console.log("saveSetting():" + fullSettingName + " saved setting:",setting);
					if (setting !== "to edit")
					{
						api.memory.set(fullSettingName + 'Index', savedIndex);
						//console.log("saveSetting():" + fullSettingName + 'Index', savedIndex);
						api.memory.set(fullSettingName, settingList[savedIndex]);
						//console.log("saveSetting():" + fullSettingName + " : ", settingList[savedIndex]);
					}
					else
					{
						//console.log("saveSetting():" + fullSettingName + " : ", settingtextfield.text);
						api.memory.set(fullSettingName, settingtextfield.text);
					}
                }

                function nextSetting() {
                    if (savedIndex != settingList.length -1)
                        savedIndex++;
                    else
                        savedIndex = 0;
                }

                function prevSetting() {
                    if (savedIndex > 0)
                        savedIndex--;
                    else
                        savedIndex = settingList.length -1;
                }

                width: ListView.view.width
                height: itemheight

                // Setting name
                Text {
                    id: settingNameText

                    text: (fullSettingNameDisplay !== "") ? (fullSettingNameDisplay + ": ") : (fullSettingName + ": ")
                    color: theme.text
                    font.family: subtitleFont.name
                    font.pixelSize: vpx(20)
                    verticalAlignment: Text.AlignVCenter
                    opacity: selected ? 1 : 0.2

                    width: contentWidth
                    height: parent.height
                    anchors {
                        left: parent.left; leftMargin: vpx(25)
                    }
                }
                
				// Setting list value
                Text {
                    id: settingtext;
					visible: (setting !== "to edit")
	
                    text:{
						if (setting !== "to edit")
						{
							//tips to refresh index (and to force update of text as not possible when we reuse the same listview as for collection)
                            //console.log("api.memory.get(" + fullSettingName + "'Index') : ",api.memory.get(fullSettingName + 'Index'));
                            var indexFromSettings = (api.memory.get(fullSettingName + 'Index') || 0);
							//-----------------------------------------------------------------------
                            //console.log(fullSettingName + " : ",(setting !== "to edit") ? settingList[indexFromSettings] : "");
                            if(settingListDisplay !== ""){
                                //console.log("settingListDisplay[indexFromSettings] : ",settingListDisplay[indexFromSettings]);
                                return settingListDisplay[indexFromSettings];
                            }
                            else{
                                //console.log("settingList[indexFromSettings] : ",settingList[indexFromSettings]);
                                return settingList[indexFromSettings];
                            }
						}
						else return "";
					}
                    color: theme.text
                    font.family: subtitleFont.name
                    font.pixelSize: vpx(20)
                    verticalAlignment: Text.AlignVCenter
                    opacity: selected ? 1 : 0.2

                    height: parent.height
					anchors {
                        right: parent.right; rightMargin: vpx(25)
                    }
                }

				// Setting edit box value
                TextField {
                    id: settingtextfield;
					visible: (setting === "to edit")
					focus: selected					
					onFocusChanged: if (setting === "to edit") saveSetting();
                    readOnly: true //set to readonly by default // to unlock if we press A and if setting = "to edit"
                    text:  {
						var value = "";
						if (setting === "to edit") 
						{
							value = (api.memory.get(fullSettingName)) ? api.memory.get(fullSettingName) : "";
						}
						return value;
					}
                    color: "black"
                    font.family: subtitleFont.name
                    font.pixelSize: vpx(20)
                    verticalAlignment: Text.AlignVCenter
                    opacity: selected ? 1 : 0.2

                    height: parent.height
                    anchors {
                        right: parent.right; rightMargin: vpx(25)
						left: settingNameText.right ; leftMargin: vpx(25)
                    }
                }				


                Rectangle {
                    anchors {
                        left: parent.left; leftMargin: vpx(25)
                        right: parent.right; rightMargin: vpx(25)
                        bottom: parent.bottom
                    }
                    color: theme.text
                    opacity: selected ? 0.1 : 0
                    height: vpx(1)
                }

                // Input handling
                // Next setting
                Keys.onRightPressed: {
                    sfxToggle.play()
                    nextSetting();
                    saveSetting();
                }
                // Previous setting
                Keys.onLeftPressed: {
                    sfxToggle.play();
                    prevSetting();
                    saveSetting();
                }

				Keys.onReleased:{
					if (setting === "to edit" && settingtextfield.readOnly === true ) {
						event.accepted = virtualKeyboardOnReleased(event);
						//to reset demo if needed
						if (event.accepted) resetDemo();
					}
				}

				property bool active : false //set to false by default
				onFocusChanged:{
						// console.log("-----onFocusChanged-----");
						// console.log("settingtextfield.focus : ", settingtextfield.focus);
						// console.log("settingtextfield.readOnly : ", settingtextfield.readOnly);
						// console.log("active : ",active);
						// console.log("selected : ",selected);
					    if(settingtextfield.focus) active = false; //set to false to ahve the selection
				}
                Keys.onPressed: {
					// console.log("-----Before update-----");
					// console.log("event.accepted : ", event.accepted);
					// console.log("settingtextfield.focus : ", settingtextfield.focus);
					// console.log("settingtextfield.readOnly : ", settingtextfield.readOnly);
					// console.log("active : ",active);
					// console.log("selected : ",selected);
						
					// Accept
                    if (api.keys.isAccept(event) && !event.isAutoRepeat) {
						event.accepted = true;
						sfxToggle.play();
						nextSetting();
						saveSetting();
						//to activate edition (and potantially virtual keyboard)
						if (setting === "to edit" && settingtextfield.readOnly === true ) {
							settingtextfield.readOnly = false;
							settingtextfield.focus = true;
						}
                    }
                    // Back
                    else if (api.keys.isCancel(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        sfxBack.play();
						//to deactivate edition (and potantially virtual keyboard)
						if (setting === "to edit" && settingtextfield.readOnly === false ) {
							settingtextfield.readOnly = true;
							settingList.focus = true;
                            active = false; //to force to reset to false in this case
						}
						//else we come back to parent menu
						else if (settingsList.model === myCollections.listmodel) collectionslist.focus = true;
						else pagelist.focus = true;
                    }
					if (setting === "to edit" && settingtextfield.readOnly === false ) {
						event.accepted, settingtextfield.focus, active = virtualKeyboardOnPressed(event,settingtextfield,active);
					}
					// console.log("-----After update-----");
					// console.log("event.accepted : ", event.accepted);
					// console.log("settingtextfield.focus : ", settingtextfield.focus);
					// console.log("settingtextfield.readOnly : ", settingtextfield.readOnly);
					// console.log("active : ",active);
					// console.log("selected : ",selected);
                }

                // Mouse/touch functionality
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: settings.MouseHover === "Yes"
                    onEntered: { sfxNav.play(); }
                    onClicked: {
                        sfxToggle.play();
                        if(selected){
                            nextSetting();
                            saveSetting();
                        } else {
                            settingsList.focus = true;
                            settingsList.currentIndex = index;
                        }
                    }
                }
            }
        }

        Keys.onUpPressed: { sfxNav.play(); decrementCurrentIndex() }
        Keys.onDownPressed: { sfxNav.play(); incrementCurrentIndex() }
    }

    // Helpbar buttons
    ListModel {
        id: settingsHelpModel

        ListElement {
            name: qsTr("Back")
            button: "cancel"
        }
        ListElement {
            name: qsTr("Next/Change/Edit")
            button: "accept"
		}
	}
    
    onFocusChanged: { if (focus) currentHelpbarModel = settingsHelpModel; }

    Component {
        id: collectionDeletionDialogBox
		GenericOkCancelDialog
		{
			focus: true
            title: qsTr("Deletion 'Last' Collection") + api.tr
            message: qsTr("Are you sure that you want to delete this collection ?") + api.tr
			//symbol: "\u21BB"
 			//onAccept: 
				// console.log("Collection deleted");
			// onCancel: 
				// console.log("No deletion");
		}
	}
    Loader {
        id: collectionDeletionDialogBoxLoader
        anchors.fill: parent
		sourceComponent: collectionDeletionDialogBox
		active: true
    }
    Connections {
        target: collectionDeletionDialogBoxLoader.item
		function onAccept() {
			//console.log("Collection deleted !");			
			//delete last collection
			deleteLastCollection();
			collectionslist.focus = true; 
		}
        function onCancel() {
			//console.log("Collection kept !");		
			collectionslist.focus = true;
		}
    }	
}
