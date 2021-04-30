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
//
// updated by Bozo the Geek / 30/04/2021 for recalbox integration/performance
//

import QtQuick 2.0
import SortFilterProxyModel 0.2

Item {
id: root
    
    readonly property var games: gamesFiltered;
    function currentGame(index) { return api.allGames.get(gamesRecommended.mapToSource(index)) }
    property int max: gamesRecommended.count;
    
    property var randomletter: "";
    property var randomvalue: "";
    property var randomhashletter: "";
    
     property var lastindex: 0;
    property var lastresult: false;
        
     onGamesChanged: {
        lastindex = 0;
        lastresult = false;
        randomletter: "";
        randomvalue: "";
        randomhashletter: "";
    }

    function random(min, max)
    {
        do {
            var value = (Math.random() * (max - min)) + min;
            value = Utils.toNumberString(Utils.toRoundNumber(value,0.05));
            } while (randomvalue.includes(value));
        randomvalue = randomvalue + value;
        //console.log("randomvalue : ",value);
        return value;
    }

    function generateRandomLetter() {
        do{
            const alphabet = "012345678abcdefghijklmnopqrstuvwxyz"
            var value = alphabet[Math.floor(Math.random() * alphabet.length)];
        }while (randomletter.includes(value))
        randomletter = randomletter + value;
        //console.log("randomletter : ",value);
        return value;
    }

    function generateRandomFirstHashLetter() {
        do{
            const alphabet = "0123456789ABCDEF"
            var value = alphabet[Math.floor(Math.random() * alphabet.length)];
        }while (randomhashletter.includes(value))
        randomhashletter = randomhashletter + value;
        //console.log("randomhashletter : ",value);
        return value;
    }    

    SortFilterProxyModel {
    id: gamesRecommended
        sourceModel: api.allGames
        sorters: RoleSorter { roleName: "rating"; sortOrder: Qt.DescendingOrder; }
        filters:[RegExpFilter { roleName: "rating"; pattern: "(" + random(0.6,1.0) + "|" + random(0.6,1.0) + "|" + random(0.6,1.0) + "|" + random(0.6,1.0) + ")"; caseSensitivity: Qt.CaseInsensitive; },
                 //RegExpFilter { roleName: "title"; pattern: "^" + generateRandomLetter()  + "|" + "^" + generateRandomLetter()+ "|" + "^" + generateRandomLetter() + "|" + "^" + generateRandomLetter() + "|" + "^" + generateRandomLetter(); caseSensitivity: Qt.CaseInsensitive; },
                 RegExpFilter { roleName: "hash"; pattern: "^" + generateRandomFirstHashLetter() + "|" + "^" + generateRandomFirstHashLetter() + "|" + "^" + generateRandomFirstHashLetter() + "|" + "^" + generateRandomFirstHashLetter(); caseSensitivity: Qt.CaseInsensitive; },
                 ExpressionFilter {
                        expression: {
                              //to take on 1% only of games
                              return (Math.random() <= 0.01)
                        }
                 }
                ]
    }

    SortFilterProxyModel {
    id: gamesFiltered
        sourceModel: gamesRecommended
        filters: IndexFilter { maximumIndex: max - 1 }
    }

    property var collection: {
        return {
            name:       "Recommended Games", // in: " + randomletter +"/ hash: "  + randomhashletter + "/ rating: " + randomvalue,
            shortName:  "recommended",
            games:      gamesFiltered
        }
    }
}