# gameOS v1.20

![gameOS Pegasus theme](https://i.imgur.com/J4Jh4rq.jpg)

## gameOS theme for Pegasus Frontend

The goal of this theme is to create a modern game launcher that can fit in alongside other tvOS-like apps (sometimes called 10 foot user interfaces). gameOS is a theme for [Pegasus Frontend](http://pegasus-frontend.org/).

## Installation

[Download the latest version](https://github.com/pixl-os/gameOS/tree/pixL-master) and extract it in your [Pegasus theme directory](https://doc.pixl-os.com/le-theme-gameos/) under a folder called gameOS.

Windows users may need to install the [K-lite Codec Pack](https://www.codecguide.com/download_kl.htm) to get video playback working.

IMPORTANT: You need to have the latest version of Pegasus installed (not the current Stable release) otherwise you will get an error regarding Qt.Modules.

## Metadata

It is recommended to use [Skraper.net](http://www.skraper.net/) to acquire media assets for this theme. These are the minimum requirements for media scraping, although adding more could be useful for other themes or the future:

- video
- screenshot
- fanart
- box 2d
- wheel

Skraper will place these in your roms folder under another folder called media.

If no media files are showing up, make sure that Skraper Assets is checked in the Additional Data Sources section of Pegasus settings. It may also be preferable to convert the created gamelist.xml (assuming EmulationStation was chosen for the game list in Skraper) to a metadata.txt file using the [Pegasus conversion tool](http://pegasus-frontend.org/tools/convert/)