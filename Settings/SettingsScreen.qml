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
        id: settingsModel

        /*ListElement {
            settingName: "Game View"
            setting: "Grid,Vertical List"
        }*/
        ListElement {
            settingName: "Allow video thumbnails"
            setting: "Yes,No"
        }
        ListElement {
            settingName: "Play video thumbnail audio"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Hide logo when thumbnail video plays"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Animate highlight"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Enable mouse hover"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Always show titles"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Hide button help"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Hide Clock"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Color Layout"
            setting: "Original, Dark Green,Light Green,Turquoise,Dark Red,Light Red,Dark Pink,Light Pink,Dark Blue,Light Blue,Orange,Yellow,Magenta,Purple,Dark Gray,Light Gray,Steel,Stone,Dark Brown,Light Brown"
        }
        ListElement {
            settingName: "Color Background"
            setting: "Original,Black,Gray,Blue,Green,Red"
        }
	ListElement {
		settingName: "System Logo Style"
        setting: "Color,Steel,Carbon,White,Black"
        }
    }

    property var generalPage: {
        return {
            pageName: "General",
            listmodel: settingsModel
        }
    }

    ListModel {
        id: advancedSettingsModel
        ListElement {
            settingName: "Wide - Ratio"
            setting: "0.64,0.65,0.66,0.67,0.68,0.69,0.70,0.71,0.72,0.73,0.74,0.75,0.76,0.77,0.78,0.79,0.80,0.81,0.82,0.83,0.84,0.85,0.86,0.87,0.88,0.89,0.90,0.91,0.92,0.93,0.94,0.95,0.96,0.97,0.98,0.99,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.10,0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.19,0.20,0.21,0.22,0.23,0.24,0.25,0.26,0.27,0.28,0.29,0.30,0.31,0.32,0.33,0.34,0.35,0.36,0.37,0.38,0.39,0.40,0.41,0.42,0.43,0.44,0.45,0.46,0.47,0.48,0.49,0.50,0.51,0.52,0.53,0.54,0.55,0.56,0.57,0.58,0.59,0.60,0.61,0.62,0.63"
        }
        ListElement {
            settingName: "Tall - Ratio"
            setting: "0.66,0.67,0.68,0.69,0.7,0.71,0.72,0.73,0.74,0.75,0.76,0.77,0.78,0.79,0.80,0.81,0.82,0.83,0.84,0.85,0.86,0.87,0.88,0.89,0.90,0.91,0.92,0.93,0.94,0.95,0.96,0.97,0.98,0.99,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.10,0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.19,0.20,0.21,0.22,0.23,0.24,0.25,0.26,0.27,0.28,0.29,0.30,0.31,0.32,0.33,0.34,0.35,0.36,0.37,0.38,0.39,0.40,0.41,0.42,0.43,0.44,0.45,0.46,0.47,0.48,0.49,0.50,0.51,0.52,0.53,0.54,0.55,0.56,0.57,0.58,0.59,0.60,0.61,0.62,0.63,0.64,0.65"
        }
    }

    property var advancedPage: {
        return {
            pageName: "Advanced",
            listmodel: advancedSettingsModel
        }
    }

    ListModel {
        id: showcaseSettingsModel
        ListElement {
            settingName: "Number of games showcased"
            setting: "15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,1,2,3,4,5,6,7,8,9,10,11,12,13,14"
        }
        ListElement {
            settingName: "Collection 1"
            setting: "Recently Played,Most Played,Recommended,Top by Publisher,Top by Genre,None,Favorites"
        }
        ListElement {
            settingName: "Collection 1 - Thumbnail"
            setting: "Wide,Tall,Square"
        }
        ListElement {
            settingName: "Collection 2"
            setting: "Most Played,Recommended,Top by Publisher,Top by Genre,None,Favorites,Recently Played"
        }
        ListElement {
            settingName: "Collection 2 - Thumbnail"
            setting: "Tall,Square,Wide"
        }
        ListElement {
            settingName: "Collection 3"
            setting: "Top by Publisher,Top by Genre,None,Favorites,Recently Played,Most Played,Recommended"
        }
        ListElement {
            settingName: "Collection 3 - Thumbnail"
            setting: "Wide,Tall,Square"
        }
        ListElement {
            settingName: "Collection 4"
            setting: "Top by Genre,None,Favorites,Recently Played,Most Played,Recommended,Top by Publisher"
        }
        ListElement {
            settingName: "Collection 4 - Thumbnail"
            setting: "Tall,Square,Wide"
        }
        ListElement {
            settingName: "Collection 5"
            setting: "None,Favorites,Recently Played,Most Played,Recommended,Top by Publisher,Top by Genre"
        }
        ListElement {
            settingName: "Collection 5 - Thumbnail"
            setting: "Wide,Tall,Square"
        }

    }

    property var showcasePage: {
        return {
            pageName: "Home page",
            listmodel: showcaseSettingsModel
        }
    }

    ListModel {
        id: gridSettingsModel

        ListElement {
            settingName: "Grid Thumbnail"
            setting: "Wide,Tall,Square,Box Art"
        }
        ListElement {
            settingName: "Number of columns"
            setting: "3,4,5,6,7,8"
        }
    }

    property var gridPage: {
        return {
            pageName: "Platform page",
            listmodel: gridSettingsModel
        }
    }

    ListModel {
        id: gameSettingsModel

        ListElement {
            settingName: "Game Background"
            setting: "Screenshot,Fanart"
        }
        ListElement {
            settingName: "Game Logo"
            setting: "Show,Text only,Hide"
        }
        ListElement {
            settingName: "Default to full details"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Video preview"
            setting: "Yes,No"
        }
        ListElement {
            settingName: "Video preview audio"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Randomize Background"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Blur Background"
            setting: "No,Yes"
        }
        ListElement {
            settingName: "Show scanlines"
            setting: "Yes,No"
        }
    }

    property var gamePage: {
        return {
            pageName: "Game details",
            listmodel: gameSettingsModel
        }
    }

    property var settingsArr: [generalPage, showcasePage, gridPage, gamePage, advancedPage]
    property real itemheight: vpx(50)

    ListModel {
        id: myCollectionsSettingsModel
        ListElement {
            settingName: "Collection name"
            setting: "to edit"
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
        }
        ListElement {
            settingName: "Region/Country filter"
            setting: "to edit"
        }		
        ListElement {
            settingName: "Nb players"
            setting: "1,1+,2,2+,3,3+,4,4+,5"
        }
        ListElement {
            settingName: "Rating"
            setting: "All,10/10,9+/10,8+/10,7+/10,6+/10,5+/10,4+/10,3+/10,2+/10,1+/10,0/10,no rate"
        }		
        ListElement {
            settingName: "Genre filter"
            setting: "to edit"
        }
        ListElement {
            settingName: "Publisher filter"
            setting: "to edit"
        }
        ListElement {
            settingName: "Developer filter"
            setting: "to edit"
        }
        ListElement {
            settingName: "System filter"
            setting: "to edit"
        }
        ListElement {
            settingName: "File name filter"
            setting: "to edit"
        }
        ListElement {
            settingName: "Release date filter"
            setting: "to edit"
        }
    }

     property var myCollections: {
        return {
            pageName: "My Collections",
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
			showcaseSettingsModel.append({"settingName": "Collection " + (i+initialCount),"setting": "None,Favorites,Recently Played,Most Played,Recommended,Top by Publisher,Top by Genre"});
			showcaseSettingsModel.append({"settingName": "Collection " + (i+initialCount) + " - Thumbnail","setting": "Wide,Tall,Square"});
		}
	}
	
	function initializeMyCollections()
	{
		var i = 1;
		let value = "";
		do{

			value = (api.memory.get("My Collection " + i + " - Collection name")) ? api.memory.get("My Collection " + i + " - Collection name") : "";
			if (value !== "")
			{
				//console.log("My Collection " + i + " - Collection name");
				settingsCol[settingsCol.length] = {"collectionName": "My Collection " + i,"listmodel": "myCollectionsSettingsModel"};
				var f = 1;
				for(var j = 0; j < showcaseSettingsModel.count; ++j) {
					//console.log("Collection " + f);
					//console.log(showcaseSettingsModel.get(j).settingName);
					if (showcaseSettingsModel.get(j).settingName === ("Collection " + f))
					{
						//Add this "My Collection n" to the list
						showcaseSettingsModel.get(j).setting = showcaseSettingsModel.get(j).setting + "," + "My Collection " + i
						f = f + 1;
					}
						
				}
				i = i + 1;
			}
		}
		while(value != "")
		//Set of model to force binding
		collectionslist.model = settingsCol;
	}

	function addCollection()
	{
		var i = settingsCol.length + 1;
		settingsCol[settingsCol.length] = {"collectionName": "My Collection " + i,"listmodel": "myCollectionsSettingsModel"};
		//Set of model to force binding
		collectionslist.model = settingsCol;
		collectionslist.currentIndex = collectionslist.count - 1;
		settingsList.model = myCollections.listmodel;
	}

	function deleteLastCollection()
	{
		var i = settingsCol.length;
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
			myCollectionsSettingsModel.setProperty(i,"settingPrefix", "My Collection " + (index+1) + " - ");
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
            
            text: "Settings"
            
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
            
            text: "My Collections"
            
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
			settingsHelpModel.append({"name":"Delete 'last' collection", "button":"details"});
			settingsHelpModel.append({"name":"Add 'new' collection", "button":"filters"});
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

                    text: modelData.collectionName
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
				addCollection();
            }
    		
			// Remove 'last' collection
		    if (api.keys.isDetails(event) && !event.isAutoRepeat) {
		        event.accepted = true;
				//delete only if any collection has been created
				if(collectionslist.count >= 1)
				{
					//confirm deletion
					var i = settingsCol.length;
					collectionDeletionDialogBoxLoader.item.title = "Delete " + "'My Collection " + i + "'";
					collectionDeletionDialogBoxLoader.item.message = "You are deleting this collection...\n\n" 
																	+ "Collection name: " + api.memory.get("My Collection " + i + " - Collection name") + "\n"
																	+ "Name filter: " +api.memory.get("My Collection " + i + " - Name filter"); 
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
				property string fullSettingName: (typeof(settingPrefix) !== "undefined") ? settingPrefix + settingName : settingName
                property bool selected: ListView.isCurrentItem && settingsList.focus
                property variant settingList: (setting !== "to edit") ? setting.split(',') : ""
                property int savedIndex: {
					//console.log("savedIndex refresh for :",fullSettingName + 'Index');
					//console.log("savedIndex refresh for setting:",setting);
					if (setting !== "to edit") 
					{
						//console.log(fullSettingName + "Index: ",api.memory.get(fullSettingName + 'Index'));
						return (api.memory.get(fullSettingName + 'Index') || 0);
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

                    text: (fullSettingName + ": ")
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
							var indexFromSettings = (api.memory.get(fullSettingName + 'Index') || 0);
							//-----------------------------------------------------------------------
							//console.log(fullSettingName + " : ",(setting !== "to edit") ? settingList[indexFromSettings] : "");
							return settingList[indexFromSettings];
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
                    text:  {
						var value = "";
						if (setting === "to edit") 
						{
							value = (api.memory.get(fullSettingName)) ? api.memory.get(fullSettingName) : "";
						}
						return value;
					}
                    color: focus ? "black" : theme.text
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

                Keys.onPressed: {
                    // Accept
                    if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        sfxToggle.play()
                        nextSetting();
                        saveSetting();
                    }
                    // Back
                    if (api.keys.isCancel(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        sfxBack.play()
                        if (settingsList.model === myCollections.listmodel) collectionslist.focus = true;
						else pagelist.focus = true;
                    }
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
            name: "Back"
            button: "cancel"
        }
        ListElement {
            name: "Next"
            button: "accept"
		}
	}
    
    onFocusChanged: { if (focus) currentHelpbarModel = settingsHelpModel; }

    Component {
        id: collectionDeletionDialogBox
		GenericOkCancelDialog
		{
			focus: true
			title: "Deletion 'Last' Collection"
			message: "Are you sure that you want to delete this collection ?"
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
