import QtQuick 2.15
import "../Global"

HorizontalCollection {
    id: list
    property bool selected //: ListView.isCurrentItem
    property var currentList: list
    property var collection //: collection1
    property var objectModelIndex

    enabled: collection.enabled
    visible: collection.enabled

    height: collection.height

    itemWidth: collection.itemWidth
    itemHeight: collection.itemHeight

    title: {
        //console.log("collection.title:",collection.title);
        return collection.title;
    }
    search: collection.search

    focus: selected
    width: root.width - globalMargin * 2
    x: globalMargin - vpx(8)

    savedIndex: (storedHomePrimaryIndex === objectModelIndex) ? storedHomeSecondaryIndex : 0

    onActivateSelected: {
        videoToStop = true;
        storedHomeSecondaryIndex = currentIndex;
        storedHomePrimaryIndex = objectModelIndex;
    }
    onActivate: { if (!selected) { mainList.currentIndex = objectModelIndex; } }
    onListHighlighted: { sfxNav.play(); mainList.currentIndex = objectModelIndex; }
    onActiveFocusChanged: {
        //if(typeof(currentGame) !== "undefined") console.log("list1 - onActiveFocusChanged - currentGame : ",currentGame.title);
        //console.log("list1 - onActiveFocusChanged - currentList.savedIndex : ",currentList.savedIndex);
        //console.log("list1 - onActiveFocusChanged - storedHomeSecondaryIndex : ",storedHomeSecondaryIndex);
        //console.log("list1 - onActiveFocusChanged - objectModelIndex : ",objectModelIndex);
        //console.log("list1 - onActiveFocusChanged - storedHomePrimaryIndex : ",storedHomePrimaryIndex);

        //FIX: to return to good index in list - seems a bug of list udpates during loading of models when we come back from game
        if((currentList.savedIndex === storedHomeSecondaryIndex) && (objectModelIndex === storedHomePrimaryIndex)){
            if((typeof(currentGame) !== "undefined") && (currentGame !== null)){
                //console.log("list1 - currentGame : ",currentGame.files.get(0).path);
                //console.log("list1 - selectedGame : ",collection.search.currentGame(currentList.currentIndex).files.get(0).path);
                //check if same rom file or not
                if(currentGame.files.get(0).path !== collection.search.currentGame(currentList.currentIndex).files.get(0).path){
                    //console.log("list1 - not equal - collection.search.games.count : ", collection.search.games.count);
                    //In this case, we are searching the game in collection to an other Index
                    for(var i = 0;i < collection.search.games.count ;i++){
                        //console.log("list1 - foundGame : ",collection.search.currentGame(i).files.get(0).path);
                        if(collection.search.currentGame(i).files.get(0).path === currentGame.files.get(0).path){
                            //console.log("list1 - matchedGame : ",collection.search.currentGame(i).files.get(0).path);
                            currentList.savedIndex = i;
                            currentList.currentIndex = i;
                            //and reset the stored index
                            storedHomeSecondaryIndex = -1;
                            return;
                       }
                    }
                    //if currentGame is not in the list, we have to come back to zero in this case
                    currentList.savedIndex = 0;
                    currentList.currentIndex = 0;
                    //and reset the stored index
                    storedHomeSecondaryIndex = -1;
                }
            }
        }
    }
}
