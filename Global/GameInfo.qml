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
import "qrc:/qmlutils" as PegasusUtils
import "../moment.js" as DateUtils

Item {
    id: infocontainer

    property var gameData: currentGame

    // Game title
    Text {
        id: gametitle
        
        text: gameData ? gameData.title : ""
        
        anchors {
            top:    parent.top;
            left:   parent.left;
            right:  parent.right
        }
        
        color: theme.text
        font.family: titleFont.name
        font.pixelSize: vpx(44)
        font.bold: true
        horizontalAlignment: Text.AlignHLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // Meta data
    Item {
        id: metarow

        height: vpx(40)
        anchors {
            top: gametitle.bottom;
            left: parent.left
            right: parent.right
        }

        // Rating box
        Text {
            id: ratingtitle

            width: contentWidth
            height: parent.height
            anchors { left: parent.left; }
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Rating")+ ": " + api.tr
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
            id: ratingtext
            
            property real processedRating: gameData ? Math.round(gameData.rating * 100) / 100 : ""
            width: contentWidth
            height: parent.height
            anchors { left: ratingtitle.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: steam ? processedRating*5 : processedRating
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            color: theme.text
        }

        Rectangle {
            id: divider1
            width: vpx(2)
            anchors {
                left: ratingtext.right; leftMargin: (25)
                top: parent.top; topMargin: vpx(10)
                bottom: parent.bottom; bottomMargin: vpx(10)
            }
            opacity: 0.2
        }

        // Players box
        Text {
            id: playerstitle

            width: contentWidth
            height: parent.height
            anchors { left: divider1.right; leftMargin: vpx(25) }
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Players") + ": " + api.tr
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
            id: playerstext

            width: contentWidth
            height: parent.height
            anchors { left: playerstitle.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: gameData ? gameData.players : ""
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            color: theme.text
        }

        Rectangle {
            id: divider2
            width: vpx(2)
            anchors {
                left: playerstext.right; leftMargin: (25)
                top: parent.top; topMargin: vpx(10)
                bottom: parent.bottom; bottomMargin: vpx(10)
            }
            opacity: 0.2
        }

        // Genre box
        Text {
            id: genretitle

            width: contentWidth
            height: parent.height
            anchors { left: divider2.right; leftMargin: vpx(25) }
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Genre") + ": " + api.tr
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
            id: genretext

            anchors {
                left: genretitle.right; leftMargin: vpx(5)
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            verticalAlignment: Text.AlignVCenter
            text: gameData ? gameData.genre : ""
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            elide: Text.ElideRight
            color: theme.text
        }
    }

    // Meta data
    Item {
        id: metarow_2

        height: vpx(40)
        anchors {
            top: metarow.bottom;
            left: parent.left
            right: parent.right
        }

        // Release box
        Text {
            id: releasetitle

            width: contentWidth
            height: parent.height
            anchors { left: parent.left; }
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Release year") + ": " + api.tr
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
            id: releasetext

            width: contentWidth
            height: parent.height
            anchors { left: releasetitle.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: gameData ? gameData.releaseYear : ""
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            color: theme.text
        }

        Rectangle {
            id: divider1_2
            width: vpx(2)
            anchors {
                left: releasetext.right; leftMargin: (25)
                top: parent.top; topMargin: vpx(10)
                bottom: parent.bottom; bottomMargin: vpx(10)
            }
            opacity: 0.2
			visible: (settings.ShowFilename == "Yes") ? true : false
        }

        // File name box
        Text {
            id: filenametitle

            width: contentWidth
            height: parent.height
            anchors { left: divider1_2.right; leftMargin: vpx(25) }
            verticalAlignment: Text.AlignVCenter
            text: qsTr("File name") + ": " + api.tr
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
			visible: (settings.ShowFilename === "Yes") ? true : false
        }

        Text {
            id: filenametext

            width: contentWidth
            height: parent.height
            anchors { left: filenametitle.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: {
				if (gameData){
					var path = gameData.files.get(0).path;
					var word = path.split('/');
					return word[word.length-1];
				}
				else return "";
			}
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            color: theme.text
			visible: (settings.ShowFilename === "Yes") ? true : false
        }

        Rectangle {
            id: divider2_2
            width: vpx(2)
            anchors {
                left: filenametext.right; leftMargin: (25)
                top: parent.top; topMargin: vpx(10)
                bottom: parent.bottom; bottomMargin: vpx(10)
            }
            opacity: 0.2
            visible: (settings.ShowFilehash == "Yes") ? true : false
        }

        // File hash
        Text {
            id: filehashtitle

            width: contentWidth
            height: parent.height
            anchors { left: divider2_2.right; leftMargin: vpx(25) }
            verticalAlignment: Text.AlignVCenter
            text: qsTr("File hash") + ": " + api.tr
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
            visible: (settings.ShowFilehash === "Yes") ? true : false
        }

        Text {
            id: filehashtext

            width: contentWidth
            height: parent.height
            anchors { left: filehashtitle.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: {
                if (gameData){
                    return gameData.hash + " (crc32)";
                }
                else return "";
            }
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            color: theme.text
            visible: (settings.ShowFilehash === "Yes") ? true : false
        }

    }

    // Meta data
    Item {
        id: metarow_3

        height: vpx(40)
        anchors {
            top: metarow_2.bottom;
            left: parent.left
            right: parent.right
        }
		visible: (settings.ShowPlayStats == "Yes") ? true : false
        // Play time
        Text {
            id: playtimetitle

            width: contentWidth
            height: parent.height
            anchors { left: parent.left; }
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Play time") + ": " + api.tr
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
            id: playtimetext

            width: contentWidth
            height: parent.height
            anchors { left: playtimetitle.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: gameData ? (Math. floor(gameData.playTime/60) + " min") : ""
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            color: theme.text
        }

        Rectangle {
            id: divider1_3
            width: vpx(2)
            anchors {
                left: playtimetext.right; leftMargin: (25)
                top: parent.top; topMargin: vpx(10)
                bottom: parent.bottom; bottomMargin: vpx(10)
            }
            opacity: 0.2
        }

        // Play Count
        Text {
            id: playcounttitle

            width: contentWidth
            height: parent.height
            anchors { left: divider1_3.right; leftMargin: vpx(25) }
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Play count") + ": " + api.tr
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
            id: playcounttext

            width: contentWidth
            height: parent.height
            anchors { left: playcounttitle.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: gameData ? gameData.playCount : ""
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            color: theme.text
        }

        Rectangle {
            id: divider2_3
            width: vpx(2)
            anchors {
                left: playcounttext.right; leftMargin: (25)
                top: parent.top; topMargin: vpx(10)
                bottom: parent.bottom; bottomMargin: vpx(10)
            }
            opacity: 0.2
        }

        // Last played
        Text {
            id: lastplayedtitle

            width: contentWidth
            height: parent.height
            anchors { left: divider2_3.right; leftMargin: vpx(25) }
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Last played") + ": " + api.tr
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
            id: lastplayedtext

            width: contentWidth
            height: parent.height
            anchors { left: lastplayedtitle.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: {
				if (gameData)
				{	
					//console.log("gameData.lastPlayed = ",gameData.lastPlayed);					
					let lastplayed = String(gameData.lastPlayed);
					if (lastplayed.toLowerCase().includes("invalid"))
					{
                        return qsTr("N/A") + api.tr;
					}
					else
					{
						return DateUtils.moment(lastplayed).format('YYYY-MM-DD HH:mm:ss');
					}
				}
                else return  qsTr("N/A") + api.tr;
			}
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            color: theme.text
        }
    }
    // Description
    PegasusUtils.AutoScroll
    {
        id: gameDescription

        anchors {
            left: parent.left;
            right: parent.right;
            top: (settings.ShowPlayStats === "Yes") ? metarow_3.bottom : metarow_2.bottom
            bottom: parent.bottom;
        }

        Text {
            width: parent.width
            text: gameData && (gameData.summary || gameData.description) ? gameData.description || gameData.summary : qsTr("No description available") + api.tr
            font.pixelSize: vpx(16)
            font.family: bodyFont.name
            color: theme.text
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
        }
    }
    
}
