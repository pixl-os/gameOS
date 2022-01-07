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

    onFocusChanged: buttonbar.currentIndex = 0;


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

                property bool selected: ListView.isCurrentItem && root.focus
                onSelectedChanged:{
					//console.log("onSelectedChanged");
					//console.log("searchbar.selected :",searchbar.selected); 
					//console.log("searchInput.searchActive : ",searchInput.searchActive);
					//console.log("searchInput.focus : ",searchInput.focus);
					if (!searchbar.selected && searchInput.searchActive) toggleSearch();
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
                            toggleSearch();
                        }
                    }
                }


				property var counter: 0
				property var previousVirtualKeyboardVisibility: false
				
				function sleepFor(sleepDuration){
					var now = new Date().getTime();
					while(new Date().getTime() < now + sleepDuration){ /* Do nothing */ };
				}

				function virtualKeyboardOnReleased(ev){
					ev.accepted = true;
					return ev.accepted;					
                }
				
				Keys.onReleased:{
					event.accepted = virtualKeyboardOnReleased(event);
				}
 
				function virtualKeyboardOnPressed(ev,input,editionActive){
                    console.log("searchbar.Keys.onPressed : ", counter++);
					//console.log("previousVirtualKeyboardVisibility : ",previousVirtualKeyboardVisibility);
					//console.log("ev.key : ", ev.key);
					//console.log("editionActive : ",editionActive);
					//console.log("input.focus : ",input.focus);
					//console.log("cursorVisible : ",	input.cursorVisible);
					//console.log("inputPanelLoader.active : ",inputPanelLoader.active);
					//console.log("Qt.inputMethod.visible : ",Qt.inputMethod.visible);						                  
					// Accept
					if (api.keys.isAccept(ev) && !ev.isAutoRepeat) {
                        //console.log("isAccept");
						ev.accepted = true;
                        if (!editionActive) {
							editionActive = !editionActive;
							input.focus = true;
							previousVirtualKeyboardVisibility = true;
							input.selectAll();
                        } 
						else if ((ev.key !== Qt.Key_Return) && (ev.key !== Qt.Key_Enter)){
								if(inputPanelLoader.active){	
									keyEmitter.keyPressed(appWindow, Qt.Key_Return);
									//sleepFor(25);
									keyEmitter.keyRelease(appWindow, Qt.Key_Return);
									//sleepFor(25);
								}
						}
						else if(editionActive && !Qt.inputMethod.visible && (previousVirtualKeyboardVisibility === false)){
							//console.log("editionActive && !Qt.inputMethod.visible");
							input.focus = false;
							input.focus = true;
							input.selectAll();
						}
						previousVirtualKeyboardVisibility = Qt.inputMethod.visible;
					}
					
                    // Cancel
                    if (api.keys.isCancel(ev) && !ev.isAutoRepeat) {
						//console.log("isCancel");
                        ev.accepted = true;
						if(editionActive && Qt.inputMethod.visible){
							if ((ev.key !== Qt.Key_Return) && (ev.key !== Qt.Key_Enter)){							
								keyEmitter.keyRelease(appWindow, Qt.Key_Return);
							}
						}
						else if (editionActive && !Qt.inputMethod.visible) {
                            editionActive = !editionActive;
							input.focus = true;
							input.cursorVisible = false;
                        }
						else if (Qt.inputMethod.visible){
							input.focus = false;
						}
                    }
					return ev.accepted, input.focus, editionActive ;
                }

				Keys.onPressed: {event.accepted, searchInput.focus, searchInput.searchActive = virtualKeyboardOnPressed(event,searchInput,searchInput.searchActive);}

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

                    text: (orderBy === Qt.AscendingOrder) ? "Ascending" : "Descending"

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

                    text: "By " + sortByFilter[sortByIndex]

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

                    text: (showFavs) ? "Favorites" : "All games"

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
