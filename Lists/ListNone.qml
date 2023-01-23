//To manage quickly when list is empty
//Created by BozoTheGeek, 23/01/2023

import QtQuick 2.12
import SortFilterProxyModel 0.2

Item {
    id: root
    
    readonly property alias games: gamesFiltered
    function currentGame(index) { return api.allGames.get(gamesFiltered.mapToSource(index)) }
    property int max: gamesFiltered.count

    SortFilterProxyModel {
        id: gamesFiltered
        sourceModel: {
            return null;
        }
    }

    property var collection: {
        return {
            name:       qsTr("All games") + api.tr,
            shortName:  "allgames",
            games:      gamesFiltered
        }
    }
}
