// PixL theme
// Copyright (C) 2021-2024
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
import "qrc:/qmlutils" as PegasusUtils

Item {
id: infocontainer

    property var gameData: currentGame
	property alias model: achievementsgrid.model
	property alias index: achievementsgrid.currentIndex
	property var icon_size: 92
	property var margin: 4
	property bool selected
	
	function updateDetails(index)
	{
		console.log("GameAchievements - updateDetails(index)");
		if(game.retroAchievementsCount !== 0)
		{	
			retroachievementstitle.text = gameData.GetRaTitleAt(index);
			pointstext.text = gameData.GetRaPointsAt(index);
			authortext.text = gameData.GetRaAuthorAt(index);
			descriptiontext.text = gameData.GetRaDescriptionAt(index);
		}
		else
		{
			retroachievementstitle.text = "";
			pointstext.text = "";
			authortext.text = "";
			descriptiontext.text = "";

		}
	}

    Image {
    id: retroachievementslogo

        anchors { 
            top: parent.top;
            right: parent.right;
			
        }
        width: vpx(300)
        height: vpx(100)
        source: "https://retroachievements.org/Images/RA_Logo10.png"
        fillMode: Image.PreserveAspectFit
        asynchronous: true
		verticalAlignment : Image.AlignTop;
        z: (content.currentIndex == 0) ? 10 : -10
        visible: true;
    }	

    // Retroachievements title
    Text {
    id: retroachievementstitle
        
        text : {
			console.log("GameAchievements - if (gameData.retroAchievementsCount !== 0) return gameData.GetRaTitleAt(0);");
			if (gameData.retroAchievementsCount !== 0) return gameData.GetRaTitleAt(0);
			else return "";
		}
        anchors {
            top:    parent.top;
            left:   parent.left;
            right:  retroachievementslogo.left
        }
        
        color: theme.text
        font.family: titleFont.name
        font.pixelSize: vpx(30)
        font.bold: true
        horizontalAlignment: Text.AlignHLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
	


    // Meta data
    Item {
    id: metarow

        height: vpx(50)
        anchors {
            top: retroachievementstitle.bottom; 
            left: parent.left
            right: parent.right
        }

        // Points box
        Text {
        id: pointstitle

            width: contentWidth
            height: parent.height
            anchors { left: parent.left; }
            verticalAlignment: Text.AlignVCenter
            text: "Points: "
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
        id: pointstext
            
            width: contentWidth
            height: parent.height
            anchors { left: pointstitle.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: {
					if (gameData.retroAchievementsCount !== 0) return gameData.GetRaPointsAt(0);
					else return "";
			}
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            color: theme.text
        }

        Rectangle {
        id: divider1
            width: vpx(2)
            anchors {
                left: pointstext.right; leftMargin: (25)
                top: parent.top; topMargin: vpx(10)
                bottom: parent.bottom; bottomMargin: vpx(10)
            }
            opacity: 0.2
        }

        // Author box
        Text {
        id: authortitle

            width: contentWidth
            height: parent.height
            anchors { left: divider1.right; leftMargin: vpx(25) }
            verticalAlignment: Text.AlignVCenter
            text: "Author: "
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
        id: authortext

            width: contentWidth
            height: parent.height
            anchors { left: authortitle.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: {
					if (gameData.retroAchievementsCount !== 0) return gameData.GetRaAuthorAt(0);
					else return "";
			}	
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            color: theme.text
        }

        Rectangle {
        id: divider2
            width: vpx(2)
            anchors {
                left: authortext.right; leftMargin: (25)
                top: parent.top; topMargin: vpx(10)
                bottom: parent.bottom; bottomMargin: vpx(10)
            }
            opacity: 0.2
        }

        // Description box
        Text {
        id: descriptiontitle

            width: contentWidth
            height: parent.height
            anchors { left: divider2.right; leftMargin: vpx(25) }
            verticalAlignment: Text.AlignVCenter
            text: "Description: "
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
        id: descriptiontext

            anchors { 
                left: descriptiontitle.right; leftMargin: vpx(5)
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            verticalAlignment: Text.AlignVCenter
            text: {
					if (gameData.retroAchievementsCount !== 0) return gameData.GetRaDescriptionAt(0);
					else return "";
			}
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            elide: Text.ElideRight
            color: theme.text
        }
    }

	Component {
		id: highlight
			Rectangle {
				id: rect
				width: achievementsgrid.cellWidth; height: achievementsgrid.cellHeight
				color: theme.accent; radius: margin
				x: achievementsgrid.currentItem.x
				y: achievementsgrid.currentItem.y
				Behavior on x { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }
                                Behavior on y { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }
			}
	}

	GridView {
		id: achievementsgrid
			anchors {
				left: parent.left; 
				right: parent.right;
				top: metarow.bottom;
				bottom: parent.bottom;
			}
		height: parent.height
		width: parent.width	
		opacity: 1	
		clip: true	
		cellWidth: icon_size + margin
		cellHeight: icon_size + margin
		
		focus: selected
		
		highlight: highlight
		highlightFollowsCurrentItem: false

		Keys.onLeftPressed: { 
								console.log("GridView - Keys.onLeftPressed");
								moveCurrentIndexLeft();
								updateDetails(currentIndex);
		}	
		Keys.onRightPressed:{ 
								console.log("GridView - Keys.onRightPressed");
								moveCurrentIndexRight();
								updateDetails(currentIndex);
							
		}
		Keys.onUpPressed: { 
								console.log("GridView - Keys.onUpPressed");
								moveCurrentIndexUp();
								updateDetails(currentIndex);
		}
		Keys.onDownPressed:{ 
								console.log("GridView - Keys.onDownPressed");
								var indexBeforeMove = currentIndex;
								moveCurrentIndexDown();
								if (currentIndex !== indexBeforeMove)
								{
									updateDetails(currentIndex);
								}
								else
								{	
									selected = false;
									currentIndex = -1; //to deactivate selection
									content.focus = true; // to select menu
									menu.currentIndex = 4; // to select button of menu for achievements
								}
		}

		model: gameData.retroAchievementsCount
		delegate: Column {
			Image {
					Layout.fillWidth: true
					Layout.fillHeight: true
					fillMode: Image.PreserveAspectFit
					source: {
						if(game.retroAchievementsCount !== 0)
						{
							console.log("GameAchievements - game.isRaUnlockedAt(index) : ",game.GetRaBadgeAt(index), game.isRaUnlockedAt(index));
							if(game.isRaUnlockedAt(index))
								return "https://s3-eu-west-1.amazonaws.com/i.retroachievements.org/Badge/" + game.GetRaBadgeAt(index) + ".png";
							else
								return "https://s3-eu-west-1.amazonaws.com/i.retroachievements.org/Badge/" + game.GetRaBadgeAt(index) + "_lock.png";
						}
						else "";
					}
					width:icon_size; height:icon_size
					smooth: true
					visible: true
					asynchronous: true
			}
		}
    }
}