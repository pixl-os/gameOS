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
import QtGraphicalEffects 1.10
import QtQml.Models 2.12
import "../utils.js" as Utils
import QtQuick.VirtualKeyboard 2.15

FocusScope {
    id: root

    //to have access to input and know information about it if needed
    property alias searchInput : searchInput

    Item {
        id: container

        anchors.fill: parent


        Image {
            id: platformlogo

            anchors {
                top: parent.top; topMargin: vpx(10)
                bottom: parent.bottom; bottomMargin: vpx(10)
                left: parent.left; leftMargin: globalMargin
            }
            fillMode: Image.PreserveAspectFit
            source: {
	    	//to force update of currentCollection because bug identified in some case :-(
	    	currentCollection = api.collections.get(currentCollectionIndex);
                if(settings.SystemLogoStyle === "White")
                {
                    return "../assets/images/logospng/" + Utils.processPlatformName(currentCollection.shortName) + ".png";
                }
                else
                {
                    return "../assets/images/logospng/" + Utils.processPlatformName(currentCollection.shortName) + "_" + settings.SystemLogoStyle.toLowerCase() + ".png";
                }
            }
            smooth: true
            asynchronous: true

            Image{
                id: alphaLogo
                anchors.top: parent.top
                anchors.right: parent.right
                width: parent.width/2
                height: parent.height/2

                //to alert when system is in beta
                source: "../assets/images/beta.png";
                //for the moment, just check if first core for this system still low
                visible: currentCollection.getCoreCompatibilityAt(0) === "low" ? true : false
            }
        }

        // Platform title
        Text {
            id: softwareplatformtitle

            text: currentCollection.name

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
                hoverEnabled: true
                onClicked: previousScreen();
            }
        }

        ObjectModel {
            id: headermodel

            // Search bar
            Item {
                id: searchbar

                property bool selected: (buttonbar.currentIndex === 0) && root.focus
                onSelectedChanged:{
					//console.log("onSelectedChanged");
					//console.log("searchbar.selected :",searchbar.selected); 
					//console.log("searchInput.searchActive : ",searchInput.searchActive);
					//console.log("searchInput.focus : ",searchInput.focus);
                    if (!searchbar.selected && searchInput.searchActive) searchInput.searchActive = !searchInput.searchActive;
					if(searchbar.selected) {
						searchbar.focus = true;
						searchInput.cursorVisible = false;
					}
				}

                width: (searchInput.searchActive || searchTerm != "") ? vpx(250) : height
                height: vpx(40)

                Behavior on width {
                    PropertyAnimation { duration: 200; easing.type: Easing.OutQuart; easing.amplitude: 2.0; easing.period: 1.5 }
                }

                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: searchbar.selected && !searchInput.searchActive ? theme.accent : "white"
                    radius: height/2
                    opacity: searchbar.selected && !searchInput.searchActive ? 1 : searchInput.searchActive ? 0.4 : 0.2
                }

                Image {
                    id: searchicon

                    width: height
                    height: vpx(18)
                    anchors {
                        left: parent.left; leftMargin: vpx(11)
                        top: parent.top; topMargin: vpx(10)
                    }
                    source: "../assets/images/searchicon.svg"
                    opacity: searchbar.selected && !searchInput.searchActive ? 1 : searchInput.searchActive ? 0.8 : 0.5
                    asynchronous: true
                }

                TextInput {
                    id: searchInput
					property bool searchActive: false
                    anchors {
                        left: searchicon.right; leftMargin: vpx(10)
                        top: parent.top; bottom: parent.bottom
                        right: parent.right; rightMargin: vpx(15)
                    }
                    verticalAlignment: Text.AlignVCenter
                    color: theme.text
                    focus: searchbar.selected && searchInput.searchActive
                    font.family: subtitleFont.name
                    font.pixelSize: vpx(18)
                    clip: true
                    text: searchTerm
                    onTextEdited: {
                        searchTerm = searchInput.text
                    }
                }

                // Mouse/touch functionality
                MouseArea {
                    anchors.fill: parent
                    enabled: !searchInput.searchActive
                    hoverEnabled: true
                    onEntered: {}
                    onExited: {}
                    onClicked: {
                        if (!searchInput.searchActive)
                        {
                            searchInput.searchActive != searchInput.searchActive;
                        }
                    }
                }

                Keys.onReleased:{
                    // Back
                    if (api.keys.isCancel(event) && !event.isAutoRepeat) {
                        if(!searchInput.focus){
                            event.accepted = false;
                            return;
                        }
                    }
					event.accepted = virtualKeyboardOnReleased(event);
					//to reset demo if needed
					if (event.accepted) resetDemo();
				}

                Keys.onPressed: {
                    /*console.log("-----Before update-----");
                    console.log("event.accepted : ", event.accepted);
                    console.log("searchInput.focus : ", searchInput.focus);
                    console.log("searchInput.searchActive : ",searchInput.searchActive);
                    console.log("searchbar.selected : ",searchbar.selected);
                    console.log("buttonbar.currentIndex : ", buttonbar.currentIndex);
                    console.log("buttonbar.isCurrentItem : ", buttonbar.isCurrentItem);
                    console.log("root.focus : ", root.focus);*/
                    // Back
                    if (api.keys.isCancel(event) && !event.isAutoRepeat) {
                        if(!searchInput.focus){
                            event.accepted = false;
                            return;
                        }
                    }
                    event.accepted, searchInput.focus, searchInput.searchActive = virtualKeyboardOnPressed(event,searchInput,searchInput.searchActive);
                    /*console.log("-----After update-----");
                    console.log("event.accepted : ", event.accepted);
                    console.log("searchInput.focus : ", searchInput.focus);
                    console.log("searchInput.searchActive : ",searchInput.searchActive);
                    console.log("searchbar.selected : ",searchbar.selected);
                    console.log("buttonbar.currentIndex : ", buttonbar.currentIndex);
                    console.log("buttonbar.isCurrentItem : ", buttonbar.isCurrentItem);
                    console.log("root.focus : ", root.focus);*/
                }

            }

            // Ascending/descending
            Item {
                id: directionbutton

                property bool selected: ListView.isCurrentItem && root.focus
                width: directiontitle.contentWidth + vpx(30)
                height: searchbar.height

                Rectangle
                {
                    anchors.fill: parent
                    radius: height/2
                    color: theme.accent
                    visible: directionbutton.selected
                }

                Text {
                    id: directiontitle

                    text: (orderBy === Qt.AscendingOrder) ? qsTr("Ascending") + api.tr : qsTr("Descending") + api.tr

                    color: theme.text
                    font.family: subtitleFont.name
                    font.pixelSize: vpx(18)
                    anchors.centerIn: parent
                    elide: Text.ElideRight
                }

                Keys.onPressed: {
                    // Accept
                    if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        toggleOrderBy();
                    }
                }
            }

            // Order by title
            Item {
                id: titlebutton

                property bool selected: ListView.isCurrentItem && root.focus
                width: ordertitle.contentWidth + vpx(30)
                height: searchbar.height

                Rectangle
                {
                    anchors.fill: parent
                    radius: height/2
                    color: theme.accent
                    visible: titlebutton.selected
                }

                Text {
                    id: ordertitle

                    text: qsTr("By") + api.tr + " " + sortByFilterDisplay[sortByIndex]

                    color: theme.text
                    font.family: subtitleFont.name
                    font.pixelSize: vpx(18)
                    anchors.centerIn: parent
                    elide: Text.ElideRight
                }

                Keys.onPressed: {
                    // Accept
                    if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        cycleSort();
                    }
                }
            }

            // Filters menu
            Item {
                id: filterbutton

                property bool selected: ListView.isCurrentItem && root.focus
                width: filtertitle.contentWidth + vpx(30)
                height: searchbar.height

                Rectangle
                {
                    anchors.fill: parent
                    radius: height/2
                    color: theme.accent
                    visible: filterbutton.selected
                }

                // Filter title
                Text {
                    id: filtertitle

                    text: (showFavs) ? qsTr("Favorites") + api.tr : qsTr("All games") + api.tr

                    color: theme.text
                    font.family: subtitleFont.name
                    font.pixelSize: vpx(18)
                    anchors.centerIn: parent
                    elide: Text.ElideRight
                }

                Keys.onPressed: {
                    // Accept
                    if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        toggleFavs();
                    }
                }
            }
        }

        // Buttons
        ListView {
            id: buttonbar
            currentIndex: 0
            focus: true
            model: headermodel
            spacing: vpx(10)
            orientation: ListView.Horizontal
            layoutDirection: Qt.RightToLeft
            anchors {
                right: parent.right; rightMargin: globalMargin
                left: parent.left; top: parent.top; topMargin: vpx(15)
            }
        }
    }
}
