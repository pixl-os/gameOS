# Change Log
All notable changes to this project will be documented in this file (focus on change done on recalbox-integration branch).

## [recalbox-integration] - 2021-06-29
- remove pdfjs component from this theme because now in /recalbox/scripts/pdfjs

## [game-retroachievements-fix] - 2021-06-29
- tentative to add launchGame delay as GameView (500ms) for testing
- improve management of arrows up and down
- finally replace timer using signal as better trigger (using new manner from Pegasus also)

## [pdfjs-integration-as-scripts-in-os] - 2021-06-29
- to use pdf reader from os itself and reusable by other themes
- add file:// to load viewer.html

## [game-retroachievements-management] - 2021-06-28
- add item to manage GameAchievements in gameview
- add update of achievements just after playing
- add retroachievements management in GameView
- add icon .png for achievements button
- do selection from menu to list of badge
- add stability in qml loading for retroachievements
- few fixes on equality conditions
- create dedicated function for init & reset GUI
- update to have .svg for achievements button
- add up/down icons in achievements gridview

## [logo-optimisation] - 2021-06-27
- multi fix log
- replace all logopng for optimised logopng

## [logo-settings] - 2021-06-09
- bump all qt5 module on lastest version
- add logo sets systems on : white, black, color, steel, carbon
- Disable color mask on systems logo

## [logo-settings] - 2021-06-03
- add support of settings for logo sets
- fix color layout/background to be set as "Original" for default value
- add one logo as example for "color" style
- add and rename some logo to match with recalbox systems

## [recalbox-integration] - 2021-05-26
- Manual : fix to manage '&' character in name of pdf using EncodeURIComponent

## [xboxos-reuse] - 2021-05-24
- Get Clock from XboxOS (adding of setting to hide it)
- Get management of colors in settings from XboxOS (but adding of Original GameOS colors)
- Fix from XboxOS to activate Games paesing in system view using L2/R2 by defaults

## [recalbox-integration] - 2021-05-23
- Creation of this changelog file

## [performance-improvements] - 2021-05-14
- fix: recommended games improved
- improve code and results
- reduce gradient effect and place of media menu
- add games/screenshots count under buttons of the list of system

## [arcade-game-improvement] - 2021-04-24
- add marquee asset
- change name of the theme to find it easily in theme selection in menu
- to add more assets visible in GameView (all medias)
- add feature in media to manage/display manuals
- adding of pdfjs/viewer module directly in theme