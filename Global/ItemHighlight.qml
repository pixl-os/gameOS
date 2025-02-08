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
import QtGraphicalEffects 1.15
import QtMultimedia 5.15

Item {
    id: root

    property var game
    property bool selected
    property bool boxArt: false
    property bool choosenMedia: false
    property bool playVideo: game ? (game.assets.videoList.length && (settings.AllowThumbVideo === "Yes") && !boxArt && !choosenMedia) : false

    property bool validated: selected && (videoToStop || demoLaunched)
	onValidatedChanged:
	{
		if(detailed_debug) console.log("ItemHighlight.onValidatedChanged:", validated);
		if (selected && validated) 
		{
			videoPreviewLoader.sourceComponent = undefined;
			videoDelay.stop();
            //videoToStop = false;
		}
	}

    onGameChanged: {
        
		//fix to force update of playVideo state to avoid bug
		playVideo = game ? (game.assets.videoList.length && (settings.AllowThumbVideo === "Yes") && !boxArt && !choosenMedia) : false
		
		if(detailed_debug) {
            console.log("ItemHighlight.onGameChanged - selected : ", selected);
            console.log("ItemHighlight.onGameChanged - videoToStop : ", videoToStop);
			console.log("ItemHighlight.onGameChanged - boxArt: ", boxArt);
			console.log("ItemHighlight.onGameChanged - choosenMedia: ", choosenMedia);
			console.log("ItemHighlight.onGameChanged - playVideo: ", playVideo);
        }
        videoPreviewLoader.sourceComponent = undefined;

        if (playVideo && selected && !videoToStop && !demoLaunched) {
            if(detailed_debug) console.log("ItemHighlight.onGameChanged - videoDelay.restart()");
            videoDelay.restart();
        }
    }

    onSelectedChanged: {
        if(detailed_debug) {
            console.log("ItemHighlight.onSelectedChanged - selected : ", selected);
            console.log("ItemHighlight.onSelectedChanged - videoToStop : ", videoToStop);
        }
        if (!selected) {
            videoPreviewLoader.sourceComponent = undefined;
			videoToStop = false;
            videoDelay.stop();
        }
        else if (playVideo && selected && !videoDelay.running && !videoToStop) {
            if(detailed_debug) console.log("ItemHighlight.onSelectedChanged - videoDelay.restart()");
            videoDelay.restart();
        }

    }

    // Timer to show the video
    Timer {
        id: videoDelay

        interval: 600
        onTriggered: {
            if (game && game.assets.videos.length && playVideo) {
                if(detailed_debug) console.log("ItemHighlight.videoDelay - load video");
                //07/02/2025: seems that to set "undefined" seems tp force clear/reset of memory/object that avoid crash later ?!
                videoPreviewLoader.sourceComponent = undefined;
                videoPreviewLoader.sourceComponent = videoPreviewWrapper;
            }
        }
    }

    Timer {
        id: stopvideo

        interval: 1000
        onTriggered: {
            if(detailed_debug) console.log("ItemHighlight.stopvideo");
            videoPreviewLoader.sourceComponent = undefined;
            videoDelay.stop();
        }
    }

    // NOTE: Video Preview
    Component {
        id: videoPreviewWrapper

        Video {
            id: videocomponent

            anchors.fill: parent
            source: {
                        var video_path = "";
                        if((game !== null) && (typeof(game) !== "undefined")){
                            if(game.assets.videoList.length >=1) video_path = game.assets.videoList[0];
                        }
                        if(detailed_debug) console.log("videocomponent.video_path: ",video_path);
						return video_path;
					}
			
            fillMode: VideoOutput.PreserveAspectCrop
            muted: settings.AllowThumbVideoAudio === "No"
            loops: MediaPlayer.Infinite
            autoPlay: true

            //07/02/2025: workaround added to reload/restart video in case of issue and to avoid crash/stuck video replay
            // it seems linked to CPU and/or QT framework version... could be usefull to keep in future.
            property int previousPosition: -1
            property int counterCheckPosition: 0
            onPositionChanged: {
                if(detailed_debug){
                    console.log("ItemHighlight.videocomponent - seekable: ",seekable);
                    console.log("ItemHighlight.videocomponent - loops: ",loops);
                    console.log("ItemHighlight.videocomponent - position: ",position);
                    console.log("ItemHighlight.videocomponent - previousPosition: ",previousPosition);
                    console.log("ItemHighlight.videocomponent - counterCheckPosition: ",counterCheckPosition);
                }
                //do something only if video is completed loaded
                if(seekable === true){
                    //check if video stuck at start (tentative to force seek to 0 first)
                    if((previousPosition > position) && (position === 0)){
                        //restart if stuck after 3 positions checks
                        if(counterCheckPosition >= 2){
                            console.log("ItemHighlight.videocomponent - force restart video (0)");
                            previousPosition = -1;
                            counterCheckPosition = 0;
                            //seek video to 0
                            seek(0);
                        }
                        else counterCheckPosition += 1;
                    }
                    //in case  of video crash at start (tentative to force seek didn't work - stay blocked at 0)
                    else if((previousPosition <= position) && (position === 0)){
                        //reload if stuck after 3 positions checks
                        if(counterCheckPosition >= 2){
                            console.log("ItemHighlight.videocomponent - force reload video (1)");
                            previousPosition = -1;
                            counterCheckPosition = 0;
                            //reload video
                            videoPreviewLoader.sourceComponent = undefined;
                            videoPreviewLoader.sourceComponent = videoPreviewWrapper;
                        }
                        else counterCheckPosition += 1;
                    }
                    //check if video stuck at during playing - force reload imediatelly
                    else if((previousPosition === position) && (position !== 0)){
                        //restart if stuck after 3 positions checks
                        if(counterCheckPosition >= 2){
                            console.log("ItemHighlight.videocomponent - force reload video (2)");
                            previousPosition = -1;
                            counterCheckPosition = 0;
                            //reload video
                            videoPreviewLoader.sourceComponent = undefined;
                            videoPreviewLoader.sourceComponent = videoPreviewWrapper;
                        }
                        else counterCheckPosition += 1;
                    }
                    else{
                        previousPosition = position;
                        if (position !== 0) counterCheckPosition = 0;
                    }
                }
            }
        }
    }

    DropShadow {
        id: outershadow

        anchors.fill: videocontainer
        horizontalOffset: 0
        verticalOffset: 0
        radius: 20.0
        samples: 15
        color: "#000000"
        source: videocontainer
        opacity: selected ? 0.5 : 0
        Behavior on opacity { NumberAnimation { duration: 100 } }
        z: -5
    }

    Item {
        id: videocontainer

        anchors.fill: parent

        // Video
        Loader {
            id: videoPreviewLoader

            asynchronous: true
            anchors { fill: parent }
        }
    }
}
