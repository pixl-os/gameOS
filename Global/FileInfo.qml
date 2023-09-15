// gameOS theme
// created by BozoTheGeek 15/09/2023 to manage FileInfo in this theme

import QtQuick 2.15
import QtQuick.Layouts 1.15
import "qrc:/qmlutils" as PegasusUtils
import "../moment.js" as DateUtils

Item {
    id: infocontainer

    property var gameData: currentGame

    // Game title
    PegasusUtils.HorizontalAutoScroll{
        id: gametitle

        scrollWaitDuration: 1000 // in ms
        pixelsPerSecond: 20
        activated: true

        anchors {
            top:    parent.top;
            left:   parent.left;
            right:  parent.right
        }
        height: vpx(60)

        Text {
            id: gametitletext

            text: gameData ? gameData.title : ""

            color: theme.text
            font.family: titleFont.name
            font.pixelSize: vpx(44)
            font.bold: true
            horizontalAlignment: Text.AlignHLeft
            verticalAlignment: Text.AlignVCenter
        }
    }

    // Meta data
    PegasusUtils.HorizontalAutoScroll
    {
        id: metarow

        scrollWaitDuration: 1000 // in ms
        pixelsPerSecond: 20
        activated: true

        height: vpx(40)
        anchors {
            top: gametitle.bottom
            left: parent.left
            right: parent.right
        }


        // File name box
        Text {
            id: filenametitle

            width: contentWidth
            height: parent.height
            anchors { left: parent.left; leftMargin: vpx(5) }
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
                left: filenametext.right; leftMargin: (5)
                top: parent.top; topMargin: vpx(10)
                bottom: parent.bottom; bottomMargin: vpx(10)
            }
            opacity: 0.2
            visible: true
        }

        // File size
        Text {
            id: filesizetitle

            width: contentWidth
            height: parent.height
            anchors { left: divider2_2.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: qsTr("File size") + ": " + api.tr
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            font.bold: true
            color: theme.accent
            visible: true
        }

        Text {
            id: filesizetext

            width: contentWidth
            height: parent.height
            anchors { left: filesizetitle.right; leftMargin: vpx(5) }
            verticalAlignment: Text.AlignVCenter
            text: {
				if (gameData){
					console.log("cmd : ", "timeout 1 stat -t '" + gameData.files.get(0).path + "' | awk '{print $2}' | tr -d '\\n' | tr -d '\\r'");
					var size = api.internal.system.run("timeout 1 stat -t '" + gameData.files.get(0).path + "' | awk '{print $2}' | tr -d '\\n' | tr -d '\\r'");
					// calculate unit of size
					let unit;
					if (size < 1024) {
						unit = qsTr("bytes") + api.tr;
					} else if (size < 1024*1024) {
						size /= 1024;
						unit = qsTr("KB") + api.tr;
					} else if (size < 1024*1024*1024) {
						size /= 1024*1024;
						unit = qsTr("MB") + api.tr;
					} else {
						size /= 1024*1024*1024;
						unit = qsTr("GB") + api.tr;
					}
					size = size.toFixed(2);
					return size + " " + unit;
				}
				else return ""
            }
            font.pixelSize: vpx(16)
            font.family: subtitleFont.name
            color: theme.text
            visible: true
        }

    }


    
}
