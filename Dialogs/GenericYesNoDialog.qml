// Pegasus Frontend
// Copyright (C) 2017-2019  Mátyás Mustoha
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

// from Pegasus GenericOkCancelDialog by Bozo The Geek 22-12-2022

import QtQuick 2.12


FocusScope {
    id: root
	
    property alias title: titleText.text
    property alias message: messageText.text
    property alias symbol: symbolText.text

    property int textSize: vpx(20)
    property int titleTextSize: vpx(22)

    signal accept()
    signal cancel()

    anchors.fill: parent
    visible: shade.opacity > 0

    onActiveFocusChanged: {
        state = activeFocus ? "open" : "";
        if (activeFocus)
            okButton.focus = true;
    }

    Keys.onPressed: {
        if (api.keys.isCancel(event) && !event.isAutoRepeat) {
            event.accepted = true;
            root.cancel();
        }
    }

    Shade {
        id: shade
        onCancel: root.cancel()
    }

    // actual dialog
    MouseArea {
        anchors.centerIn: parent
        width: dialogBox.width
        height: dialogBox.height
    }

    //    Rectangle {
    //        anchors.centerIn: dialogBox
    //        width: dialogBox.width
    //        height: dialogBox.height
    //        radius: vpx(8)
    //        color: "#484"
    //    }

    Column {
        id: dialogBox

        width: parent.height * 0.66
        anchors.centerIn: parent
        //            scale: 0.5

        Behavior on opacity { NumberAnimation { duration: 125 } }

        // title bar
        Rectangle {
            id: titleBar
            width: parent.width
            height: root.titleTextSize * 2.25
            color: theme.main //themeColor.main //"#222"
//            radius: vpx(8)

            Text {
                id: titleText

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: root.titleTextSize * 0.75
                }

                color: theme.text //themeColor.textLabel //"#999"
                font {
                    bold: true
                    pixelSize: root.titleTextSize
                    family: globalFonts.sans
                }
            }

            Text {
                id: symbolText

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: root.titleTextSize * 0.75
                }

                color: theme.text //themeColor.textLabel //"#6ff"
                font {
                    bold: true
                    pixelSize: root.titleTextSize
                    family: globalFonts.sans
                }
            }
        }

        // text area
        Rectangle {
            width: parent.width
            height: messageText.height + 3 * root.textSize
            color: theme.secondary//themeColor.secondary //"#222"
            //                radius: vpx(8)

            Text {
                id: messageText

                anchors.centerIn: parent
                width: parent.width - 2 * root.textSize

                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter

                color: theme.text //themeColor.textLabel //"#999"
                font {
                    pixelSize: root.textSize
                    family: globalFonts.sans
                }
            }
        }

        // button row
        Row {
            width: parent.width
            height: root.textSize * 2

            Rectangle {
                id: okButton

                focus: true // 'Yes' proposed by default (reverse in case of OK/Canel case)

                width: parent.width * 0.5
                height: root.textSize * 2.25
                color: (focus || okMouseArea.containsMouse) ? "darkGreen" : theme.main//themeColor.main //"#222"
//                radius: vpx(8)

                Keys.onPressed: {
                    if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        root.accept();
                    }
                }

                Text {
                    anchors.centerIn: parent

                    text: qsTr("Yes") + api.tr
                    color: theme.text //themeColor.textLabel //"#999"
                    font {
                        pixelSize: root.textSize
                        family: globalFonts.sans
                    }
                }

                MouseArea {
                    id: okMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.accept()
                }
            }

            Rectangle {
                id: cancelButton

                //focus: false

                width: parent.width * 0.5
                height: root.textSize * 2.25
                color: (focus || cancelMouseArea.containsMouse) ? "darkRed" : theme.main//themeColor.main //"#222"
//                radius: vpx(8)

                KeyNavigation.left: okButton
                Keys.onPressed: {
                    if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        root.cancel();
                    }
                }

                Text {
                    anchors.centerIn: parent

                    text: qsTr("No") + api.tr
                    color: theme.text //themeColor.textLabel //"#999"
                    font {
                        pixelSize: root.textSize
                        family: globalFonts.sans
                    }
                }

                MouseArea {
                    id: cancelMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.cancel()
                }
            }
        }
    }

    states: [
        State {
            name: "open"
            PropertyChanges { target: shade; opacity: 0.4 }
            PropertyChanges { target: dialogBox; scale: 1 }
        }
    ]
}
