# Change Log
All notable changes to this project will be documented in this file (focus on change done on recalbox-integration branch).

## [myCollections-feature] - 2021-09-08
- first version to check feasability and performance
- draft new menu in settings for collections
- menu to manage save,edition,delete,adding for collection
- add dialog box to confirm deletion
- draft to dynamically repeat loader usage for ListCollection
- clean js file to remove functions too linked to showcase
- fix to add automatically My Collections in settings
- tentative to load all lists using loader
- finally load all lists in static and limit to 5
- increase limit to 10, clean and improve few behaviors
- improve delete/add behaviors and when no collection
- draft adding exclusions, publisher, dev & system
- tested version with all criteria except release date
- add Favorite & ReleaseYear as collection criteria
- to manage better deletion settings of collection
- optimisation for performance when collection name is empty or null
- add spinner during loading of showcaseView (main menu)
- fix when index saved is wrong - reset to 0 forced
- add loading details for home page (at start & after game)
- block OnPressed event if under loading to avoid mistake
- correct way to load and display spinner
- finally keep loading only when come back on it

## [gameinfo-improvements] - 2021-08-31
- add Release year and rework of GameDetails content
- add filename as optional in GameDetails info

## [arcade-helps-buttons] - 2021-08-29
- add 'arcade' helps buttons in each views and settings

## [recommended-gamelist-performance-improvements] - 2021-08-18
- fix binding warning using global variables from Utils
- add loaders to load "custom" lists asynchronously
- improve filtering for publisher and genre lists (clean not necessary lines also in recommended List)
- force to select a game to see video preview
- add utils.js import for Genre and Publisher lists
- solution found to keep showcaseview in background with video stop (need to put everywhere to manage to stop video)
- add "detailed_debug" global property - more logs for dev
- fix issue with first video of horizontal list using loaders
- add more logs for video loading for item Highlighted

## [recalbox-integration] - 2021-06-30
- 11-bug-system-logo-style-at-first-start-up

## [recalbox-integration] - 2021-06-30
- remove pdfjs component from this theme because now in /recalbox/scripts/pdfjs
- remove warning and replace depreacated method using connections
- force to wait update from gamelaunch before to come back to previous screen as gameview

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