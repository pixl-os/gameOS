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

import QtQuick 2.15
//import QtWebEngine 1.0
import QtWebEngine 1.9
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import QtMultimedia 5.15
import "../Global"

FocusScope {
    id: root

    signal close
    property var mediaModel: []
    property int mediaIndex: 0
    property bool isVideo: mediaModel.length ? mediaModel[mediaIndex].includes(".mp4") || mediaModel[mediaIndex].includes(".webm") : false
    property bool isManual: mediaModel.length ? mediaModel[mediaIndex].includes(".pdf") : false
    
    function next() {
        if (mediaIndex == mediaModel.length-1)
            mediaIndex = 0;
        else
            mediaIndex++;
    }
    function prev() {
        if (mediaIndex == 0)
            mediaIndex = mediaModel.length-1;
        else
            mediaIndex--;
    }
    
    Rectangle {
        
        anchors.fill: parent
        color: "#808080"
        opacity: 1.0
    }

    // to load Video
    Component {
        id: videoWrapper

        Video {
            source: isVideo ? mediaModel[mediaIndex] : ""
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectFit
            muted: false
            autoPlay: true
        }

    }

    Loader {
        id: videoLoader
        sourceComponent: root.focus && isVideo ? videoWrapper : undefined
        asynchronous: true
        anchors { fill: parent }
    }

    // to load Manual
    Component {
        id: manualWrapper
        WebEngineView {
            id: webview
            anchors.fill: parent
            url: "../pdfjs/web/viewer.html" + "?file=" + encodeURIComponent(isManual ? mediaModel[mediaIndex]: "") + "#zoom=page-fit"
            Component.onCompleted: {
                //console.log("Url pdf: ", webview.url);
                //console.log("WebEngineView.onCompleted");
                webview.focus = true;
                manualLoader.focus = true;
            }
        }
    }

    Loader {
        id: manualLoader
        sourceComponent: root.focus && isManual ? manualWrapper : undefined
        asynchronous: true
        anchors { fill: parent }
        
        // Input handling
        //Keys.forwardTo: [sourceComponent];
        Keys.onPressed: {
            console.log("Key presssed in manualLoader");
            // Back
            if (api.keys.isCancel(event) && !event.isAutoRepeat) {
                //event.accepted = true;
                medialist.focus = true;
            }
            //rotate with X
            if (api.keys.isDetails(event) && !event.isAutoRepeat) {
                keyEmitter.keyPressed(appWindow, Qt.Key_R);
            }
            //zoom + / R1
            if (api.keys.isNextPage(event) && !event.isAutoRepeat) {
                keyEmitter.keyPressed(appWindow, Qt.Key_Plus, Qt.ControlModifier);
            }
            //zoom - / L1
            if (api.keys.isPrevPage(event) && !event.isAutoRepeat) {
                keyEmitter.keyPressed(appWindow, Qt.Key_Minus, Qt.ControlModifier);
            }
            //Next page / R2
            if (api.keys.isPageDown(event) && !event.isAutoRepeat) {
                keyEmitter.keyPressed(appWindow, Qt.Key_N);
            }
            //Next page / A
            if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                keyEmitter.keyPressed(appWindow, Qt.Key_N);
            }
            //Previous page - / L2
            if (api.keys.isPageUp(event) && !event.isAutoRepeat) {
                keyEmitter.keyPressed(appWindow, Qt.Key_P);
            }
        }
    }

    ListView {
        id: medialist

        focus: true
        currentIndex: mediaIndex
        onCurrentIndexChanged: mediaIndex = currentIndex;
        anchors.fill: parent
        orientation: ListView.Horizontal
        clip: true
        preferredHighlightBegin: vpx(0)
        preferredHighlightEnd: parent.width
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 200
        snapMode: ListView.SnapOneItem
        keyNavigationWraps: true
        model: mediaModel
        delegate: Image {
            id: imageholder

            width: root.width
            height: root.height
            source: modelData.includes(".mp4") || modelData.includes(".webm") || modelData.includes(".pdf") ? "" : modelData
            smooth: true
            fillMode: Image.PreserveAspectFit
            visible: !isVideo && !isManual
            asynchronous: true
        }
        
        Keys.onLeftPressed: { sfxNav.play(); decrementCurrentIndex() }
        Keys.onRightPressed: { sfxNav.play(); incrementCurrentIndex() }
        
    }

    Row {
        id: blips

        anchors.horizontalCenter: parent.horizontalCenter
        anchors { bottom: parent.bottom; bottomMargin: vpx(20) }
        spacing: vpx(10)
        Repeater {
            model: medialist.count
            Rectangle {
                width: vpx(10)
                height: width
                color: (medialist.currentIndex == index) ? theme.accent : theme.text
                radius: width/2
                opacity: (medialist.currentIndex == index) ? 1 : 0.5
            }
        }
    }

    // Mouse/touch functionality
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {}
        onExited: {}
        onClicked: close();
    }

    Keys.forwardTo: [manualLoader];
    
    // Input handling
    Keys.onPressed: {

        // Back
        if (api.keys.isCancel(event) && !event.isAutoRepeat) {
            event.accepted = true;
            close();
        }
        
        // Accept
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            if (!isManual) {
                event.accepted = true;
                close();
            }
            else
            {
                //console.log("Key presssed on Manual");
                //set focus on pdf viewer
                manualLoader.focus = true;
            }
        }
    }

    // Helpbar buttons
    ListModel {
        id: mediaviewHelpModel

        ListElement {
            name: "Back"
            button: "cancel"
        }
    }
    
    onFocusChanged: {
        if (focus) {
            currentHelpbarModel = mediaviewHelpModel;
        }
    }
}
