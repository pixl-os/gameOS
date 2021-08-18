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
    property int max: gamesMyCollection.count;
	property var collectionName: ""
	property var filter: ""
	property var region: "europe"
	
    //FILTERING
    SortFilterProxyModel {
        id: gamesMyCollection
        sourceModel: api.allGames
        filters: [
             RegExpFilter { roleName: "title"; pattern: filter ; caseSensitivity: Qt.CaseInsensitive; enabled: true}//,
			//RegExpFilter { roleName: "title"; pattern: ".*" + "(" + ")" + ".*" + "(fr)"; caseSensitivity: Qt.CaseInsensitive;}
        ]
        //sorters: RoleSorter { roleName: "rating"; sortOrder: Qt.DescendingOrder; }
        sorters: [
            RoleSorter { roleName: sortByFilter[sortByIndex]; sortOrder: orderBy }
        ]        
		//filters:[RegExpFilter { roleName: "rating"; pattern: Utils.regExpForRatingFiltering(); caseSensitivity: Qt.CaseInsensitive; },
    }

    SortFilterProxyModel {
        id: gamesFiltered
        sourceModel: gamesMyCollection
        filters: IndexFilter { maximumIndex: max - 1 }
    }

    property var collection: {
        return {
            name:       collectionName,
            shortName:  "mycollection",
            games:      gamesFiltered
        }
    }
}
