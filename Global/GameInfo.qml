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
            text: "Rating: "
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
            text: "Players78: "
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
            text: "Genre: "
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
        id: metarow2

        height: vpx(40)
        anchors {
            top: metarow.bottom;
            left: parent.left
            right: parent.right
        }

        // Release box
        Text {
            id: releasetitle2

            width: contentWidth
            height: parent.height
            anchors { left: parent.left; }
            verticalAlignment: Text.AlignVCenter
            text: "Release Year: "
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
            id: releasetext2

            width: contentWidth
            height: parent.height
            anchors { left: releasetitle2.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: gameData ? gameData.releaseYear : ""
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            color: theme.text
        }

        Rectangle {
            id: divider12
            width: vpx(2)
            anchors {
                left: releasetext2.right; leftMargin: (25)
                top: parent.top; topMargin: vpx(10)
                bottom: parent.bottom; bottomMargin: vpx(10)
            }
            opacity: 0.2
        }

        // Players box
        Text {
            id: playerstitle2

            width: contentWidth
            height: parent.height
            anchors { left: divider12.right; leftMargin: vpx(25) }
            verticalAlignment: Text.AlignVCenter
            text: "Players78: "
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
            id: playerstext2

            width: contentWidth
            height: parent.height
            anchors { left: playerstitle2.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: gameData ? gameData.players : ""
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            color: theme.text
        }

        Rectangle {
            id: divider22
            width: vpx(2)
            anchors {
                left: playerstext2.right; leftMargin: (25)
                top: parent.top; topMargin: vpx(10)
                bottom: parent.bottom; bottomMargin: vpx(10)
            }
            opacity: 0.2
        }

        // Genre box
        Text {
            id: genretitle2

            width: contentWidth
            height: parent.height
            anchors { left: divider22.right; leftMargin: vpx(25) }
            verticalAlignment: Text.AlignVCenter
            text: "Genre: "
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
        }

        Text {
            id: genretext2

            anchors {
                left: genretitle2.right; leftMargin: vpx(5)
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

    // Description
    PegasusUtils.AutoScroll
    {
        id: gameDescription

        anchors {
            left: parent.left;
            right: parent.right;
            top: metarow2.bottom
            bottom: parent.bottom;
        }

        Text {
            width: parent.width
            text: gameData && (gameData.summary || gameData.description) ? gameData.description || gameData.summary : "No description available"
            font.pixelSize: vpx(16)
            font.family: bodyFont.name
            color: theme.text
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
        }
    }
    
}
