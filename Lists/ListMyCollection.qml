// gameOS theme for Pixl
//
// created by Bozo the Geek / 18/08/2021 for PixL
//

import QtQuick 2.12
import SortFilterProxyModel 0.2
import "../utils.js" as Utils


Item {
    id: root

    readonly property var games: gamesFiltered;
    function currentGame(index) { return api.allGames.get(gamesMyCollection.mapToSource(index)) }
    
	//number of games
	property int max: gamesMyCollection.count;
	
	//name of the collection
	property var collectionName: ""
	
	//filter on "title"
	property var filter: ""
	property var region: ""
	//example of value:
	//	"europe|USA" to have 2 regions
	//	"fr" french and france and fr ones ;-)
	
	//filter using lists
	property var nb_players: ""
	property var rating: ""
	
	//additional filters
	property var genre: ""
	property var publisher: ""
	property var developer: ""
	property var system: ""
	property var release: ""
	
    //FILTERING
    SortFilterProxyModel {
        id: gamesMyCollection
        sourceModel: api.allGames
        filters: [
			 RegExpFilter { roleName: "title"; pattern: ".*(" + filter + ").*(" + region +")" ; caseSensitivity: Qt.CaseInsensitive; enabled: true}
			 //,
			 //RegExpFilter { roleName: "title"; pattern: region ; caseSensitivity: Qt.CaseInsensitive; enabled: true}
			 //RegExpFilter { roleName: "title"; pattern: ".*" + "(" + ")" + ".*" + "(fr)"; caseSensitivity: Qt.CaseInsensitive;}
        ]
        //sorters: RoleSorter { roleName: "rating"; sortOrder: Qt.DescendingOrder; }
        /*sorters: [
            RoleSorter { roleName: sortByFilter[sortByIndex]; sortOrder: orderBy }
        ]*/        
		//filters:[RegExpFilter { roleName: "rating"; pattern: Utils.regExpForRatingFiltering(); caseSensitivity: Qt.CaseInsensitive; },
    }

    SortFilterProxyModel {
        id: gamesFiltered
        sourceModel: gamesMyCollection
        filters: IndexFilter { maximumIndex: max - 1 }
    }

    property var collection: {
        return {
            name:       collectionName + " : " + gamesFiltered.count + " game(s)",
            shortName:  "mycollection",
            games:      gamesFiltered
        }
    }
}
