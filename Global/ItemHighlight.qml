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
    property bool boxArt
    property bool playVideo: (settings.AllowThumbVideo === "Yes") && !boxArt
	
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
        if(detailed_debug) {
            console.log("ItemHighlight.onGameChanged - selected : ", selected);
            console.log("ItemHighlight.onGameChanged - videoToStop : ", videoToStop);
        }
        videoPreviewLoader.sourceComponent = undefined;
        //videoToStop = false;
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
            if (game && game.assets.videos.length) {
                videoPreviewLoader.sourceComponent = videoPreviewWrapper;
            }
        }
    }

    Timer {
        id: stopvideo

        interval: 1000
        onTriggered: {
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
						if(detailed_debug) console.log("video_path: ",video_path);
						return video_path;
					}
			
            fillMode: VideoOutput.PreserveAspectCrop
            muted: settings.AllowThumbVideoAudio === "No"
            loops: MediaPlayer.Infinite
            autoPlay: true

            //onPlaying: videocomponent.seek(5000)
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
