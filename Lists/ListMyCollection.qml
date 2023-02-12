// gameOS theme for Pixl
//
// created by Bozo the Geek / 18/08/2021 for PixL
//

import QtQuick 2.12
import SortFilterProxyModel 0.2

Item {
    id: root

    readonly property var games: gamesMyCollection;
    property int max: gamesMyCollection.count;
    function currentGame(index) {
        if(gamesMyCollection.sourceModel !== null) return gamesMyCollection.sourceModel.get(gamesMyCollection.mapToSource(index));
        else return null;
	}	

    property bool hasCache : false
    property bool cacheCheckDone: false
    //function to check if cache was present before to launch collection creation
    //by this way we could avoid reload of collction not yet in cache
    function hasCacheInitially(){
        //to check only one time and initialy, to avoid disturb when we check after saving of cache for example
        if(cacheCheckDone === false){
            cacheCheckDone = true;
            hasCache =  api.memory.has(collectionRef + " - cache");
        }
        if(hasCache) console.log(collectionRef,"has cache initially");
        return hasCache;

    }

    function resetCache(){
        if(api.memory.has(collectionRef + " - cache")) {
            console.log(collectionRef,"cache reset");
            api.memory.unset(collectionRef + " - cache");
            hasCache = false;
        }
    }

    property var gamesIndexes: []
    function restoreFromCache(){
        if(api.memory.has(collectionRef + " - cache")){
            gamesIndexes = JSON.parse(api.memory.get(collectionRef + " - cache"));
            console.log(collectionRef,"restored from cache");
            //console.log("gamesIndexes.length : ",gamesIndexes.length);
            //console.log("gamesIndexes : ",gamesIndexes);
        }
        //do nothing if no cache
    }

    property bool savedToCache : false
    function saveToCache(){
        //reset just before
        gamesIndexes = [];
        var gameIndex;
        for(var i=0; i < gamesMyCollection.count ;i++){
            if((system !== "") && !systemToFilter){ //use a specific system
                gameIndex = api.allGames.toVarArray().findIndex(g => g === currentGame(i));
                //console.log("api.allGames.toVarArray().findIndex(g => g === currentGame(i)) : ", gameIndex);
            }
            else{ 
                gameIndex = gamesMyCollection.mapToSource(i);
                //console.log("gamesMyCollection.mapToSource(i) : ",gameIndex);
            }
            gamesIndexes.push(gameIndex);
        }
        console.log(collectionRef,"saved to cache");
        savedToCache = true; //to avoid reload when we save !!!
        //console.log("gamesIndexes : ",gamesIndexes);
        //console.log("gamesIndexes.sort() : ",gamesIndexes.sort((a, b) => a - b));
        //sort indexes before to save in cache to restore quickly later and without sorting impacts
        api.memory.set(collectionRef + " - cache", JSON.stringify(gamesIndexes.sort((a, b) => a - b)));
    }

    property bool completed : false
    Component.onCompleted: {
        //console.log("MyCollection Componenet.onCompleted");
        completed = true;
    }

    //reference of the collection as "My Collection 1, My Collection 2, etc..."
    property string collectionRef: ""
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
	
    //flag to authorize search !
    property bool readyForSearch : false

    //FILTERING
    SortFilterProxyModel {
        id: gamesMyCollection
        sourceModel:{
            if(settingsChanged || (readyForSearch === false) || !completed) return null;
            if ((system !== "") && !systemToFilter && !hasCache){
                for (var i = 0; i < api.collections.count; i++) {
                    //console.log("api.collections.get(i).shortName: ",api.collections.get(i).shortName);
                    if (api.collections.get(i).shortName === system) {
                        console.log(collectionRef," search from one system only: ",system);
                        return api.collections.get(i).games
                    }
                }
            }
            //if not found or empty or systems should be filetr by regex
            console.log(collectionRef," search from allGames");
            return api.allGames;
        }
        filters: [
            RegExpFilter { roleName: "systemShortName"; pattern: system; caseSensitivity: Qt.CaseInsensitive;enabled: systemToFilter && !hasCache} ,
            ValueFilter { roleName: "favorite"; value: favoriteToFind ; enabled: favoriteToFind && !hasCache},
            RegExpFilter { roleName: "title"; pattern: filter; caseSensitivity: Qt.CaseInsensitive;enabled: titleToFilter && !hasCache} ,
            RegExpFilter { roleName: "title"; pattern: region; caseSensitivity: Qt.CaseInsensitive; enabled: regionToFilter && !hasCache},
            RegExpFilter { roleName: "genre"; pattern: genre ; caseSensitivity: Qt.CaseInsensitive; enabled: genreToFilter && !hasCache},
            RangeFilter { roleName: "players"; minimumValue: minimumNb_players ; maximumValue: maximumNb_players; enabled: nb_playersToFilter && !hasCache},
            RegExpFilter { roleName: "publisher"; pattern: publisher ; caseSensitivity: Qt.CaseInsensitive; enabled: publisherToFilter && !hasCache},
            RegExpFilter { roleName: "developer"; pattern: developer ; caseSensitivity: Qt.CaseInsensitive; enabled: developerToFilter && !hasCache},
            RegExpFilter { roleName: "path"; pattern: filename ; caseSensitivity: Qt.CaseInsensitive; enabled: filenameToFilter && !hasCache},
            RegExpFilter { roleName: "releaseYear"; pattern: release ; caseSensitivity: Qt.CaseInsensitive; enabled: releaseToFilter && !hasCache},
            RegExpFilter { roleName: "title"; pattern: exclusion ; caseSensitivity: Qt.CaseInsensitive; inverted: true; enabled: toExclude && !hasCache},
            ExpressionFilter { expression: parseFloat(model.rating) >= minimumRating; enabled: ratingToFilter && !hasCache},
            //ExpressionFilter { expression: model.index <= 10; enabled: !!hasCache}
            //IndexFilter { minimumIndex: gamesIndexes[0]; maximumIndex: gamesIndexes[gamesIndexes.length-1]; arrayIndex: gamesIndexes; enabled: !!hasCache}
            IndexFilter { minimumIndex: gamesIndexes[0]; maximumIndex: gamesIndexes[gamesIndexes.length-1]; arrayIndex: gamesIndexes; enabled: hasCache}

            ]
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
