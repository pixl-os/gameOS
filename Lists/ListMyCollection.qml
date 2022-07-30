// gameOS theme for Pixl
//
// created by Bozo the Geek / 18/08/2021 for PixL
//

import QtQuick 2.12
import SortFilterProxyModel 0.2

Item {
    id: root

    readonly property var games: gamesMyCollection
	property int max: gamesMyCollection.count;
    function currentGame(index) {
		return gamesMyCollection.sourceModel.get(gamesMyCollection.mapToSource(index));
	}	

	//name of the collection
	property var collectionName: ""
	
	//filter on favorite
	property var favorite: "No"
	property var favoriteToFind: (favorite === "No") ? false : true
		
	//filter on "title"
	property var filter: ""
	property var titleToFilter: (filter === "") ? false : true
	
	property var region: ""
	property var regionToFilter: (region === "") ? false : true
	//example of region:
	//	"europe|USA" to have 2 regions
	//	"fr" french and france and fr ones ;-)
	
	//filter using lists for nb players
	property var nb_players: ""
	property var nb_playersToFilter: (nb_players === "1+") ? false : true
	property var minimumNb_players : nb_players.replace("+","")
	property var maximumNb_players: nb_players.includes("+") ? 5 : minimumNb_players
	
	//filter using lists for rating
	property var rating: "1.0"
	property var ratingToFilter: (rating === "All") ? false : true
	property var minimumRating : (rating !== "All") ? parseFloat(rating.replace("+","")) : 1.0
	
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
	
	property var filename: ""
	property var filenameToFilter: (filename === "") ? false : true
	
	property var release: ""
	property var releaseToFilter: (release === "") ? false : true
	
	property var exclusion: ""
	//example of exclusion:
	//"beta|virtual console|proto|rev|sega channel|classic collection|unl"
	property var toExclude: (exclusion === "") ? false : true
	
    //FILTERING
    SortFilterProxyModel {
        id: gamesMyCollection
        sourceModel:{
			if (system !== ""){
				for (var i = 0; i < api.collections.count; i++) {
					//console.log("api.collections.get(i).shortName: ",api.collections.get(i).shortName);
					if (api.collections.get(i).shortName === system) {
						//console.log("system: ",system);
						return api.collections.get(i).games
					}
				}
			}
			//if not found
			return api.allGames;
		}
	
        filters: [
			ValueFilter { roleName: "favorite"; value: favoriteToFind ; enabled: favoriteToFind},
			RegExpFilter { roleName: "title"; pattern: filter; caseSensitivity: Qt.CaseInsensitive;enabled: titleToFilter} ,
			RegExpFilter { roleName: "title"; pattern: region; caseSensitivity: Qt.CaseInsensitive; enabled: regionToFilter},
			RegExpFilter { roleName: "genre"; pattern: genre ; caseSensitivity: Qt.CaseInsensitive; enabled: genreToFilter},
			RangeFilter { roleName: "players"; minimumValue: minimumNb_players ; maximumValue: maximumNb_players; enabled: nb_playersToFilter},
			RegExpFilter { roleName: "publisher"; pattern: publisher ; caseSensitivity: Qt.CaseInsensitive; enabled: publisherToFilter},
			RegExpFilter { roleName: "developer"; pattern: developer ; caseSensitivity: Qt.CaseInsensitive; enabled: developerToFilter},
			RegExpFilter { roleName: "path"; pattern: filename ; caseSensitivity: Qt.CaseInsensitive; enabled: filenameToFilter},
			RegExpFilter { roleName: "releaseYear"; pattern: release ; caseSensitivity: Qt.CaseInsensitive; enabled: releaseToFilter},
			RegExpFilter { roleName: "title"; pattern: exclusion ; caseSensitivity: Qt.CaseInsensitive; inverted: true; enabled: toExclude},
			ExpressionFilter { expression: parseFloat(model.rating) >= minimumRating; enabled: ratingToFilter}        ]
		//sorters are slow that why it is deactivated for the moment
        //sorters: RoleSorter { roleName: "rating"; sortOrder: Qt.DescendingOrder; }
    }

    property var collection: {
        return {
            name:       collectionName + " : " + gamesMyCollection.count + " " + qsTr("game(s)") + api.tr,
            shortName:  "mycollection",
            games:      gamesMyCollection
        }
    }
}
