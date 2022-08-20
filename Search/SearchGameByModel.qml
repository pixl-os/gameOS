// gameOS for Pixl Pegasus-Frontend
//
// created by Bozo the Geek 26/12/2021 for PixL
//

import QtQuick 2.12
import SortFilterProxyModel 0.2

Item {
    id: root
    property bool activated: false
    property alias sourceModel: foundGames.sourceModel
    readonly property var games: foundGames
    readonly property int max: activated ? foundGames.count : 0
    function gameFound(index) {
        return foundGames.sourceModel.get(foundGames.mapToSource(index));
    }
    function sourceGameIndexFound(index) {
        return foundGames.mapToSource(index);
    }
    //name of the collection
    property string collectionName: ""

    //filter on favorite
    property string favorite: "No"
    property var favoriteToFind: (favorite === "No") ? false : true

    //filter on "title"
    property string filter: ""
    property var titleToFilter: (filter === "") ? false : true

    property string region: ""
    property var regionToFilter: (region === "") ? false : true
    //example of region:
    //	"europe|USA" to have 2 regions
    //	"fr" french and france and fr ones ;-)

    //filter using lists for nb players
    property string nb_players: "1+"
    property var nb_playersToFilter: (nb_players === "1+") ? false : true
    property string minimumNb_players : nb_players.replace("+","")
    property var maximumNb_players: nb_players.includes("+") ? 5 : minimumNb_players

    //filter using lists for rating
    property string rating: "All"
    property var ratingToFilter: (rating === "All") ? false : true
    property var minimumRating : (rating !== "All") ? parseFloat(rating.replace("+","")) : 1.0

    //additional filters
    property string genre: ""
    property var genreToFilter: (genre === "") ? false : true
    //example of genre:
    //	"plateforme|platform"

    property string publisher: ""
    property var publisherToFilter: (publisher === "") ? false : true
    //example of publisher:
    //	"nintendo"

    property string developer: ""
    property var developerToFilter: (developer === "") ? false : true
    //example of developer:
    //	"sega"

    property string system: ""
    property var systemToFilter: (system === "") ? false : true
    //example of system:
    //	"nes|snes"

    property string filename: ""
    property bool filenameToFind: false
    property string filenameRegEx: ""
    property var filenameToFilter:  ((filenameRegEx !== "") && (filename !== "")) && !filenameToFind ? true : false

    Component.onCompleted:{
        if(!filenameToFind){
            //change filename to any regex (to replace ()[] characters)
            var filenameRegExTemp = filename.replace(/\(/g, '.*');//to replace ( by .*
            filenameRegExTemp = filenameRegExTemp.replace(/\)/g, ".*"); //to remove ) by .*
            filenameRegExTemp = filenameRegExTemp.replace(/\[/g, '.*');//to replace [ by .*
            filenameRegEx = filenameRegExTemp.replace(/\]/g, ".*"); //to remove ] by .*
        }
    }

    property string release: ""
    property var releaseToFilter: (release === "") ? false : true

    property string exclusion: ""
    //example of exclusion:
    //"beta|virtual console|proto|rev|sega channel|classic collection|unl"
    property var toExclude: (exclusion === "") ? false : true

    //filter on CRC
    property string crc: ""
    property var crcToFind: (crc === "" || crc === "00000000") ? false : true

    //FILTERING
    SortFilterProxyModel {
        id: foundGames
        sourceModel:  api.allGames
        delayed: true //to avoid loop binding
        filters:
            [
            AnyOf{ // to propose to search by path or crc in some cases
                 enabled: activated
                 ValueFilter { roleName: "hash"; value: crc ; enabled: crcToFind}
                 RegExpFilter { roleName: "path"; pattern: filenameRegEx ; caseSensitivity: Qt.CaseInsensitive; enabled: filenameToFilter}
                 ValueFilter { roleName: "path"; value: filename ; enabled: filenameToFind}
            },
            ValueFilter { roleName: "favorite"; value: favoriteToFind ; enabled: favoriteToFind},
            RegExpFilter { roleName: "title"; pattern: filter; caseSensitivity: Qt.CaseInsensitive;enabled: titleToFilter},
            RegExpFilter { roleName: "title"; pattern: region; caseSensitivity: Qt.CaseInsensitive; enabled: regionToFilter},
            RegExpFilter { roleName: "genre"; pattern: genre ; caseSensitivity: Qt.CaseInsensitive; enabled: genreToFilter},
            RangeFilter { roleName: "players"; minimumValue: minimumNb_players ; maximumValue: maximumNb_players; enabled: nb_playersToFilter},
            RegExpFilter { roleName: "publisher"; pattern: publisher ; caseSensitivity: Qt.CaseInsensitive; enabled: publisherToFilter},
            RegExpFilter { roleName: "developer"; pattern: developer ; caseSensitivity: Qt.CaseInsensitive; enabled: developerToFilter},
            RegExpFilter { roleName: "releaseYear"; pattern: release ; caseSensitivity: Qt.CaseInsensitive; enabled: releaseToFilter},
            RegExpFilter { roleName: "title"; pattern: exclusion ; caseSensitivity: Qt.CaseInsensitive; inverted: true; enabled: toExclude},
            ExpressionFilter { expression: parseFloat(model.rating) >= minimumRating; enabled: ratingToFilter},
            ExpressionFilter { expression: system.includes(model.collections.get(0).shortName.toLowerCase()); enabled: systemToFilter}
            ]
    }

    property var result: {
        return {
            games: foundGames
        }
    }
}
