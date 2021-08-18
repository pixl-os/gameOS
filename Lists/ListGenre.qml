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

import QtQuick 2.12
import SortFilterProxyModel 0.2
import "../utils.js" as Utils

Item {
    id: root
    
    readonly property alias games: gamesFiltered
    function currentGame(index) { return api.allGames.get(genreGames.mapToSource(index)) }
    property int max: genreGames.count
    property string genre: ""

    SortFilterProxyModel {
        id: genreGames

        sourceModel: api.allGames
        sorters: RoleSorter { roleName: "rating"; sortOrder: Qt.DescendingOrder }
        filters:[RegExpFilter{ roleName: "genre"; pattern: "^" + genre + "$"; caseSensitivity: Qt.CaseInsensitive; },
                 RegExpFilter { roleName: "hash"; pattern: Utils.regExpForHashFiltering(); caseSensitivity: Qt.CaseInsensitive; }, // USE HASH to avoid consecutive same games on different regions
                  ExpressionFilter {
                     expression: {
                         return (Math.random() <= 0.33); // to get 1/3 of games total.
                     }
                  }
		]
    }

    SortFilterProxyModel {
        id: gamesFiltered

        sourceModel: genreGames
        filters: IndexFilter { maximumIndex: max - 1 }
    }

    property var collection: {
        return {
            name:       "Top " + genre + " Games",
            shortName:  genre + "games",
            games:      gamesFiltered
        }
    }
}
