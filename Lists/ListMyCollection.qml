// gameOS theme for Pixl
//
// created by Bozo the Geek / 18/08/2021 for PixL
//

import QtQuick 2.12
import SortFilterProxyModel 0.2

Item {
    id: root

    readonly property var games: {
        //check if cache exists for this collection with by name of the collection
        //to do


        //else
        return gamesMyCollection;
    }
    property int max: gamesMyCollection.count;
    function currentGame(index) {
        if(gamesMyCollection.sourceModel !== null) return gamesMyCollection.sourceModel.get(gamesMyCollection.mapToSource(index));
        else return null;
	}	

    property var gamesIndexes: []

    function hasCache(){
        return api.memory.has(collectionName)
    }

    function restoreFromCache(){
        gamesIndexes = JSON.parse(api.memory.get(collectionName));
    }

    function saveToCache(){
        for(var i=0; i < gamesMyCollection.count ;i++){
            const gameIndex = api.allGames.toVarArray().findIndex(g => g === currentGame(index));
            gamesIndexes.push(gameIndex);
        }
        api.memory.set(collectionName, JSON.stringify(gamesIndexes));
    }

	//name of the collection
    property string collectionName: ""
	
	//filter on favorite
    property string favorite: "No"
    property bool favoriteToFind: (favorite === "No") ? false : true
		
	//filter on "title"
    property string filter: ""
    property bool titleToFilter: (filter === "") ? false : true
	
    property string region: ""
    property bool regionToFilter: (region === "") ? false : true
	//example of region:
	//	"europe|USA" to have 2 regions
	//	"fr" french and france and fr ones ;-)
	
	//filter using lists for nb players
    property string nb_players: ""
    property bool nb_playersToFilter: (nb_players === "1+") ? false : true
    property string minimumNb_players : nb_players.replace("+","")
	property var maximumNb_players: nb_players.includes("+") ? 5 : minimumNb_players
	
	//filter using lists for rating
    property string rating: "1.0"
    property bool ratingToFilter: (rating === "All") ? false : true
	property var minimumRating : (rating !== "All") ? parseFloat(rating.replace("+","")) : 1.0
	
	//additional filters
    property string genre: ""
    property bool genreToFilter: (genre === "") ? false : true
	//example of genre:
	//	"plateforme|platform"
	
    property string publisher: ""
    property bool publisherToFilter: (publisher === "") ? false : true
	//example of publisher:
	//	"nintendo"
	
    property string developer: ""
    property bool developerToFilter: (developer === "") ? false : true
	//example of developer:
	//	"sega"
	
    property string system: ""
    property bool systemToFilter: ((system === "") || !system.includes("|")) ? false : true

	//example of system:
    //	"nes|snes|gw"
    //if only one word, the filter will be not activated
    //we prefer to select collection in this case from sourceModel to improve performance of filtering/sorting
	
    property string filename: ""
    property bool filenameToFilter: (filename === "") ? false : true
	
    property string release: ""
    property bool releaseToFilter: (release === "") ? false : true
	
    property string exclusion: ""
	//example of exclusion:
	//"beta|virtual console|proto|rev|sega channel|classic collection|unl"
    property bool toExclude: (exclusion === "") ? false : true
	
    //FILTERING
    SortFilterProxyModel {
        id: gamesMyCollection
        sourceModel:{
            if(settingsChanged) return null;
            //check if any cache memory exist with this name of collection
            if ((system !== "") && !systemToFilter){
                for (var i = 0; i < api.collections.count; i++) {
                    //console.log("api.collections.get(i).shortName: ",api.collections.get(i).shortName);
                    if (api.collections.get(i).shortName === system) {
                        console.log("system: ",system);
                        return api.collections.get(i).games
                    }
                }
            }
            //if not found or empty or systems should be filetr by regexx
            return api.allGames;
        }
        filters: [
            RegExpFilter { roleName: "systemShortName"; pattern: system; caseSensitivity: Qt.CaseInsensitive;enabled: systemToFilter} ,
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
            //sorters: RoleSorter { roleName: "title"; sortOrder: Qt.AscendingOrder; enabled: true}
            sorters: RoleSorter { roleName: "releaseYear"; sortOrder: Qt.AscendingOrder; enabled: true}
    }

    property var collection: {
        return {
            name:       collectionName + " : " + gamesMyCollection.count + (gamesMyCollection.count > 1 ? (" " + qsTr("games") + api.tr) : (" " + qsTr("game") + api.tr)),
            shortName:  "mycollection",
            games:      gamesMyCollection
        }
    }
}
