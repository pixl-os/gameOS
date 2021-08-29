// gameOS theme for Pixl
//
// created by Bozo the Geek / 18/08/2021 for PixL
//

import QtQuick 2.12
import SortFilterProxyModel 0.2
//import "../utils.js" as Utils


Item {
    id: root

    readonly property var games: gamesFiltered;
    function currentGame(index) { 
/* 		for (var i = 0; i < api.collections.count; i++) {
			console.log("api.collections.get(i).shortName: ",api.collections.get(i).shortName);
			if (api.collections.get(i).shortName === system) {
				console.log("system: ",system);
				return api.collections.get(i).games.get(gamesMyCollection.mapToSource(index));
			}
		}
		//if not found
		return api.allGames.get(gamesMyCollection.mapToSource(index)); */
		return gamesMyCollection.sourceModel.get(gamesMyCollection.mapToSource(index));
	}	
	
	//return api.allGames.get(gamesMyCollection.mapToSource(index)) }
    
	//number of games
	property int max: gamesMyCollection.count;
	
	//name of the collection
	property var collectionName: ""
	
	//filter on "title"
	property var filter: ""
	property var region: ""
	property var titleToFilter: (filter === "" && region === "") ? false : true
	//example of region:
	//	"europe|USA" to have 2 regions
	//	"fr" french and france and fr ones ;-)
	
	property var exclusion: ""
	//example of exclusion:
	//"beta|virtual console|proto|rev|sega channel|classic collection|unl"
	
	property var toExclude: (exclusion === "") ? false : true
	
	//filter using lists
	property var nb_players: ""
	property var rating: ""
	
	//additional filters
	property var genre: ""
	property var genreToFilter: (genre === "") ? false : true
	//example of genre:
	//	"plateforme|platform"
	
	property var publisher: ""
	property var publisherToFilter: (publisher === "") ? false : true
	//example of publisher:
	//	"nintendo"
	
	property var developer: ""
	property var developerToFilter: (developer === "") ? false : true
	//example of developer:
	//	"sega"
	
	property var system: ""
	property var systemToFilter: (system === "") ? false : true
	//example of system:
	//	"nes|snes"
	
	property var release: ""
	property var releaseToFilter: (release === "") ? false : true
	
	
    //FILTERING
    SortFilterProxyModel {
        id: gamesMyCollection
        sourceModel:{
			for (var i = 0; i < api.collections.count; i++) {
				console.log("api.collections.get(i).shortName: ",api.collections.get(i).shortName);
				if (api.collections.get(i).shortName === system) {
					console.log("system: ",system);
					return api.collections.get(i).games
				}
			}
			//if not found
			return api.allGames;
		}
			
        filters: [
			 RegExpFilter { roleName: "title"; pattern: ".*(" + filter + ").*(" + region +")" ; caseSensitivity: Qt.CaseInsensitive; enabled: titleToFilter},
			 RegExpFilter { roleName: "genre"; pattern: ".*(" + genre + ")" ; caseSensitivity: Qt.CaseInsensitive; enabled: genreToFilter},
			 RegExpFilter { roleName: "publisher"; pattern: ".*(" + publisher + ")" ; caseSensitivity: Qt.CaseInsensitive; enabled: publisherToFilter},
			 RegExpFilter { roleName: "developer"; pattern: ".*(" + developer + ")" ; caseSensitivity: Qt.CaseInsensitive; enabled: developerToFilter},
			 //RegExpFilter { roleName: "collection"; pattern: ".*(" + system + ")" ; caseSensitivity: Qt.CaseInsensitive; enabled: systemToFilter},
			 RegExpFilter { roleName: "title"; pattern: ".*(" + exclusion + ")" ; caseSensitivity: Qt.CaseInsensitive; inverted: true; enabled: toExclude}
			 
			 
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
