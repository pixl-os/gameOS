# Change Log
All notable changes to this project will be documented in this file (focus on change done on recalbox-integration branch).

## [pixL-master] - 2023-0X-XX - v1.24
- new features:
	- management of "screenshots" specifically to be able to display it in this theme

- fixes:
	- fix banner video launching when no favorite exists
	- fix overlays usage in "embedded" mode used in vertical list
	- fix scrapped video using overlay with 16/9 ratio/black bars
	- fix to avoid to zoom video in case of "game & watch" system for preview video
	- fix to avoid to display system logo for embedded views in vertical lists

## [pixL-master] - 2023-07-28 - v1.23
- logo:
	- Add new sega model 2 system logos
	- Add new Nintendo Wii U system logos
- overlay:
	- Feature to keep possibility to find overlays without decorations in his .cfg name
	- Improvement to manage several types of overlays with custom, 720p and 1080p resolutions

## [pixL-master] - 2023-04-29 - v1.22
- new features:
	- restore gradient effect on system logos for gameView/grid/verticalList using parameters #[49]
- improvements:
	- 'my Collections':
		- improve usage of filtering by disabling if only one system requested
		- create empty collection to load quickly the empty ones
		- fix about list type without index that generate issues
		- add "cache" feature for My Collections including optimization
		- add possibility to exclude on file path
		- add parameter in My Collection to activate 'cache' usage
		- add System Manufacturer filtering + improve System filtering also
		- add sorting by default, name, release date, system, manufacturer and rating
		- update 'import' versions + video fix to avoid memory leaks for showCaseViewMenu
		- remove top genre/publisher buggy for showCaseViewMenu
		- dynamic collections loading for showcaseViewMenu / best memory management
		- fix sorting also when we use cache for collection
		- new translation fr due to change in settings + one fix
- logo:
	- Add new logos for system Switch
	- Add new logos for system Philips CDI
	- Add new logos for system Megaduck

## [pixL-master] - 2023-01-21 - v1.21
- new features:
	- add management of systems group activable in theme's general settings
	- adapt default parameters to well manage activation of groups, display of overlay/video/grid elements
	- sorting systems by name, release date or manufacturer
	- add a second sorting by name, release date or manufacturer criteria
	- 2 ways to display groups using one or 2 slots on screen
	- dynamic help to know how to pass from systems to group when we one slot
	- display of 'release date' under systems logo when sorting use it.
	- propose now to reload theme itself when settings changed
	- remove limit on favorite displayed in banner
	- 'My Collections' feature: 
		- add internal new flag to avoid process all List of Collectiions during change of settings
		- add filtering on several  systems as planned initially

- fixes:
	- improve back button usage in gameview and launchgame view
	- improve behavior with header and grid selection
	- improve collections selection after gameplay session
	- add cartridge media and improve orders
	- avoid display several times same assets from lists
	- control backgrounds list content to propose always fanart before screenshot as background asset
	- improve game launching
	- game exit on initial one in case of favorite launch from banner
	- typo on Details Hardware Picture 
	- save position on collection to well come back when we exit from game
	- manage better margin between menu and details/retroachievements parts
	- select game in collection from currentGame
	- change way to manage currentGame using index and not object that we can't well save in JSON format
	- manage more cases with collections
	- avoid error when game is not yet set for highlight object
	- save/restore searchTerm to be able to restore it after game session
	- reset searchTerm when we change system or group
	- avoid loading of collections during settings browsing
	- fix way to select type of collections by default + keep 3 collections only by default

- translations: 
	- done for new menus/helps/dialogbox

## [pixL-master] - 2022-11-18 - v1.20 
- new design management :
	- fix demo mode launched in game #[16]
	- fix for resolution upper than 1080p support in gameview #[17]
	
- other new feature:
	- optimize scan folder for load all media download by scraper
	- fix list of media
	- add logo for roms in base
	- set now version and details in theme.cfg for each release

- multi-languages-support :
	- fix in qml code to translate in french for collection 6 to 10 #[23]
	- fix in qml code to be able to translate in french for platform page style #[24]
	- add fr for wide and tall #[25]
	- correction wording "Meileurs" to "Meilleurs"

## [recalbox-integration] - 2022-09-12
- new design management :
	- Introduction of parameters to 'design' themes
	- first way to select list to be focus at theme loading 
	- new parameter to manage ratio of icon in systems list
	- add round beta logo and change screenshots to imageviewer
	- add more parameters to configure system logos
	- system list and logo sizing/position fixed
	- add support of system music for custom
	- add management of region and especially for systems list background for the moment
	- add recalbox.conf parameter to activate the designer from theme
	- manage default, custom or no theme logo in theme designer
	- add more ratio percentages capability from 5% to 100% now.
	- change default logo to use the pixl one
	- restore info to add favorites when video is displayed
	- add more parameters for video/favorites banner and systems list
	- improvement and flexibility for video management now (keep linked to favorites banner
	- add width for theme logo management
	- introduce new component in theme to manage details/description on systems
	- add screenscraper regional management
	- rework SettingsScreen to have dedicated "Designer" menu
	- beta version of detail lists, still to improve management of data/position
	- cleaning unused parameters for the moment from settings
	- integration of path expression to manage link/path dynamically
	- improvements to well manage backgrounds finally and other details for systems list
	- reactivation softwareListMenu + some adaptations
	- some fixes to well play/stop music
	- tentative using gameview directly
	- add "embedded" property to manage behavior in vertical list
	- to manage focus of embedded gameview, listview and helps
	- add feature for "embedded" + improvements shorcuts/helps
	- improve help for vertical game list view and assocaited commands
	- new feature to display hash (crc32) in game info
	- optimization of margin + auto horizontal scrolling for details and title
	- optimization to manage position in purcentage for embedded or not
	- keep focus on details when we come back in list
	- using purcentage to calculate size of logo for embedded or not gameview
	- add icon in media of gameview for manuals
	- change name and place for selection of grid or vertical list
	- add L1/R1 and L2/R2 management in vertical list
	- dynamic calculations for 1080p & 72Op overlays and all screen resolutions

- emulator-loading-improvements :
	- stop playing video if lost focus (onCanPlayVideoChanged)
	- deactivate LaunchGameScreen() in multiwindows cases
	- introduction of rotation animation for button component
	- introduce 'play game' button using spinner when game is launhed in multi-windows mode
	- change finally to use api and not any variable
	- usage of api.launchedgame in gameview to animate "play game" button
	- ignore L1/R2 if guide button is pressed
	- spinner management for game running in multi-windows mode
	- change using global variable to check Guide Button state
	
- multi-languages-support :
	- add project files to manage linguist tool now for translations
	- add first .ts files for fr, en_GB and en_US genarted by lupdate
	- Set QML files as source to be managed by Linguist tools
	- add first .qm files generated by lrelease in /lang directory
	- add robustness code if a field is not translated (still work)
	- for refresh list when locale name change
	- tag a maximum of string that we could translate in SettingsScreen using qsTr()
	- add qsTr() for all qml files
	- first full translation done for french
	- add more trad especially for sorting, showcase and my collection
	- add fix also for gridviewMenu

- other new feature:
	- select random game in games list with R1+L1 (from Grid or VerticalList)

- fixes :
	- replace many var by string, int or bool
	- fixes to ignore hotkeys in vertical list/grid/gameview to avoid issue when we switch in multi-windows using Hotkey + R1
	- fixes on video reading in background, in horizontal list during launching of game if we keep theme loaded.
	- fixes on header for search in case of grid and vertical list
	- fixes for clipping of horizontal list used in gameview and especially in vertical list
	- fixes on helpers and translation
	- fixes for API robustness and for parameters not yet available
	- fixes on logos
	- fixes on platform name display
	- update fr translation for randome game helper

## [recalbox-integration] - 2022-07-08
- New logos for: NAOMI 2, PORTS & Screenshots (5 by systems)

## [recalbox-integration] - 2022-06-03
-new feature to display logo as "beta" system when first emulator is low.

## [recalbox-integration] - 2022-05-30
- new overlays management feature:
	- new overlays/logos options for video/screenshot in gameview
	- manage overlays source from share_init(default) or share
	- fix to stretch video/screenshot in 4/3 by default
	- manage autoresize and custom overlays positionning
	- manage systems without overlay and to keep stretching
	- manage custom overlays for arcade/no-intro
	- fix for skylines dedicated & overlays reset to avoid bugs
	- fix to hide it during demo, just keep help at bottom/right
	- fix path of "input_overlay"
	- additional parameter to let show logo if no overlay for any system
	
- logos:
	- add 5 logos for system TRIFORCE
	- fix to update 5 logos for system ODYSSEY2
	- add 5 logos for system XBOX & CHIHIRO
	
- platform gridview display improvements:
	- change to use L1/R1 for letter nav & L2/R2 for system nav
	- fix to replace depreacted default value
	- fix on gridspacer to add more checked boxarts to calcualte right width ratio

## [recalbox-integration] - 2022-12-02
- demo mode: remove fading/lists and highlight in demo mode
- best fix for search access in system grid view
- select search directly from y/triangle button directly and not only filter
- setup of virtualkeyboard for search in theme
- leaning and migration of function in Pegasus's main.qml
- change selected way and add logs in comments
- set textfield in read-only for list of values parameter
- introduce demo resetting at OnRelease + fix on settings
- add virtual keyboard support in settings of theme
- fix in settings for desactivated edition for virtual keyboard
- fix in settings to use good variable type
- fix gridviewmenu to avoid to launch game from empty list and to gameview
- add Change & Edit word in help for settings
- fix showcaseLoader to load in all cases at start and after game ending
- fix for white/color logo in gameview

## [recalbox-integration] - 2021-12-31
- improve display of helpbar buttons in all case
- add helpbar button for netplay
- improve button for gamepad start and select
- add button and mechanism to hide or replace RA button
- add calling of Netplay Dialog box from main of pegasus
- adapt management of retroachievements with netplay button
- improve GameAchievements view
- netplay: add code to set game
- fix to have netplay button in helpbar only when it's activated
- gaemView: to use L1/R1 to change game in a system
- HorizontalCollection: little fix on undefined value tested
- demo mode: add demo mode using gameview
- demo mode: add check if video exists before to launch demo gameView
- demo mode: fix to avoid infinity loop on system not well scrapped
- initialize sortedGame to fix L2/R2 letter scrolling in gridviewmenu (system view)

## [recalbox-integration] - 2021-09-27
- fix settings for 'play stats' conf
- add new feature to change automatically favorite displayed in header of showcaseview

## [play-time-count-lastplayed-display-feature] - 2021-09-13
- add play time, play count and last played in game info and also in settings

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

## Version history branch master - 2021-08-30
v1.12
- Added support for sort_title

v1.11
- Added correct support for multi resolution images
- Added Epic logo
- Fixed highlight range mode for platform bar
- Fixed issue where back button would bring up the menu on launch game screen

v1.10
- New return from game design
- Made return from game screen appear for all collections to cover certain Windows cases

v1.09
- Added ability to sort by rating
- Reverting change from 1.08 that causes bug where video will play even when not on the screen. Further investigation required.

v1.08
- Significant performance increase in navigating pages

v1.07
- Added home settings (by @waldnercharles)
- Added advanced settings to adjust item ratios (by @waldnercharles)
- Added alphabet paging in platform view (by @waldnercharles)
- Added option to hide button help (defaults to on)
- Fixed issue with font named incorrectly
- Renamed settings sections

v1.06
- Adding GNU license
- Adding option for viewing box art in the grid view instead of dynamic content
- Adding mouse/touch support to settings
- Fixed settings button hover functionality

v1.05
- Added option to toggle mouse hover (off by default)
- Added option for blurring background in game view (off by default)
- Added option for turning off game logo in game view, or text only (shown by default)

v1.0
- Complete overhaul of the theme, rewritten from the ground up
- Focus on features and performance
- Added new home screen
- Added settings
- Added search and filtering
- Added dynamic collections for better game discoverability
- Many more additional changes and additions

v0.6.7.2
- Added autoscroll text for description

v0.6.7.1
- Fixed crash on Android
- Added WiiWare logo
- Hiding text title when selected (only happens when no logo is found)
- Fixed back button exiting game details when viewing video preview

v0.6.7
- Major performance improvements (thanks to @SinisterSpatula for finding the fix)
- Added controller help
- Brought back extra meta data for details
- Fixed grid videos continuing to play while in details
- Added flyer support (needed for arcade)
- Added Windows 10 logo for Windows games

v0.6.6
- Added support for PS2, PS3, Switch, 3DS, Wii and Wii U logos
- Added support for Launchbox logo selection
- Shortening GBA in platform menu if using full name
- Fixed Genesis logo being black

v0.6.5
- Greatly improved video thumbnail performance
- Re-added video thumbnails by default
- Cleaned up buttons for video preview on game details screen
- Added better support for landscape boxart
- Fix for misaligned platform selection text
- Fix for platform selection not defaulting to selected view

v0.6
- Added new default game details screen
- Added new default grid view without game details with to toggle
- Added column number options (for future update)
- Added theme support (for future update)
- Brought back collection title
- Video previews in thumbnail currently turned off to improve performance
- Various bug fixes (thanks to bedgoe, waldnercharles)

v0.5
- Updated to latest version of Pegasus
- Now remembers last game played

v0.4
- Updated platform menu for cleaner experience
- Removed blur when using platform menu to increase performance
- Button consistency across the board
- Fixed details page not elegantly displaying with no media
- Bug fixes

v0.3
- Favorites filter toggle (X button to add to favorites, Y button to view)
- Video preview feature for details
- Bug fixes

v0.2
- Details page
- Streamlined interface
- Various bug fixes
- Various QOL improvements

v0.1
- Initial release
